import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/widgets/game_logo.dart';
import 'deck_model.dart';
import 'deck_repository.dart';
import '../settings/app_preferences_service.dart';

class AddDeckDialog extends ConsumerStatefulWidget {
  final Deck? deck; // null = neu, nicht-null = bearbeiten

  const AddDeckDialog({super.key, this.deck});

  @override
  ConsumerState<AddDeckDialog> createState() => _AddDeckDialogState();
}

class _AddDeckDialogState extends ConsumerState<AddDeckDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _notesController;
  String? _selectedGameId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.deck?.name ?? '');
    _notesController = TextEditingController(text: widget.deck?.notes ?? '');
    final defaultPrefs = ref.read(appPreferencesProvider);
    _selectedGameId = widget.deck?.gameId ?? defaultPrefs.resolvedDefaultGameId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty || (_selectedGameId == null && widget.deck == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte alle Pflichtfelder ausfüllen.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(deckRepositoryProvider);

      if (widget.deck != null) {
        await repo.updateDeck(
          deckId: widget.deck!.id,
          name: name,
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        );
      } else {
        await repo.createDeck(
          gameId: _selectedGameId!,
          name: name,
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        );
      }

      ref.invalidate(userDecksProvider);

      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final gamesAsync = ref.watch(gamesListProvider);
    final hiddenGameIds = ref.watch(appPreferencesProvider).hiddenGameIds;
    final isEditing = widget.deck != null;

    return AlertDialog(
      title: Text(isEditing ? 'Deck bearbeiten' : 'Neues Deck anlegen'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            gamesAsync.when(
              data: (games) {
                final keepGameId = widget.deck?.gameId ?? _selectedGameId;
                final visibleGames = games.where((g) {
                  if (!hiddenGameIds.contains(g.id)) return true;
                  return g.id == keepGameId;
                }).toList();
                final selectedId = visibleGames.any((g) => g.id == _selectedGameId)
                    ? _selectedGameId
                    : null;

                return DropdownButtonFormField<String>(
                  value: selectedId,
                  decoration: const InputDecoration(labelText: 'Kartenspiel'),
                  hint: const Text('Kartenspiel wählen'),
                  items: visibleGames
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
                  onChanged: isEditing
                      ? null
                      : (val) => setState(() => _selectedGameId = val),
                );
              },
              loading: () => const LinearProgressIndicator(),
              error: (err, _) => Text('Fehler beim Laden: $err'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Deck-Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notizen (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Abbrechen'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(isEditing ? 'Aktualisieren' : 'Speichern'),
        ),
      ],
    );
  }
}