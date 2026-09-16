import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/supabase_constants.dart';
import '../../core/widgets/game_logo.dart';
import '../decks/deck_model.dart';
import '../decks/deck_repository.dart';

class ArchetypeManagementScreen extends ConsumerStatefulWidget {
  const ArchetypeManagementScreen({super.key});

  @override
  ConsumerState<ArchetypeManagementScreen> createState() => _ArchetypeManagementScreenState();
}

class _ArchetypeManagementScreenState extends ConsumerState<ArchetypeManagementScreen> {
  String? _selectedGameId;
  List<Map<String, dynamic>> _archetypes = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gamesAsync = ref.read(gamesListProvider);
      gamesAsync.whenData((games) {
        if (games.isNotEmpty && mounted) {
          setState(() => _selectedGameId = games.first.id);
          _loadArchetypes(games.first.id);
        }
      });
    });
  }

  Future<void> _loadArchetypes(String gameId) async {
    setState(() => _isLoading = true);
    try {
      final user = supabase.auth.currentUser;
      final response = await supabase
          .from('archetypes')
          .select('id, name, created_by')
          .eq('game_id', gameId)
          .order('name');

      if (mounted) {
        setState(() {
          _archetypes = List<Map<String, dynamic>>.from(response as List);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Laden: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteArchetype(Map<String, dynamic> item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Archetyp löschen?'),
        content: Text('Soll "${item['name']}" aus den automatischen Vorschlägen entfernt werden?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Abbrechen')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await supabase.from('archetypes').delete().eq('id', item['id']);
      if (_selectedGameId != null) _loadArchetypes(_selectedGameId!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('"${item['name']}" gelöscht.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Löschen: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _renameArchetype(Map<String, dynamic> item) async {
    final controller = TextEditingController(text: item['name']);

    final newName = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Archetyp umbenennen'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Neuer Name', border: OutlineInputBorder()),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Abbrechen')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Speichern'),
          ),
        ],
      ),
    );

    if (newName == null || newName.isEmpty || newName == item['name']) return;

    try {
      await supabase.from('archetypes').update({'name': newName}).eq('id', item['id']);
      if (_selectedGameId != null) _loadArchetypes(_selectedGameId!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Umbenannt in "$newName".')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Umbenennen: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final gamesAsync = ref.watch(gamesListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gegner-Archetypen verwalten'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: gamesAsync.when(
              data: (games) => DropdownButtonFormField<String>(
                value: _selectedGameId,
                decoration: const InputDecoration(
                  labelText: 'Kartenspiel wählen',
                  border: OutlineInputBorder(),
                ),
                items: games
                    .map(
                      (g) => DropdownMenuItem(
                        value: g.id,
                        child: Row(
                          children: [
                            GameLogo(gameName: g.name, size: 20),
                            const SizedBox(width: 8),
                            Text(g.name),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedGameId = val);
                    _loadArchetypes(val);
                  }
                },
              ),
              loading: () => const LinearProgressIndicator(),
              error: (err, _) => Text('Fehler: $err'),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _archetypes.isEmpty
                    ? const Center(child: Text('Keine Archetypen für dieses TCG vorhanden.'))
                    : ListView.separated(
                        itemCount: _archetypes.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final item = _archetypes[index];
                          return ListTile(
                            leading: const Icon(Icons.style_outlined),
                            title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.w600)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined, size: 20),
                                  onPressed: () => _renameArchetype(item),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 20, color: Colors.redAccent),
                                  onPressed: () => _deleteArchetype(item),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}