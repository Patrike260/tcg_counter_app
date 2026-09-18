import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/l10n.dart';
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
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(tournament.name),
        actions: [
          IconButton(
            tooltip: l10n.edit,
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
              Chip(label: Text(tournament.localizedPlacement(l10n))),
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
                : tournament.deckName != null
                    ? l10n.relatedMatchesTagsAndDeck(tournament.deckName!)
                    : l10n.relatedMatchesTags,
            style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.65)),
          ),
          const SizedBox(height: 12),
          matchesAsync.when(
            data: (matches) {
              if (matches.isEmpty) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(l10n.noMatchingMatches),
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
                        '$wins ${l10n.wins} - $losses ${l10n.loss} • ${winRate.toStringAsFixed(1)}% ${l10n.winrate}',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(l10n.relatedMatchesCount(matches.length)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...matches.map((match) => _RelatedMatchTile(match: match)),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Text(l10n.matchesLoadFailed(err)),
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
      title: Text(context.l10n.vsOpponent(match.opponentDeck), style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        '${match.matchFormat.toUpperCase()} • ${match.turnOrder == 'first' ? context.l10n.turnFirstShort : context.l10n.turnSecondShort}'
        '${match.tags.isEmpty ? '' : ' • ${match.tags.join(', ')}'}',
      ),
      trailing: Text(
        '${match.createdAt.day}.${match.createdAt.month}.${match.createdAt.year}',
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
    );
  }
}
