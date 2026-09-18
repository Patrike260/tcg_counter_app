import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
              ref.invalidate(deckMatchesProvider(deck.id));
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
              return _DeckOverviewCard(
                deck: deck,
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
        loading: () => _buildLoadingSkeleton(context),
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

  Widget _buildLoadingSkeleton(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 4,
      itemBuilder: (_, _) => const _DeckSkeletonCard(),
    );
  }
}

class _DeckOverviewCard extends ConsumerWidget {
  final Deck deck;
  final VoidCallback onTap;
  final ValueChanged<String> onMenuSelected;

  const _DeckOverviewCard({
    required this.deck,
    required this.onTap,
    required this.onMenuSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final matchesAsync = ref.watch(deckMatchesProvider(deck.id));
    final baseColor = getGameBaseColor(
      deck.gameName,
      fallback: Theme.of(context).colorScheme.primaryContainer,
    );

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
            padding: const EdgeInsets.fromLTRB(14, 12, 0, 12),
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.28),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: baseColor.withValues(alpha: 0.55)),
                        ),
                        child: Text(
                          deck.gameName ?? l10n.noTcg,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      if (deck.notes != null && deck.notes!.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          deck.notes!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.55),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                matchesAsync.when(
                  data: (matches) => _DeckWinRateChip(
                    summary: DeckMatchSummary.fromMatches(matches),
                    loading: false,
                  ),
                  loading: () => const _DeckWinRateChip(
                    summary: DeckMatchSummary(),
                    loading: true,
                  ),
                  error: (_, _) => const _DeckWinRateChip(
                    summary: DeckMatchSummary(),
                    loading: false,
                  ),
                ),
                if (deck.hasDeckListUrl)
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    style: IconButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: const Size(36, 36),
                      padding: const EdgeInsets.all(4),
                    ),
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
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  iconSize: 22,
                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
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

class _DeckWinRateChip extends StatelessWidget {
  final DeckMatchSummary summary;
  final bool loading;

  const _DeckWinRateChip({
    required this.summary,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final total = summary.totalMatches;
    final percent = summary.winRatePercent;

    late final Color background;
    late final Color foreground;
    late final String label;

    if (loading && total == 0) {
      background = Colors.blueGrey.withValues(alpha: 0.35);
      foreground = Colors.white70;
      label = '…';
    } else if (total == 0) {
      background = Colors.blueGrey.withValues(alpha: 0.38);
      foreground = Colors.white70;
      label = l10n.deckWinRateNew;
    } else if (percent >= 55) {
      background = const Color(0xFF2E7D32);
      foreground = Colors.white;
      label = l10n.deckWinRateBadge(percent, total);
    } else if (percent >= 45) {
      background = const Color(0xFFEF6C00);
      foreground = Colors.white;
      label = l10n.deckWinRateBadge(percent, total);
    } else {
      background = const Color(0xFFC62828);
      foreground = Colors.white;
      label = l10n.deckWinRateBadge(percent, total);
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 96),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: foreground,
              height: 1.1,
            ),
          ),
        ),
      ),
    );
  }
}

class _DeckSkeletonCard extends StatefulWidget {
  const _DeckSkeletonCard();

  @override
  State<_DeckSkeletonCard> createState() => _DeckSkeletonCardState();
}

class _DeckSkeletonCardState extends State<_DeckSkeletonCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fill = scheme.onSurface.withValues(alpha: 0.08);
    final badge = scheme.onSurface.withValues(alpha: 0.12);

    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, child) {
        return Opacity(
          opacity: 0.45 + (_pulse.value * 0.4),
          child: child,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: scheme.surface,
          border: Border.all(color: scheme.outline.withValues(alpha: 0.18)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: badge,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    width: 160,
                    decoration: BoxDecoration(
                      color: fill,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        height: 22,
                        width: 72,
                        decoration: BoxDecoration(
                          color: badge,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        height: 12,
                        width: 88,
                        decoration: BoxDecoration(
                          color: fill,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 10,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: fill,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 48,
              height: 40,
              decoration: BoxDecoration(
                color: badge,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
