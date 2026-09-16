import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/supabase_constants.dart';
import '../decks/deck_model.dart';
import '../decks/deck_repository.dart';

class GameManagementScreen extends ConsumerStatefulWidget {
  const GameManagementScreen({super.key});

  @override
  ConsumerState<GameManagementScreen> createState() => _GameManagementScreenState();
}

class _GameManagementScreenState extends ConsumerState<GameManagementScreen> {
  void _showAddGameDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Neues TCG hinzufügen'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Name des Kartenspiels',
            hintText: 'z. B. Weiß Schwarz',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Abbrechen')),
          ElevatedButton(
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                final user = supabase.auth.currentUser;
                await supabase.from('games').insert({
                  'name': name,
                  'is_custom': true,
                  'created_by': user?.id,
                });
                ref.invalidate(gamesListProvider);
                if (mounted) Navigator.pop(ctx);
              }
            },
            child: const Text('Hinzufügen'),
          ),
        ],
      ),
    );
  }

  void _showRenameDialog(Game game) {
    final controller = TextEditingController(text: game.name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('TCG umbenennen'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Neuer Name', border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Abbrechen')),
          ElevatedButton(
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isNotEmpty && name != game.name) {
                await supabase.from('games').update({'name': name}).eq('id', game.id);
                ref.invalidate(gamesListProvider);
                if (mounted) Navigator.pop(ctx);
              }
            },
            child: const Text('Speichern'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gamesAsync = ref.watch(gamesListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kartenspiele (TCGs) verwalten'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Neues Spiel hinzufügen',
            onPressed: _showAddGameDialog,
          ),
        ],
      ),
      body: gamesAsync.when(
        data: (games) => ListView.separated(
          itemCount: games.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final game = games[index];
            return ListTile(
              leading: const Icon(Icons.style_outlined),
              title: Text(game.name, style: const TextStyle(fontWeight: FontWeight.w600)),
              trailing: IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20),
                onPressed: () => _showRenameDialog(game),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Fehler beim Laden: $err')),
      ),
    );
  }
}