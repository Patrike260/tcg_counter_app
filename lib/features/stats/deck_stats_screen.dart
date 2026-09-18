import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/l10n.dart';
import '../decks/deck_model.dart';
import '../matches/match_repository.dart';
import 'stats_calculator.dart';

class DeckStatsScreen extends ConsumerWidget {
  final Deck deck;

  const DeckStatsScreen({super.key, required this.deck});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final matchesAsync = ref.watch(deckMatchesProvider(deck.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.statsTitle(deck.name)),
      ),
      body: matchesAsync.when(
        data: (matches) {
          if (matches.isEmpty) {
            return Center(
              child: Text(l10n.noStatsYet),
            );
          }

          final stats = DeckStats.fromMatches(matches);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Turn-Order Statistiken
              Text(
                l10n.turnOrder,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _StatBox(
                      title: l10n.turnFirstFull,
                      ratio: '${stats.firstWins} / ${stats.firstMatches}',
                      rate: '${stats.firstWinRate.toStringAsFixed(1)}%',
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatBox(
                      title: l10n.turnSecondFull,
                      ratio: '${stats.secondWins} / ${stats.secondMatches}',
                      rate: '${stats.secondWinRate.toStringAsFixed(1)}%',
                      color: Colors.purpleAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Matchup-Statistiken
              Text(
                l10n.matchupsVsArchetypes,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...stats.matchups.map(
                (m) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    title: Text(m.opponentDeck, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(l10n.winsOfGames(m.wins, m.total)),
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
        error: (err, _) => Center(child: Text(l10n.errorWithDetails(err))),
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
