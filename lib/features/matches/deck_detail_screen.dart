import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../decks/deck_model.dart';
import 'add_match_dialog.dart';
import 'match_repository.dart';
import '../stats/deck_stats_screen.dart';

class DeckDetailScreen extends ConsumerWidget {
  final Deck deck;

  const DeckDetailScreen({super.key, required this.deck});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchesAsync = ref.watch(deckMatchesProvider(deck.id));

    return Scaffold(
      appBar: AppBar(
  title: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(deck.name),
      if (deck.gameName != null)
        Text(
          deck.gameName!,
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
            builder: (_) => DeckStatsScreen(deck: deck),
          ),
        );
      },
    ),
  ],
),
      body: matchesAsync.when(
        data: (matches) {
          if (matches.isEmpty) {
            return const Center(
              child: Text(
                'Noch keine Matches für dieses Deck erfasst.\nKlicke unten auf +, um ein Match hinzuzufügen!',
                textAlign: TextAlign.center,
              ),
            );
          }

          final wins = matches.where((m) => m.result == 'win').length;
          final total = matches.length;
          final winRate = total > 0 ? (wins / total * 100).toStringAsFixed(1) : '0';

          return Column(
            children: [
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
              Expanded(
                child: ListView.builder(
                  itemCount: matches.length,
                  itemBuilder: (context, index) {
                    final match = matches[index];
                    final isWin = match.result == 'win';
                    final isLoss = match.result == 'loss';

                    return ListTile(
                      leading: Icon(
                        isWin ? Icons.check_circle : (isLoss ? Icons.cancel : Icons.pause_circle),
                        color: isWin ? Colors.green : (isLoss ? Colors.red : Colors.grey),
                        size: 32,
                      ),
                      title: Text('vs. ${match.opponentDeck}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        '${match.matchFormat.toUpperCase()} • ${match.turnOrder == 'first' ? '1st' : '2nd'}${match.score != null ? ' • (${match.score})' : ''}',
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
              deckId: deck.id,
              gameId: deck.gameId,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}