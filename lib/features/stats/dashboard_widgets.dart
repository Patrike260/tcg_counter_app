import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/tcg_colors.dart';
import '../../core/utils/game_colors.dart';
import '../../core/widgets/game_logo.dart';
import '../tournaments/tournament_list_screen.dart';
import '../tournaments/tournament_repository.dart';
import 'dashboard_config_model.dart';
import 'dashboard_repository.dart';

IconData dashboardTabIcon(String iconName) {
  switch (iconName) {
    case 'emoji_events_outlined':
      return Icons.emoji_events_outlined;
    case 'view_agenda_outlined':
      return Icons.view_agenda_outlined;
    case 'tune_outlined':
      return Icons.tune_outlined;
    case 'sports_esports_outlined':
      return Icons.sports_esports_outlined;
    case 'style_outlined':
      return Icons.style_outlined;
    case 'analytics_outlined':
      return Icons.analytics_outlined;
    case 'military_tech_outlined':
      return Icons.military_tech_outlined;
    default:
      return Icons.dashboard_outlined;
  }
}

Widget buildDashboardWidget(String key, DashboardData data, BuildContext context) {
  switch (key) {
    case DashboardWidgetKeys.kpiWinrate:
      return DashboardKpiWinrate(data: data);
    case DashboardWidgetKeys.kpiNemesis:
      return DashboardNemesisSection(data: data);
    case DashboardWidgetKeys.performanceTcg:
      return DashboardTcgPerformance(data: data);
    case DashboardWidgetKeys.recentMatches:
      return DashboardRecentMatches(data: data);
    case DashboardWidgetKeys.tournamentsOverview:
      return const DashboardTournamentsOverview();
    case DashboardWidgetKeys.turnOrderStats:
      return DashboardTurnOrderStats(data: data);
    default:
      return const SizedBox.shrink();
  }
}

class DashboardKpiWinrate extends StatelessWidget {
  final DashboardData data;

  const DashboardKpiWinrate({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final tiles = [
      _KpiTile(
        label: 'Winrate',
        value: '${data.overallWinRate.toStringAsFixed(1)}%',
        subtitle: data.timeRange.label,
        color: TcgColors.winRateColor(data.overallWinRate, data.totalMatches),
        icon: Icons.emoji_events_outlined,
      ),
      _KpiTile(
        label: 'Matches',
        value: '${data.totalMatches}',
        subtitle: 'Erfasst',
        color: Colors.lightBlueAccent,
        icon: Icons.sports_esports_outlined,
      ),
      _KpiTile(
        label: 'Siege',
        value: '${data.totalWins}',
        subtitle: 'von ${data.totalMatches}',
        color: Colors.greenAccent,
        icon: Icons.check_circle_outline,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 640;
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
    );
  }
}

class DashboardNemesisSection extends StatelessWidget {
  final DashboardData data;

  const DashboardNemesisSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final best = data.bestMatchup;
    final nemesis = data.nemesisMatchup;
    final rangeLabel = data.timeRange.label;

    if (data.totalMatches == 0) {
      return const _DashboardHint('Keine Matches im gewählten Zeitraum');
    }

    if (best == null && nemesis == null) {
      return _DashboardHint(
        'Keine Matches gegen mehrfache Archetypen im gewählten Zeitraum ($rangeLabel).\nMindestens 2 Matches gegen dasselbe Deck nötig.',
      );
    }

    final cards = [
      if (best != null)
        _MatchupHighlightCard(
          title: 'Stärkstes Matchup',
          matchup: best,
          accent: Colors.greenAccent,
          icon: Icons.military_tech_outlined,
          showLossRate: false,
          rangeLabel: rangeLabel,
        ),
      if (nemesis != null)
        _MatchupHighlightCard(
          title: 'Nemesis / Problem-Deck',
          matchup: nemesis,
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

class DashboardTcgPerformance extends StatelessWidget {
  final DashboardData data;

  const DashboardTcgPerformance({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Performance nach Kartenspiel',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        if (data.gameSummaries.isEmpty)
          const _DashboardHint('Noch keine Matches für sichtbare TCGs.')
        else
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
      ],
    );
  }
}

class DashboardRecentMatches extends StatelessWidget {
  final DashboardData data;

  const DashboardRecentMatches({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Letzte Matches',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        if (data.recentMatches.isEmpty)
          const _DashboardHint('Keine Matches im gewählten Zeitraum.')
        else
          ...data.recentMatches.map((match) {
            final isWin = match.result == 'win';
            final isLoss = match.result == 'loss';
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                isWin ? Icons.check_circle : (isLoss ? Icons.cancel : Icons.pause_circle),
                color: isWin ? Colors.green : (isLoss ? Colors.red : Colors.grey),
              ),
              title: Text(
                'vs. ${match.opponentDeck}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                '${match.matchFormat.toUpperCase()} • ${match.turnOrder == 'first' ? '1st' : '2nd'}',
              ),
              trailing: Text(
                '${match.createdAt.day}.${match.createdAt.month}.${match.createdAt.year}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            );
          }),
      ],
    );
  }
}

class DashboardTurnOrderStats extends StatelessWidget {
  final DashboardData data;

  const DashboardTurnOrderStats({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final stats = data.turnOrderStats;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Zugreihenfolge',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _KpiTile(
                label: 'First',
                value: '${stats.firstWinRate.toStringAsFixed(0)}%',
                subtitle: '${stats.firstWins}/${stats.firstMatches} Siege',
                color: Colors.cyanAccent,
                icon: Icons.looks_one_outlined,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _KpiTile(
                label: 'Second',
                value: '${stats.secondWinRate.toStringAsFixed(0)}%',
                subtitle: '${stats.secondWins}/${stats.secondMatches} Siege',
                color: Colors.orangeAccent,
                icon: Icons.looks_two_outlined,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class DashboardTournamentsOverview extends ConsumerWidget {
  const DashboardTournamentsOverview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tournamentsAsync = ref.watch(tournamentsListProvider);
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Letzte Turniere',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const TournamentListScreen()),
                );
              },
              child: const Text('Alle'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        tournamentsAsync.when(
          data: (tournaments) {
            if (tournaments.isEmpty) {
              return const _DashboardHint('Noch keine Turniere erfasst.');
            }
            return Column(
              children: tournaments.take(4).map((tournament) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Icon(Icons.emoji_events_outlined, color: scheme.primary),
                    title: Text(
                      tournament.name,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      [
                        tournament.dateLabel,
                        if (tournament.deckName != null) tournament.deckName!,
                      ].join(' • '),
                    ),
                    trailing: Text(
                      tournament.placementLabel,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: scheme.primary,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const TournamentListScreen()),
                      );
                    },
                  ),
                );
              }).toList(),
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (err, _) => _DashboardHint('Turniere konnten nicht geladen werden.\n$err'),
        ),
      ],
    );
  }
}

class _DashboardHint extends StatelessWidget {
  final String text;

  const _DashboardHint(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white60, height: 1.4),
      ),
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
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: accent.withValues(alpha: 0.4)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withValues(alpha: 0.18),
            Theme.of(context).colorScheme.surface,
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

class _KpiTile extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;
  final Color color;
  final IconData icon;

  const _KpiTile({
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
