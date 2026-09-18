import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/deck_list_url.dart';
import '../../l10n/l10n.dart';
import '../decks/deck_model.dart';
import '../settings/app_preferences_service.dart';
import '../stats/deck_stats_screen.dart';
import 'add_match_dialog.dart';
import 'match_repository.dart';

class DeckDetailScreen extends ConsumerStatefulWidget {
  final Deck deck;

  const DeckDetailScreen({super.key, required this.deck});

  @override
  ConsumerState<DeckDetailScreen> createState() => _DeckDetailScreenState();
}

class _DeckDetailScreenState extends ConsumerState<DeckDetailScreen> {
  String _selectedFormat = 'all'; // 'all', 'bo1', 'bo3'
  String? _selectedTag; // null = kein Tag-Filter

  Future<void> _openDeckList(BuildContext context) async {
    final opened = await openDeckListUrl(widget.deck.deckListUrl);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.linkOpenFailed)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final matchesAsync = ref.watch(deckMatchesProvider(widget.deck.id));
    final allAvailableTags = ref.watch(appPreferencesProvider).allAvailableTags;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.deck.name),
            if (widget.deck.gameName != null)
              Text(
                widget.deck.gameName!,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
          ],
        ),
        actions: [
          if (widget.deck.hasDeckListUrl)
            IconButton(
              icon: const Icon(Icons.open_in_new),
              tooltip: l10n.viewDecklist,
              onPressed: () => _openDeckList(context),
            ),
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            tooltip: 'Statistiken anzeigen',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => DeckStatsScreen(deck: widget.deck),
                ),
              );
            },
          ),
        ],
      ),
      body: matchesAsync.when(
        data: (matches) {
          if (matches.isEmpty) {
            return Center(
              child: Text(
                l10n.noMatchesForDeck,
                textAlign: TextAlign.center,
              ),
            );
          }

          // Filter anwenden
          final filteredMatches = matches.where((m) {
            final matchFormat = _selectedFormat == 'all' || m.matchFormat == _selectedFormat;
            final matchTag = _selectedTag == null || m.tags.contains(_selectedTag);
            return matchFormat && matchTag;
          }).toList();

          final wins = matches.where((m) => m.result == 'win').length;
          final total = matches.length;
          final winRate = total > 0 ? (wins / total * 100).toStringAsFixed(1) : '0';

          return Column(
            children: [
              if (widget.deck.hasDeckListUrl)
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _openDeckList(context),
                      icon: const Icon(Icons.link),
                      label: Text(l10n.viewDecklist),
                    ),
                  ),
                ),
              // Schnelle Statistik-Leiste
              Card(
                margin: const EdgeInsets.all(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(l10n.matches, style: const TextStyle(color: Colors.grey)),
                          Text('$total', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        children: [
                          Text(l10n.wins, style: const TextStyle(color: Colors.grey)),
                          Text('$wins', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green)),
                        ],
                      ),
                      Column(
                        children: [
                          Text(l10n.winrate, style: const TextStyle(color: Colors.grey)),
                          Text('$winRate%', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.amber)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Filterleiste (Format & Tags)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Row(
                  children: [
                    ChoiceChip(
                      label: Text(l10n.allFormats),
                      selected: _selectedFormat == 'all',
                      onSelected: (val) => setState(() => _selectedFormat = 'all'),
                    ),
                    const SizedBox(width: 6),
                    ChoiceChip(
                      label: Text(l10n.bo1),
                      selected: _selectedFormat == 'bo1',
                      onSelected: (val) => setState(() => _selectedFormat = 'bo1'),
                    ),
                    const SizedBox(width: 6),
                    ChoiceChip(
                      label: Text(l10n.bo3),
                      selected: _selectedFormat == 'bo3',
                      onSelected: (val) => setState(() => _selectedFormat = 'bo3'),
                    ),
                    const VerticalDivider(width: 16, thickness: 1),
                    ...allAvailableTags.map((tag) => Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: FilterChip(
                            label: Text(tag),
                            selected: _selectedTag == tag,
                            onSelected: (selected) {
                              setState(() {
                                _selectedTag = selected ? tag : null;
                              });
                            },
                          ),
                        )),
                  ],
                ),
              ),

              // Match-Liste mit Swipe-to-Delete & Edit
              Expanded(
                child: filteredMatches.isEmpty
                    ? Center(child: Text(l10n.noMatchesForFilter))
                    : ListView.builder(
                        itemCount: filteredMatches.length,
                        itemBuilder: (context, index) {
                          final match = filteredMatches[index];
                          final isWin = match.result == 'win';
                          final isLoss = match.result == 'loss';

                          return Dismissible(
                            key: Key(match.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            confirmDismiss: (direction) async {
                              return await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text(l10n.deleteMatchQuestion),
                                  content: Text(l10n.deleteMatchBody(match.opponentDeck)),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(ctx).pop(false),
                                      child: Text(l10n.cancel),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                      onPressed: () => Navigator.of(ctx).pop(true),
                                      child: Text(l10n.delete),
                                    ),
                                  ],
                                ),
                              );
                            },
                            onDismissed: (direction) async {
                              await ref.read(matchRepositoryProvider).deleteMatch(match.id);
                              ref.invalidate(deckMatchesProvider(widget.deck.id));
                              ref.invalidate(deckMatchSummariesProvider);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(l10n.matchDeleted)),
                                );
                              }
                            },
                            child: ListTile(
                              leading: Icon(
                                isWin ? Icons.check_circle : (isLoss ? Icons.cancel : Icons.pause_circle),
                                color: isWin ? Colors.green : (isLoss ? Colors.red : Colors.grey),
                                size: 32,
                              ),
                              title: Text(l10n.vsOpponent(match.opponentDeck), style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${match.matchFormat.toUpperCase()} • ${match.turnOrder == 'first' ? l10n.turnFirstShort : l10n.turnSecondShort}${match.score != null ? ' • (${match.score})' : ''}',
                                  ),
                                  if (match.tags.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Wrap(
                                        spacing: 4,
                                        children: match.tags
                                            .map((t) => Chip(
                                                  label: Text(t, style: const TextStyle(fontSize: 10)),
                                                  visualDensity: VisualDensity.compact,
                                                  padding: EdgeInsets.zero,
                                                ))
                                            .toList(),
                                      ),
                                    ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 20),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AddMatchDialog(
                                      deckId: widget.deck.id,
                                      gameId: widget.deck.gameId,
                                      match: match,
                                    ),
                                  );
                                },
                              ),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => AddMatchDialog(
                                    deckId: widget.deck.id,
                                    gameId: widget.deck.gameId,
                                    match: match,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text(l10n.errorWithDetails(err))),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AddMatchDialog(
              deckId: widget.deck.id,
              gameId: widget.deck.gameId,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
