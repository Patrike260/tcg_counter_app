import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/tcg_colors.dart';
import '../../core/utils/game_colors.dart';
import '../../core/widgets/game_logo.dart';
import '../matches/deck_detail_screen.dart';
import '../matches/match_repository.dart';
import 'add_deck_dialog.dart';
import 'deck_model.dart';
import 'deck_repository.dart';

class DeckListScreen extends ConsumerWidget {
  const DeckListScreen({super.key});

  void _showDeleteDialog(BuildContext context, WidgetRef ref, Deck deck) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Deck wirklich löschen?'),
        content: Text('Das Deck "${deck.name}" und ALLE dazugehörigen Matches werden unwiderruflich gelöscht!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Abbrechen'),
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
                  SnackBar(content: Text('Deck "${deck.name}" gelöscht.')),
                );
              }
            },
            child: const Text('Löschen'),
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
        SnackBar(content: Text('Deck "${deck.name}" archiviert.')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decksAsync = ref.watch(userDecksProvider);
    final summariesAsync = ref.watch(deckMatchSummariesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meine Decks'),
      ),
      body: decksAsync.when(
        data: (decks) {
          if (decks.isEmpty) {
            return const Center(
              child: Text(
                'Noch keine Decks angelegt.\nTippe unten rechts auf +, um dein erstes Deck zu erstellen!',
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
        error: (err, _) => Center(child: Text('Fehler: $err')),
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
                              deck.gameName ?? 'Unbekannt',
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
                                    ? '… Matches'
                                    : '${summary.totalMatches} ${summary.totalMatches == 1 ? 'Match' : 'Matches'}',
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
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 20),
                          SizedBox(width: 8),
                          Text('Bearbeiten'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'archive',
                      child: Row(
                        children: [
                          Icon(Icons.archive_outlined, size: 20),
                          SizedBox(width: 8),
                          Text('Archivieren'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, size: 20, color: Colors.redAccent),
                          SizedBox(width: 8),
                          Text('Löschen', style: TextStyle(color: Colors.redAccent)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
