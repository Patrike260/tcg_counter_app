import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/widgets/game_logo.dart';
import '../../l10n/l10n.dart';
import '../decks/deck_repository.dart';
import 'app_preferences_service.dart';

class GameVisibilityScreen extends ConsumerWidget {
  const GameVisibilityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final gamesAsync = ref.watch(gamesListProvider);
    final prefs = ref.watch(appPreferencesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.visibleTcgsScreenTitle),
      ),
      body: gamesAsync.when(
        data: (games) {
          if (games.isEmpty) {
            return Center(
              child: Text(l10n.noGamesAvailable),
            );
          }

          final visibleCount = games.where((g) => prefs.isGameVisible(g.id)).length;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'Ausgeblendete Spiele erscheinen nicht in Dropdowns '
                  '(z. B. beim Anlegen eines Decks oder als Standard-TCG). '
                  'Mindestens ein TCG muss sichtbar bleiben.',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                ),
              ),
              if (visibleCount <= 1)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Letztes sichtbares TCG — Ausblenden nicht möglich.',
                      style: TextStyle(color: Colors.amber.shade300, fontSize: 12),
                    ),
                  ),
                ),
              Expanded(
                child: ListView.separated(
                  itemCount: games.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final game = games[index];
                    final isVisible = prefs.isGameVisible(game.id);
                    final canHide = visibleCount > 1 || !isVisible;

                    return SwitchListTile(
                      secondary: GameLogo(gameName: game.name, size: 36),
                      title: Text(game.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(isVisible ? 'Sichtbar in Dropdowns' : 'Ausgeblendet'),
                      value: isVisible,
                      onChanged: (value) async {
                        if (!value && !canHide) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.atLeastOneTcgVisible),
                            ),
                          );
                          return;
                        }
                        await ref
                            .read(appPreferencesProvider.notifier)
                            .toggleGameVisibility(game.id, value);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text(l10n.loadErrorWithDetails(err))),
      ),
    );
  }
}
