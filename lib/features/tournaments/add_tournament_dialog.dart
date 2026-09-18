import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/widgets/game_logo.dart';
import '../../l10n/l10n.dart';
import '../decks/deck_model.dart';
import '../decks/deck_repository.dart';
import '../settings/app_preferences_service.dart';
import 'tournament_model.dart';
import 'tournament_repository.dart';

class AddTournamentDialog extends ConsumerStatefulWidget {
  final Tournament? tournament;

  const AddTournamentDialog({super.key, this.tournament});

  @override
  ConsumerState<AddTournamentDialog> createState() => _AddTournamentDialogState();
}

class _AddTournamentDialogState extends ConsumerState<AddTournamentDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _notesController;
  late final TextEditingController _placementController;
  late final TextEditingController _participantsController;
  late DateTime _tournamentDate;
  String? _selectedGameId;
  String? _selectedDeckId;
  late List<String> _selectedTags;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final existing = widget.tournament;
    final prefs = ref.read(appPreferencesProvider);
    _nameController = TextEditingController(text: existing?.name ?? '');
    _notesController = TextEditingController(text: existing?.notes ?? '');
    _placementController = TextEditingController(
      text: existing?.placement?.toString() ?? '',
    );
    _participantsController = TextEditingController(
      text: existing?.totalParticipants?.toString() ?? '',
    );
    _tournamentDate = existing?.tournamentDate ?? DateTime.now();
    _selectedGameId = existing?.gameId ?? prefs.resolvedDefaultGameId;
    _selectedDeckId = existing?.deckId;
    if (existing != null) {
      _selectedTags = List<String>.from(existing.tags);
    } else if (prefs.rememberLastTags) {
      _selectedTags = List<String>.from(prefs.lastUsedTags);
    } else {
      _selectedTags = [];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    _placementController.dispose();
    _participantsController.dispose();
    super.dispose();
  }

  int? _parseOptionalInt(String raw) {
    final value = raw.trim();
    if (value.isEmpty) return null;
    return int.tryParse(value);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tournamentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _tournamentDate = picked);
    }
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty || _selectedGameId == null || _selectedDeckId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.needNameTcgDeck)),
      );
      return;
    }

    final placement = _parseOptionalInt(_placementController.text);
    final participants = _parseOptionalInt(_participantsController.text);
    if (_placementController.text.trim().isNotEmpty && placement == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.placementMustBeNumber)),
      );
      return;
    }
    if (_participantsController.text.trim().isNotEmpty && participants == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.participantsMustBeNumber)),
      );
      return;
    }
    if (placement != null && placement < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.placementMinOne)),
      );
      return;
    }
    if (participants != null && placement != null && placement > participants) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.placementVsField)),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final repo = ref.read(tournamentRepositoryProvider);
      final notes = _notesController.text.trim();
      if (widget.tournament != null) {
        await repo.updateTournament(
          tournamentId: widget.tournament!.id,
          gameId: _selectedGameId!,
          deckId: _selectedDeckId!,
          name: name,
          tournamentDate: _tournamentDate,
          placement: placement,
          totalParticipants: participants,
          notes: notes.isEmpty ? null : notes,
          tags: _selectedTags,
        );
      } else {
        await repo.createTournament(
          gameId: _selectedGameId!,
          deckId: _selectedDeckId!,
          name: name,
          tournamentDate: _tournamentDate,
          placement: placement,
          totalParticipants: participants,
          notes: notes.isEmpty ? null : notes,
          tags: _selectedTags,
        );
      }
      if (ref.read(appPreferencesProvider).rememberLastTags) {
        ref.read(appPreferencesProvider.notifier).setLastUsedTags(_selectedTags);
      }
      ref.invalidate(tournamentsListProvider);
      ref.invalidate(tournamentsStreamProvider);
      ref.invalidate(tournamentRelatedMatchesProvider);
      if (mounted) Navigator.of(context).pop(true);
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

  String _dateLabel(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day.$month.${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final gamesAsync = ref.watch(gamesListProvider);
    final decksAsync = ref.watch(userDecksProvider);
    final hiddenGameIds = ref.watch(appPreferencesProvider).hiddenGameIds;
    final isEditing = widget.tournament != null;
    final scheme = Theme.of(context).colorScheme;
    final maxWidth = MediaQuery.sizeOf(context).width;
    final dialogWidth = maxWidth >= 520 ? 460.0 : maxWidth - 48;
    final l10n = context.l10n;

    return AlertDialog(
      title: Text(isEditing ? l10n.editTournament : l10n.addTournament),
      content: SizedBox(
        width: dialogWidth,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.tournamentName,
                hintText: 'Bandai Card Fest, Store Championship, …',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            gamesAsync.when(
              data: (games) {
                final keepGameId = widget.tournament?.gameId ?? _selectedGameId;
                final visibleGames = games.where((game) {
                  if (!hiddenGameIds.contains(game.id)) return true;
                  return game.id == keepGameId;
                }).toList();
                final selectedId = visibleGames.any((game) => game.id == _selectedGameId)
                    ? _selectedGameId
                    : null;

                return DropdownButtonFormField<String>(
                  key: ValueKey('tournament-game-$selectedId'),
                  initialValue: selectedId,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: l10n.cardGame,
                    border: const OutlineInputBorder(),
                  ),
                  hint: Text(l10n.chooseTcg),
                  items: visibleGames
                      .map(
                        (game) => DropdownMenuItem(
                          value: game.id,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GameLogo(gameName: game.name, size: 20),
                              const SizedBox(width: 8),
                              Text(game.name, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedGameId = value;
                      _selectedDeckId = null;
                    });
                  },
                );
              },
              loading: () => const SizedBox(height: 4, child: LinearProgressIndicator()),
              error: (err, _) => Text(l10n.gamesLoadError(err)),
            ),
            const SizedBox(height: 16),
            decksAsync.when(
              data: (decks) {
                final filtered = decks.where((deck) {
                  if (_selectedGameId == null) return false;
                  return deck.gameId == _selectedGameId;
                }).toList();
                final existing = widget.tournament;
                if (existing?.deckId != null &&
                    existing!.gameId == _selectedGameId &&
                    filtered.every((deck) => deck.id != existing.deckId)) {
                  filtered.insert(
                    0,
                    Deck(
                      id: existing.deckId!,
                      userId: existing.userId,
                      gameId: existing.gameId,
                      name: existing.deckName ?? 'Archiviertes Deck',
                    ),
                  );
                }
                final selectedDeckId = filtered.any((deck) => deck.id == _selectedDeckId)
                    ? _selectedDeckId
                    : null;

                if (_selectedGameId == null) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      labelText: l10n.playedDeck,
                      border: const OutlineInputBorder(),
                    ),
                    child: Text(l10n.chooseGameFirst),
                  );
                }

                if (filtered.isEmpty) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      labelText: l10n.playedDeck,
                      border: const OutlineInputBorder(),
                    ),
                    child: Text(l10n.noDecksForTcg),
                  );
                }

                return DropdownButtonFormField<String>(
                  key: ValueKey('tournament-deck-$_selectedGameId-$selectedDeckId'),
                  initialValue: selectedDeckId,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: l10n.playedDeck,
                    border: const OutlineInputBorder(),
                  ),
                  hint: Text(l10n.chooseDeck),
                  items: filtered
                      .map(
                        (deck) => DropdownMenuItem(
                          value: deck.id,
                          child: Text(deck.name, overflow: TextOverflow.ellipsis),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _selectedDeckId = value),
                );
              },
              loading: () => const SizedBox(height: 4, child: LinearProgressIndicator()),
              error: (err, _) => Text(l10n.decksLoadError(err)),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _placementController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: l10n.place,
                      hintText: '8',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(l10n.from),
                ),
                Expanded(
                  child: TextField(
                    controller: _participantsController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: l10n.participants,
                      hintText: '64',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: scheme.outline.withValues(alpha: 0.4)),
              ),
              leading: Icon(Icons.event_outlined, color: scheme.primary),
              title: Text(l10n.date),
              subtitle: Text(_dateLabel(_tournamentDate)),
              trailing: const Icon(Icons.chevron_right),
              onTap: _pickDate,
            ),
            const SizedBox(height: 16),
            Text(l10n.eventTags, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ref.watch(appPreferencesProvider).allAvailableTags.map((tag) {
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
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: l10n.notesOptional,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
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
