import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/widgets/game_logo.dart';
import '../decks/deck_model.dart';
import '../decks/deck_repository.dart';
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
        ],
      ),
    );
  }
}

class _GamePickerDialog extends StatelessWidget {
  final List<Game> games;
  final String? selectedId;

  const _GamePickerDialog({
    required this.games,
    required this.selectedId,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Standard-Kartenspiel'),
      content: SizedBox(
        width: 360,
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              leading: const Icon(Icons.block_outlined),
              title: const Text('Keines (immer manuell wählen)'),
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
