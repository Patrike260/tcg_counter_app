import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../decks/deck_model.dart';
import '../stats/deck_stats_screen.dart';
import 'add_match_dialog.dart';
import 'match_model.dart';
import 'match_repository.dart';

class DeckDetailScreen extends ConsumerStatefulWidget {
  final Deck deck;

  const DeckDetailScreen({super.key, required this.deck});

  @override
  ConsumerState<DeckDetailScreen> createState() => _DeckDetailScreenState();
}

class _DeckDetailScreenState extends ConsumerState<DeckDetailScreen> {
  String _selectedFormat = 'all'; // 'all', 'bo1', 'bo3'
  String? _selectedTag; // null = alle Tags

  final List<String> _tags = const ['Local', 'Regional', 'Casual', 'Testing', 'Online'];

  @override
  Widget build(BuildContext context) {
    final matchesAsync = ref.watch(deckMatchesProvider(widget.deck.id));

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
        data: (allMatches) {
          if (allMatches.isEmpty) {
            return const Center(
              child: Text(
                'Noch keine Matches für dieses Deck erfasst.\nKlicke unten auf +, um ein Match hinzuzufügen!',
                textAlign: TextAlign.center,
              ),
            );
          }

          // Filter anwenden
          final filteredMatches = allMatches.where((m) {
            final matchesFormat = _selectedFormat == 'all' || m.matchFormat == _selectedFormat;
            final matchesTag = _selectedTag == null || m.tags.contains(_selectedTag);
            return matchesFormat && matchesTag;
          }).toList();

          final wins = filteredMatches.where((m) => m.result == 'win').length;
          final total = filteredMatches.length;
          final winRate = total > 0 ? (wins / total * 100).toStringAsFixed(1) : '0';

          return Column(
            children: [
              // Schnelle Statistik für den aktiven Filter
              Card(
                margin: const EdgeInsets.all(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text('Matches', style: TextStyle(color: Colors.grey)),
                          Text('$total', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Siege', style: TextStyle(color: Colors.grey)),
                          Text('$wins', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green)),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Winrate', style: TextStyle(color: Colors.grey)),
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
                      label: const Text('Alle Formate'),
                      selected: _selectedFormat == 'all',
                      onSelected: (_) => setState(() => _selectedFormat = 'all'),
                    ),
                    const SizedBox(width: 6),
                    ChoiceChip(
                      label: const Text('BO1'),
                      selected: _selectedFormat == 'bo1',
                      onSelected: (_) => setState(() => _selectedFormat = 'bo1'),
                    ),
                    const SizedBox(width: 6),
                    ChoiceChip(
                      label: const Text('BO3'),
                      selected: _selectedFormat == 'bo3',
                      onSelected: (_) => setState(() => _selectedFormat = 'bo3'),
                    ),
                    const VerticalDivider(width: 20, thickness: 1),
                    ..._tags.map((tag) => Padding(
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
              const Divider(height: 12),

              // Gefilterte Liste
              Expanded(
                child: filteredMatches.isEmpty
                  ? const Center(child: Text('Keine Matches für diesen Filter gefunden.'))
                  : ListView.builder(
                      itemCount: filteredMatches.length,
                      itemBuilder: (context, index) {
                        final match = filteredMatches[index];
                        final isWin = match.result == 'win';
                        final isLoss = match.result == 'loss';

                        return ListTile(
                          leading: Icon(
                            isWin ? Icons.check_circle : (isLoss ? Icons.cancel : Icons.pause_circle),
                            color: isWin ? Colors.green : (isLoss ? Colors.red : Colors.grey),
                            size: 32,
                          ),
                          title: Text('vs. ${match.opponentDeck}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${match.matchFormat.toUpperCase()} • ${match.turnOrder == 'first' ? '1st' : '2nd'}${match.score != null ? ' • (${match.score})' : ''}',
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
                          trailing: Text(
                            '${match.createdAt.day}.${match.createdAt.month}.${match.createdAt.year}',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        );
                      },
                    ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Fehler: $err')),
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