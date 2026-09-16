import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../settings/app_preferences_service.dart';
import 'match_model.dart';
import 'match_repository.dart';

class AddMatchDialog extends ConsumerStatefulWidget {
  final String deckId;
  final String gameId;
  final MatchRecord? match; // null = neu, nicht-null = bearbeiten

  const AddMatchDialog({
    super.key,
    required this.deckId,
    required this.gameId,
    this.match,
  });

  @override
  ConsumerState<AddMatchDialog> createState() => _AddMatchDialogState();
}

class _AddMatchDialogState extends ConsumerState<AddMatchDialog> {
  late final TextEditingController _opponentDeckController;
  late final TextEditingController _scoreController;
  late final TextEditingController _notesController;

  late String _result;
  late String _format;
  late String _turnOrder;
  late List<String> _selectedTags;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final m = widget.match;
    final defaultPrefs = ref.read(appPreferencesProvider);

    _opponentDeckController = TextEditingController(text: m?.opponentDeck ?? '');
    _scoreController = TextEditingController(text: m?.score ?? '');
    _notesController = TextEditingController(text: m?.notes ?? '');
    _result = m?.result ?? 'win';
    _format = m?.matchFormat ?? defaultPrefs.defaultFormat;
    _turnOrder = m?.turnOrder ??
        (defaultPrefs.defaultTurnOrder == 'none' ? 'first' : defaultPrefs.defaultTurnOrder);

    // Tags übernehmen: Existierendes Match ODER gemerkte Tags ODER leer
    if (m != null) {
      _selectedTags = List<String>.from(m.tags);
    } else if (defaultPrefs.rememberLastTags) {
      _selectedTags = List<String>.from(defaultPrefs.lastUsedTags);
    } else {
      _selectedTags = [];
    }
  }

  @override
  void dispose() {
    _opponentDeckController.dispose();
    _scoreController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final opponentDeck = _opponentDeckController.text.trim();
    if (opponentDeck.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte das gegnerische Deck angeben.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(matchRepositoryProvider);

      if (widget.match != null) {
        await repo.updateMatch(
          matchId: widget.match!.id,
          opponentDeck: opponentDeck,
          result: _result,
          matchFormat: _format,
          score: _scoreController.text.trim().isEmpty ? null : _scoreController.text.trim(),
          turnOrder: _turnOrder,
          tags: _selectedTags,
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        );
      } else {
        await repo.addMatch(
          deckId: widget.deckId,
          opponentDeck: opponentDeck,
          result: _result,
          matchFormat: _format,
          score: _scoreController.text.trim().isEmpty ? null : _scoreController.text.trim(),
          turnOrder: _turnOrder,
          tags: _selectedTags,
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        );
      }

      // Falls gewünscht: Gewählte Tags für das nächste Match merken
      if (ref.read(appPreferencesProvider).rememberLastTags) {
        ref.read(appPreferencesProvider.notifier).setLastUsedTags(_selectedTags);
      }

      ref.invalidate(deckMatchesProvider(widget.deckId));
      ref.invalidate(archetypesProvider(widget.gameId));

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
    final archetypesAsync = ref.watch(archetypesProvider(widget.gameId));
    final allAvailableTags = ref.watch(appPreferencesProvider).allAvailableTags;
    final isEditing = widget.match != null;

    return AlertDialog(
      title: Text(isEditing ? 'Match bearbeiten' : 'Match eintragen'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'win', label: Text('Sieg'), icon: Icon(Icons.check, color: Colors.green)),
                ButtonSegment(value: 'loss', label: Text('Niederlage'), icon: Icon(Icons.close, color: Colors.red)),
                ButtonSegment(value: 'draw', label: Text('Unentsch.'), icon: Icon(Icons.remove, color: Colors.grey)),
              ],
              selected: {_result},
              onSelectionChanged: (set) => setState(() => _result = set.first),
            ),
            const SizedBox(height: 16),
            archetypesAsync.when(
              data: (archetypes) => Autocomplete<String>(
                initialValue: TextEditingValue(text: _opponentDeckController.text),
                optionsBuilder: (textEditingValue) {
                  if (textEditingValue.text.isEmpty) return const Iterable<String>.empty();
                  return archetypes.where((option) =>
                      option.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                },
                onSelected: (selection) => _opponentDeckController.text = selection,
                fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                  controller.addListener(() {
                    _opponentDeckController.text = controller.text;
                  });
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      labelText: 'Gegnerisches Deck / Archetyp',
                      border: OutlineInputBorder(),
                    ),
                  );
                },
              ),
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => TextField(
                controller: _opponentDeckController,
                decoration: const InputDecoration(
                  labelText: 'Gegnerisches Deck',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _format,
                    decoration: const InputDecoration(labelText: 'Format', border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(value: 'bo1', child: Text('Best of 1')),
                      DropdownMenuItem(value: 'bo3', child: Text('Best of 3')),
                    ],
                    onChanged: (val) => setState(() => _format = val!),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _turnOrder,
                    decoration: const InputDecoration(labelText: 'Reihenfolge', border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(value: 'first', child: Text('1st (Beginn)')),
                      DropdownMenuItem(value: 'second', child: Text('2nd (Zweiter)')),
                    ],
                    onChanged: (val) => setState(() => _turnOrder = val!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Event-Tags', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              children: allAvailableTags.map((tag) {
                final isSelected = _selectedTags.contains(tag);
                return FilterChip(
                  label: Text(tag),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedTags.add(tag);
                      } else {
                        _selectedTags.remove(tag);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _scoreController,
              decoration: const InputDecoration(
                labelText: 'Score (optional, z. B. 2-1)',
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