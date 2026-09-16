import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../matches/match_model.dart';
import 'add_tournament_dialog.dart';
import 'tournament_model.dart';
import 'tournament_repository.dart';

class TournamentDetailScreen extends ConsumerWidget {
  final Tournament tournament;

  const TournamentDetailScreen({super.key, required this.tournament});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchesAsync = ref.watch(tournamentRelatedMatchesProvider(tournament.id));
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(tournament.name),
        actions: [
          IconButton(
            tooltip: 'Bearbeiten',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AddTournamentDialog(tournament: tournament),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(tournament.dateLabel, style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.7))),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(label: Text(tournament.placementLabel)),
              if (tournament.gameName != null) Chip(label: Text(tournament.gameName!)),
              if (tournament.deckName != null) Chip(label: Text(tournament.deckName!)),
              for (final tag in tournament.tags) Chip(label: Text(tag)),
            ],
          ),
          if (tournament.notes != null && tournament.notes!.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(tournament.notes!),
          ],
          const SizedBox(height: 24),
          const Text(
            'Zugehörige Matches',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            tournament.tags.isEmpty
                ? 'Weise dem Turnier Event-Tags zu, um passende Matches zuzuordnen.'
                : 'Matches mit denselben Tags${tournament.deckName != null ? ' und Deck „${tournament.deckName}“' : ''}.',
            style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.65)),
          ),
          const SizedBox(height: 12),
          matchesAsync.when(
            data: (matches) {
              if (matches.isEmpty) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Keine passenden Matches gefunden.'),
                  ),
                );
              }
              final wins = matches.where((m) => m.result == 'win').length;
              final losses = matches.where((m) => m.result == 'loss').length;
              final decided = wins + losses;
              final winRate = decided > 0 ? (wins / decided) * 100 : 0.0;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.analytics_outlined, color: scheme.primary),
                      title: Text(
                        '$wins Siege - $losses Niederlagen • ${winRate.toStringAsFixed(1)}% Winrate',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text('${matches.length} Matches zugeordnet'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...matches.map((match) => _RelatedMatchTile(match: match)),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Text('Matches konnten nicht geladen werden: $err'),
          ),
        ],
      ),
    );
  }
}

class _RelatedMatchTile extends StatelessWidget {
  final MatchRecord match;

  const _RelatedMatchTile({required this.match});

  @override
  Widget build(BuildContext context) {
    final isWin = match.result == 'win';
    final isLoss = match.result == 'loss';
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        isWin ? Icons.check_circle : (isLoss ? Icons.cancel : Icons.pause_circle),
        color: isWin ? Colors.green : (isLoss ? Colors.red : Colors.grey),
      ),
      title: Text('vs. ${match.opponentDeck}', style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        '${match.matchFormat.toUpperCase()} • ${match.turnOrder == 'first' ? '1st' : '2nd'}'
        '${match.tags.isEmpty ? '' : ' • ${match.tags.join(', ')}'}',
      ),
      trailing: Text(
        '${match.createdAt.day}.${match.createdAt.month}.${match.createdAt.year}',
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
    );
  }
}
