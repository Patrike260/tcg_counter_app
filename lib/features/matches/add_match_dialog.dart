import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/l10n.dart';
import '../settings/app_preferences_service.dart';
import '../stats/dashboard_repository.dart';
import 'match_model.dart';
import 'match_repository.dart';

class AddMatchDialog extends ConsumerStatefulWidget {
  final String deckId;
  final String gameId;
  final MatchRecord? match; // null = neu, nicht-null = bearbeiten
  final String? suggestedResult;
  final String? suggestedScore;
  final String? suggestedNotes;

  const AddMatchDialog({
    super.key,
    required this.deckId,
    required this.gameId,
    this.match,
    this.suggestedResult,
    this.suggestedScore,
    this.suggestedNotes,
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
    _scoreController = TextEditingController(
      text: m?.score ?? widget.suggestedScore ?? '',
    );
    _notesController = TextEditingController(
      text: m?.notes ?? widget.suggestedNotes ?? '',
    );
    _result = m?.result ?? widget.suggestedResult ?? 'win';
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
        SnackBar(content: Text(context.l10n.needOpponentDeck)),
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
      ref.invalidate(deckMatchSummariesProvider);
      ref.invalidate(dashboardDataProvider);

      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.errorWithDetails(e)), backgroundColor: Colors.red),
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
    final l10n = context.l10n;

    return AlertDialog(
      title: Text(isEditing ? l10n.editMatch : l10n.logMatch),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                _ResultChoiceButton(
                  label: l10n.win,
                  icon: Icons.check_circle,
                  color: Colors.greenAccent,
                  selected: _result == 'win',
                  onTap: () => setState(() => _result = 'win'),
                ),
                const SizedBox(width: 10),
                _ResultChoiceButton(
                  label: l10n.loss,
                  icon: Icons.cancel,
                  color: Colors.redAccent,
                  selected: _result == 'loss',
                  onTap: () => setState(() => _result = 'loss'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: FilterChip(
                avatar: Icon(
                  Icons.remove_circle_outline,
                  size: 18,
                  color: _result == 'draw' ? Colors.grey.shade200 : Colors.grey,
                ),
                label: Text(l10n.draw),
                selected: _result == 'draw',
                onSelected: (_) => setState(() => _result = 'draw'),
              ),
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
                    decoration: InputDecoration(
                      labelText: l10n.opponentDeckArchetype,
                      border: const OutlineInputBorder(),
                    ),
                  );
                },
              ),
              loading: () => const LinearProgressIndicator(),
              error: (_, _) => TextField(
                controller: _opponentDeckController,
                decoration: InputDecoration(
                  labelText: l10n.opponentDeck,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _format,
                    decoration: InputDecoration(labelText: l10n.format, border: const OutlineInputBorder()),
                    items: [
                      DropdownMenuItem(value: 'bo1', child: Text(l10n.formatBo1)),
                      DropdownMenuItem(value: 'bo3', child: Text(l10n.formatBo3)),
                    ],
                    onChanged: (val) => setState(() => _format = val!),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _turnOrder,
                    decoration: InputDecoration(labelText: l10n.order, border: const OutlineInputBorder()),
                    items: [
                      DropdownMenuItem(value: 'first', child: Text(l10n.turnFirstFull)),
                      DropdownMenuItem(value: 'second', child: Text(l10n.turnSecondFull)),
                    ],
                    onChanged: (val) => setState(() => _turnOrder = val!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(l10n.eventTags, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
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
              decoration: InputDecoration(
                labelText: l10n.scoreOptional,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: l10n.notesOptional,
                border: const OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.save),
        ),
      ],
    );
  }
}

class _ResultChoiceButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _ResultChoiceButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: selected ? color.withValues(alpha: 0.22) : Colors.white10,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 88,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected ? color : Colors.white24,
                width: selected ? 2.5 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 36),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: selected ? color : Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
