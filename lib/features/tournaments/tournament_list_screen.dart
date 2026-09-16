import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/game_colors.dart';
import '../../core/widgets/game_logo.dart';
import 'add_tournament_dialog.dart';
import 'tournament_model.dart';
import 'tournament_repository.dart';

class TournamentListScreen extends ConsumerWidget {
  const TournamentListScreen({super.key});

  Future<void> _openEditor(BuildContext context, {Tournament? tournament}) {
    return showDialog(
      context: context,
      builder: (_) => AddTournamentDialog(tournament: tournament),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Tournament tournament,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Turnier löschen?'),
        content: Text('„${tournament.name}“ wird unwiderruflich gelöscht.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await ref.read(tournamentRepositoryProvider).deleteTournament(tournament.id);
      ref.invalidate(tournamentsListProvider);
      ref.invalidate(tournamentsStreamProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('„${tournament.name}“ gelöscht.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Löschen fehlgeschlagen: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tournamentsAsync = ref.watch(tournamentsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Turniere & Events'),
        actions: [
          IconButton(
            tooltip: 'Turnier hinzufügen',
            icon: const Icon(Icons.add),
            onPressed: () => _openEditor(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEditor(context),
        child: const Icon(Icons.add),
      ),
      body: tournamentsAsync.when(
        data: (tournaments) {
          if (tournaments.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.emoji_events_outlined,
                      size: 56,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Noch keine Turniere erfasst.\nHalte Store Championships, Regionals und Opens fest.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(tournamentsListProvider),
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
              itemCount: tournaments.length,
              itemBuilder: (context, index) {
                final tournament = tournaments[index];
                return _TournamentCard(
                  tournament: tournament,
                  onEdit: () => _openEditor(context, tournament: tournament),
                  onDelete: () => _confirmDelete(context, ref, tournament),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Turniere konnten nicht geladen werden.\n$err',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class _TournamentCard extends StatelessWidget {
  final Tournament tournament;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _TournamentCard({
    required this.tournament,
    required this.onEdit,
    required this.onDelete,
  });

  Color _badgeColor(ColorScheme scheme) {
    switch (tournament.placement) {
      case 1:
        return const Color(0xFFFFC107);
      case 2:
        return const Color(0xFFB0BEC5);
      case 3:
        return const Color(0xFFBF8A5A);
      default:
        return tournament.isTopCut ? scheme.primary : scheme.secondary;
    }
  }

  IconData _badgeIcon() {
    switch (tournament.placement) {
      case 1:
        return Icons.emoji_events;
      case 2:
      case 3:
        return Icons.workspace_premium_outlined;
      default:
        return tournament.isTopCut ? Icons.military_tech_outlined : Icons.flag_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final badgeColor = _badgeColor(scheme);
    final gameColor = getGameBaseColor(
      tournament.gameName,
      fallback: scheme.primary,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tournament.name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tournament.dateLabel,
                        style: TextStyle(
                          color: scheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') onEdit();
                    if (value == 'delete') onDelete();
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'edit', child: Text('Bearbeiten')),
                    PopupMenuItem(value: 'delete', child: Text('Löschen')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: badgeColor.withValues(alpha: 0.7)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_badgeIcon(), size: 18, color: badgeColor),
                    const SizedBox(width: 8),
                    Text(
                      tournament.placementLabel,
                      style: TextStyle(
                        color: badgeColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  avatar: GameLogo(gameName: tournament.gameName, size: 18),
                  label: Text(tournament.gameName ?? 'TCG'),
                  visualDensity: VisualDensity.compact,
                  side: BorderSide(color: gameColor.withValues(alpha: 0.45)),
                ),
                Chip(
                  avatar: Icon(Icons.style_outlined, size: 16, color: scheme.primary),
                  label: Text(tournament.deckName ?? 'Deck unbekannt'),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            if (tournament.notes != null && tournament.notes!.trim().isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                tournament.notes!,
                style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.75)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
