import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/tcg_colors.dart';
import '../../core/utils/game_colors.dart';
import '../../core/widgets/game_logo.dart';
import 'dashboard_repository.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardDataProvider);

    return Scaffold(
      body: dashboardAsync.when(
        data: (data) {
          if (data.unfilteredTotal == 0) {
            return const Center(
              child: Text(
                'Willkommen!\nTrage erste Matches in deinen Decks ein, um Statistiken zu sehen.',
                textAlign: TextAlign.center,
              ),
            );
          }

          if (data.totalMatches == 0) {
            return RefreshIndicator(
              onRefresh: () async => ref.invalidate(dashboardDataProvider),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: const [
                  SizedBox(height: 48),
                  _EmptyFilterHint(),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(dashboardDataProvider),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth >= 640;
                    final tiles = [
                      _WinrateTile(
                        label: 'Winrate',
                        value: '${data.overallWinRate.toStringAsFixed(1)}%',
                        subtitle: data.timeRange.label,
                        color: TcgColors.winRateColor(data.overallWinRate, data.totalMatches),
                        icon: Icons.emoji_events_outlined,
                      ),
                      _WinrateTile(
                        label: 'Matches',
                        value: '${data.totalMatches}',
                        subtitle: 'Erfasst',
                        color: Colors.lightBlueAccent,
                        icon: Icons.sports_esports_outlined,
                      ),
                      _WinrateTile(
                        label: 'Siege',
                        value: '${data.totalWins}',
                        subtitle: 'von ${data.totalMatches}',
                        color: Colors.greenAccent,
                        icon: Icons.check_circle_outline,
                      ),
                    ];

                    if (isWide) {
                      return Row(
                        children: [
                          for (var i = 0; i < tiles.length; i++) ...[
                            if (i > 0) const SizedBox(width: 12),
                            Expanded(child: tiles[i]),
                          ],
                        ],
                      );
                    }

                    return Column(
                      children: [
                        tiles[0],
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(child: tiles[1]),
                            const SizedBox(width: 10),
                            Expanded(child: tiles[2]),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                _MatchupHighlightsRow(
                  best: data.bestMatchup,
                  nemesis: data.nemesisMatchup,
                  rangeLabel: data.timeRange.label,
                  hasMatches: data.totalMatches > 0,
                ),
                const SizedBox(height: 28),

                const Text(
                  'Performance nach Kartenspiel',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ...data.gameSummaries.map((game) {
                  final winRateColor = TcgColors.winRateColor(game.winRate, game.totalMatches);
                  final baseColor = getGameBaseColor(
                    game.gameName,
                    fallback: Theme.of(context).colorScheme.primaryContainer,
                  );
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    clipBehavior: Clip.antiAlias,
                    decoration: gameColorWashDecoration(baseColor, radius: 14),
                    child: ListTile(
                      leading: GameLogo(gameName: game.gameName, size: 40),
                      title: Text(
                        game.gameName,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      subtitle: Text(
                        '${game.wins} Siege von ${game.totalMatches} Matches',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.78)),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: winRateColor.withValues(alpha: 0.7)),
                        ),
                        child: Text(
                          '${game.winRate.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: winRateColor,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 24),

                const Text(
                  'Letzte Matches',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ...data.recentMatches.map((match) {
                  final isWin = match.result == 'win';
                  final isLoss = match.result == 'loss';
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      isWin ? Icons.check_circle : (isLoss ? Icons.cancel : Icons.pause_circle),
                      color: isWin ? Colors.green : (isLoss ? Colors.red : Colors.grey),
                    ),
                    title: Text('vs. ${match.opponentDeck}', style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('${match.matchFormat.toUpperCase()} • ${match.turnOrder == 'first' ? '1st' : '2nd'}'),
                    trailing: Text(
                      '${match.createdAt.day}.${match.createdAt.month}.${match.createdAt.year}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  );
                }),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Fehler: $err')),
      ),
    );
  }
}

class _EmptyFilterHint extends StatelessWidget {
  const _EmptyFilterHint();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A3C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: const Text(
        'Keine Matches im gewählten Zeitraum',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white70, fontSize: 15),
      ),
    );
  }
}

class _MatchupHighlightsRow extends StatelessWidget {
  final OpponentMatchup? best;
  final OpponentMatchup? nemesis;
  final String rangeLabel;
  final bool hasMatches;

  const _MatchupHighlightsRow({
    required this.best,
    required this.nemesis,
    required this.rangeLabel,
    required this.hasMatches,
  });

  @override
  Widget build(BuildContext context) {
    if (!hasMatches) {
      return const _EmptyFilterHint();
    }

    if (best == null && nemesis == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A3C),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white12),
        ),
        child: Text(
          'Keine Matches gegen mehrfache Archetypen im gewählten Zeitraum ($rangeLabel).\nMindestens 2 Matches gegen dasselbe Deck nötig.',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white60, height: 1.4),
        ),
      );
    }

    final cards = [
      if (best != null)
        _MatchupHighlightCard(
          title: 'Stärkstes Matchup',
          matchup: best!,
          accent: Colors.greenAccent,
          icon: Icons.military_tech_outlined,
          showLossRate: false,
          rangeLabel: rangeLabel,
        ),
      if (nemesis != null)
        _MatchupHighlightCard(
          title: 'Nemesis / Problem-Deck',
          matchup: nemesis!,
          accent: Colors.redAccent,
          icon: Icons.warning_amber_rounded,
          showLossRate: true,
          rangeLabel: rangeLabel,
        ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final sideBySide = constraints.maxWidth >= 560 && cards.length == 2;
        if (sideBySide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: cards[0]),
              const SizedBox(width: 12),
              Expanded(child: cards[1]),
            ],
          );
        }
        return Column(
          children: [
            for (var i = 0; i < cards.length; i++) ...[
              if (i > 0) const SizedBox(height: 10),
              cards[i],
            ],
          ],
        );
      },
    );
  }
}

class _MatchupHighlightCard extends StatelessWidget {
  final String title;
  final OpponentMatchup matchup;
  final Color accent;
  final IconData icon;
  final bool showLossRate;
  final String rangeLabel;

  const _MatchupHighlightCard({
    required this.title,
    required this.matchup,
    required this.accent,
    required this.icon,
    required this.showLossRate,
    required this.rangeLabel,
  });

  @override
  Widget build(BuildContext context) {
    final rate = showLossRate ? matchup.lossRate : matchup.winRate;
    final rateLabel = showLossRate ? 'Loss-Rate' : 'Winrate';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF1E1E2C),
        border: Border.all(color: accent.withValues(alpha: 0.4)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withValues(alpha: 0.18),
            const Color(0xFF2A2A3C),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: accent, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: accent,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            matchup.opponentDeck,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'vs. ${matchup.opponentDeck} • ${rate.toStringAsFixed(0)}% ($rangeLabel)',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.72)),
          ),
          const SizedBox(height: 8),
          Text(
            '${rate.toStringAsFixed(1)}% $rateLabel',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: accent,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${matchup.wins}–${matchup.losses}  (${matchup.wins} Siege / ${matchup.total} Matches)',
            style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.7)),
          ),
        ],
      ),
    );
  }
}

class _WinrateTile extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;
  final Color color;
  final IconData icon;

  const _WinrateTile({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 6),
                Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
