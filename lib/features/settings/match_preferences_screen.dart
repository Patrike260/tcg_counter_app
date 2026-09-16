import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/widgets/game_logo.dart';
import '../decks/deck_model.dart';
import '../decks/deck_repository.dart';
import '../stats/dashboard_repository.dart';
import 'app_preferences_service.dart';

class MatchPreferencesScreen extends ConsumerWidget {
  const MatchPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(appPreferencesProvider);
    final gamesAsync = ref.watch(gamesListProvider);
    final notifier = ref.read(appPreferencesProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Match-Einstellungen'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'VORAUSWAHL FÜR NEUE MATCHES',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: gamesAsync.when(
              data: (games) {
                final visibleGames =
                    games.where((game) => prefs.isGameVisible(game.id)).toList();
                final selectedGame = visibleGames
                    .where((game) => game.id == prefs.resolvedDefaultGameId)
                    .firstOrNull;
                return Column(
                  children: [
                    ListTile(
                      title: const Text('Standard-Kartenspiel'),
                      subtitle: Text(selectedGame?.name ?? 'Keines (immer manuell wählen)'),
                      leading: GameLogo(gameName: selectedGame?.name, size: 32),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () async {
                        final chosen = await showDialog<String?>(
                          context: context,
                          builder: (ctx) => _GamePickerDialog(
                            games: visibleGames,
                            selectedId: selectedGame?.id,
                          ),
                        );
                        if (chosen == '__clear__') {
                          await notifier.setDefaultGameId(null);
                        } else if (chosen != null) {
                          await notifier.setDefaultGameId(chosen);
                        }
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: const Text('Standard Match-Format'),
                      subtitle: Text(
                        prefs.defaultFormat == 'bo3' ? 'Best of 3 (BO3)' : 'Best of 1 (BO1)',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(value: 'bo1', label: Text('BO1')),
                          ButtonSegment(value: 'bo3', label: Text('BO3')),
                        ],
                        selected: {prefs.defaultFormat},
                        onSelectionChanged: (set) {
                          notifier.setDefaultFormat(set.first);
                        },
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: const Text('Standard Zugreihenfolge'),
                      subtitle: Text(
                        prefs.defaultTurnOrder == 'first'
                            ? '1st (Immer Beginn)'
                            : prefs.defaultTurnOrder == 'second'
                                ? '2nd (Immer Zweiter)'
                                : 'Keine Vorgabe',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(value: 'none', label: Text('Frei')),
                          ButtonSegment(value: 'first', label: Text('1st')),
                          ButtonSegment(value: 'second', label: Text('2nd')),
                        ],
                        selected: {prefs.defaultTurnOrder},
                        onSelectionChanged: (set) {
                          notifier.setDefaultTurnOrder(set.first);
                        },
                      ),
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      title: const Text('Zuletzt gewählte Tags merken'),
                      subtitle: const Text(
                        'Setzt die Tags des letzten Matches automatisch ein',
                      ),
                      value: prefs.rememberLastTags,
                      onChanged: notifier.setRememberLastTags,
                    ),
                  ],
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, _) => Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Spiele konnten nicht geladen werden: $err'),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'DASHBOARD-FILTER & NEMESIS',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: gamesAsync.when(
              data: (games) {
                final visibleGames =
                    games.where((game) => prefs.isGameVisible(game.id)).toList();
                final dashboardGame = visibleGames
                    .where((game) => game.id == prefs.resolvedDashboardGameId)
                    .firstOrNull;
                final selectedRange =
                    DashboardTimeRange.fromStorage(prefs.dashboardTimeRange);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ListTile(
                      title: Text('Zeitraum für Statistiken'),
                      subtitle: Text('Wirkt auf Winrate, Nemesis und TCG-Performance'),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: DashboardTimeRange.values.map((range) {
                          return ChoiceChip(
                            label: Text(range.label),
                            selected: selectedRange == range,
                            onSelected: (_) =>
                                notifier.setDashboardTimeRange(range.name),
                          );
                        }).toList(),
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: const Text('Spiel-Fokus für Dashboard'),
                      subtitle: Text(dashboardGame?.name ?? 'Alle sichtbaren Spiele'),
                      leading: GameLogo(gameName: dashboardGame?.name, size: 32),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () async {
                        final chosen = await showDialog<String?>(
                          context: context,
                          builder: (ctx) => _GamePickerDialog(
                            title: 'Dashboard-Spiel',
                            clearLabel: 'Alle sichtbaren Spiele',
                            games: visibleGames,
                            selectedId: dashboardGame?.id,
                          ),
                        );
                        if (chosen == '__clear__') {
                          await notifier.setDashboardGameId(null);
                        } else if (chosen != null) {
                          await notifier.setDashboardGameId(chosen);
                        }
                      },
                    ),
                  ],
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (_, _) => const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}

class _GamePickerDialog extends StatelessWidget {
  final List<Game> games;
  final String? selectedId;
  final String title;
  final String clearLabel;

  const _GamePickerDialog({
    required this.games,
    required this.selectedId,
    this.title = 'Standard-Kartenspiel',
    this.clearLabel = 'Keines (immer manuell wählen)',
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: 360,
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              leading: const Icon(Icons.apps_outlined),
              title: Text(clearLabel),
              selected: selectedId == null,
              onTap: () => Navigator.pop(context, '__clear__'),
            ),
            ...games.map(
              (game) => ListTile(
                leading: GameLogo(gameName: game.name, size: 28),
                title: Text(game.name),
                selected: game.id == selectedId,
                onTap: () => Navigator.pop(context, game.id),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Abbrechen'),
        ),
      ],
    );
  }
}
