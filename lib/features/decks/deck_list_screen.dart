import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/tcg_colors.dart';
import '../../core/utils/deck_list_url.dart';
import '../../core/utils/game_colors.dart';
import '../../core/widgets/game_logo.dart';
import '../../l10n/l10n.dart';
import '../matches/deck_detail_screen.dart';
import '../matches/match_repository.dart';
import 'add_deck_dialog.dart';
import 'deck_model.dart';
import 'deck_repository.dart';

class DeckListScreen extends ConsumerWidget {
  const DeckListScreen({super.key});

  void _showDeleteDialog(BuildContext context, WidgetRef ref, Deck deck) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteDeckQuestion),
        content: Text(l10n.deleteDeckBody(deck.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.of(ctx).pop();
              await ref.read(deckRepositoryProvider).deleteDeck(deck.id);
              ref.invalidate(userDecksProvider);
              ref.invalidate(deckMatchSummariesProvider);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(context.l10n.deckDeleted(deck.name))),
                );
              }
            },
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  void _archiveDeck(BuildContext context, WidgetRef ref, Deck deck) async {
    await ref.read(deckRepositoryProvider).archiveDeck(deck.id);
    ref.invalidate(userDecksProvider);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.deckArchived(deck.name))),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final decksAsync = ref.watch(userDecksProvider);
    final summariesAsync = ref.watch(deckMatchSummariesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.titleMyDecks),
      ),
      body: decksAsync.when(
        data: (decks) {
          if (decks.isEmpty) {
            return Center(
              child: Text(
                l10n.noDecksYet,
                textAlign: TextAlign.center,
              ),
            );
          }
          return ListView.builder(
            itemCount: decks.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final deck = decks[index];
              final summary = summariesAsync.maybeWhen(
                data: (map) => map[deck.id] ?? const DeckMatchSummary(),
                orElse: () => const DeckMatchSummary(),
              );
              return _DeckSummaryCard(
                deck: deck,
                summary: summary,
                summariesLoading: summariesAsync.isLoading,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DeckDetailScreen(deck: deck),
                    ),
                  );
                },
                onMenuSelected: (value) {
                  switch (value) {
                    case 'edit':
                      showDialog(
                        context: context,
                        builder: (_) => AddDeckDialog(deck: deck),
                      );
                      break;
                    case 'archive':
                      _archiveDeck(context, ref, deck);
                      break;
                    case 'delete':
                      _showDeleteDialog(context, ref, deck);
                      break;
                  }
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text(l10n.errorWithDetails(err))),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const AddDeckDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _DeckSummaryCard extends StatelessWidget {
  final Deck deck;
  final DeckMatchSummary summary;
  final bool summariesLoading;
  final VoidCallback onTap;
  final ValueChanged<String> onMenuSelected;

  const _DeckSummaryCard({
    required this.deck,
    required this.summary,
    required this.summariesLoading,
    required this.onTap,
    required this.onMenuSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final baseColor = getGameBaseColor(
      deck.gameName,
      fallback: Theme.of(context).colorScheme.primaryContainer,
    );
    final winRateColor = TcgColors.winRateColor(summary.winRate, summary.totalMatches);
    final winRateLabel = summary.totalMatches == 0
        ? '–'
        : '${summary.winRate.toStringAsFixed(0)}%';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      clipBehavior: Clip.antiAlias,
      decoration: gameColorWashDecoration(baseColor, radius: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 4, 14),
            child: Row(
              children: [
                GameLogo(gameName: deck.gameName, size: 48),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        deck.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.28),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: baseColor.withValues(alpha: 0.55)),
                            ),
                            child: Text(
                              deck.gameName ?? l10n.noTcg,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.sports_esports_outlined, size: 16, color: Colors.white70),
                              const SizedBox(width: 4),
                              Text(
                                summariesLoading && summary.totalMatches == 0
                                    ? '… ${l10n.matchPlural}'
                                    : '${summary.totalMatches} ${summary.totalMatches == 1 ? l10n.matchSingular : l10n.matchPlural}',
                                style: const TextStyle(fontSize: 12, color: Colors.white70),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (deck.notes != null && deck.notes!.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          deck.notes!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.55)),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (deck.hasDeckListUrl)
                  IconButton(
                    tooltip: l10n.viewDecklist,
                    icon: Icon(
                      Icons.open_in_new,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () async {
                      final opened = await openDeckListUrl(deck.deckListUrl);
                      if (!opened && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.linkOpenFailed)),
                        );
                      }
                    },
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: winRateColor.withValues(alpha: 0.7)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        winRateLabel,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: winRateColor,
                        ),
                      ),
                      Text(
                        'WR',
                        style: TextStyle(fontSize: 10, color: winRateColor.withValues(alpha: 0.9)),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.white70),
                  onSelected: onMenuSelected,
                  itemBuilder: (context) {
                    final menuL10n = context.l10n;
                    return [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            const Icon(Icons.edit, size: 20),
                            const SizedBox(width: 8),
                            Text(menuL10n.edit),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'archive',
                        child: Row(
                          children: [
                            const Icon(Icons.archive_outlined, size: 20),
                            const SizedBox(width: 8),
                            Text(menuL10n.archive),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(Icons.delete_outline, size: 20, color: Colors.redAccent),
                            const SizedBox(width: 8),
                            Text(menuL10n.delete, style: const TextStyle(color: Colors.redAccent)),
                          ],
                        ),
                      ),
                    ];
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
