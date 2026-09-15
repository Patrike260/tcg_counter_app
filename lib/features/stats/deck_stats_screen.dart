import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../decks/deck_model.dart';
import '../matches/match_repository.dart';
import 'stats_calculator.dart';

class DeckStatsScreen extends ConsumerWidget {
  final Deck deck;

  const DeckStatsScreen({super.key, required this.deck});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchesAsync = ref.watch(deckMatchesProvider(deck.id));

    return Scaffold(
      appBar: AppBar(
        title: Text('${deck.name} - Stats'),
      ),
      body: matchesAsync.when(
        data: (matches) {
          if (matches.isEmpty) {
            return const Center(
              child: Text('Noch keine Matches vorhanden, um Statistiken zu berechnen.'),
            );
          }

          final stats = DeckStats.fromMatches(matches);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Turn-Order Statistiken
              const Text(
                'Zugreihenfolge (Turn Order)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _StatBox(
                      title: '1st (Beginn)',
                      ratio: '${stats.firstWins} / ${stats.firstMatches}',
                      rate: '${stats.firstWinRate.toStringAsFixed(1)}%',
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatBox(
                      title: '2nd (Zweiter)',
                      ratio: '${stats.secondWins} / ${stats.secondMatches}',
                      rate: '${stats.secondWinRate.toStringAsFixed(1)}%',
                      color: Colors.purpleAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Matchup-Statistiken
              const Text(
                'Matchups gegen Archetypen',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...stats.matchups.map(
                (m) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    title: Text(m.opponentDeck, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('${m.wins} Siege von ${m.total} Spielen'),
                    trailing: Text(
                      '${m.winRate.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: m.winRate >= 50 ? Colors.greenAccent : Colors.redAccent,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Fehler: $err')),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String title;
  final String ratio;
  final String rate;
  final Color color;

  const _StatBox({
    required this.title,
    required this.ratio,
    required this.rate,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(rate, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(ratio, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}