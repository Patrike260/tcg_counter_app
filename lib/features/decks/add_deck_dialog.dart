import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'deck_model.dart';
import 'deck_repository.dart';

class AddDeckDialog extends ConsumerStatefulWidget {
  const AddDeckDialog({super.key});

  @override
  ConsumerState<AddDeckDialog> createState() => _AddDeckDialogState();
}

class _AddDeckDialogState extends ConsumerState<AddDeckDialog> {
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  String? _selectedGameId;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty || _selectedGameId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte ein Spiel wählen und einen Decknamen eingeben.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(deckRepositoryProvider).createDeck(
            gameId: _selectedGameId!,
            name: name,
            notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
          );

      // Deck-Liste aktualisieren
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

    return AlertDialog(
      title: const Text('Neues Deck anlegen'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            gamesAsync.when(
              data: (games) => DropdownButtonFormField<String>(
                value: _selectedGameId,
                decoration: const InputDecoration(labelText: 'Kartenspiel'),
                items: games
                    .map((g) => DropdownMenuItem(value: g.id, child: Text(g.name)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedGameId = val),
              ),
              loading: () => const LinearProgressIndicator(),
              error: (err, _) => Text('Fehler beim Laden: $err'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Deck-Name (z. B. Charizard ex)',
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
              : const Text('Speichern'),
        ),
      ],
    );
  }
}