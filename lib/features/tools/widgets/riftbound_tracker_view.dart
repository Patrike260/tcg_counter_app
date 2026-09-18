import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../l10n/l10n.dart';

class RiftboundTrackerView extends StatefulWidget {
  const RiftboundTrackerView({super.key});

  @override
  State<RiftboundTrackerView> createState() => _RiftboundBoardState();
}

class _RiftboundBoardState extends State<RiftboundTrackerView> {
  int _goal = 8;
  int _p1 = 0;
  int _p2 = 0;

  void _setGoal(int goal) {
    HapticFeedback.selectionClick();
    setState(() => _goal = goal);
  }

  void _adjust(int player, int delta) {
    HapticFeedback.selectionClick();
    setState(() {
      if (player == 1) {
        _p1 = (_p1 + delta).clamp(0, 99);
      } else {
        _p2 = (_p2 + delta).clamp(0, 99);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Text(
          l10n.riftboundGoal,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Center(
          child: SegmentedButton<int>(
            segments: [
              ButtonSegment(value: 8, label: Text(l10n.riftboundGoal8)),
              ButtonSegment(value: 10, label: Text(l10n.riftboundGoal10)),
            ],
            selected: {_goal},
            onSelectionChanged: (values) => _setGoal(values.first),
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final stacked = constraints.maxWidth < 520;
            final cards = [
              _ScoreSeat(
                name: l10n.playerOne,
                score: _p1,
                goal: _goal,
                accent: Theme.of(context).colorScheme.primary,
                onPlus: () => _adjust(1, 1),
                onMinus: () => _adjust(1, -1),
                plusLabel: l10n.riftboundPlusBattlefield,
                winLabel: l10n.riftboundWinBadge,
              ),
              _ScoreSeat(
                name: l10n.playerTwo,
                score: _p2,
                goal: _goal,
                accent: Theme.of(context).colorScheme.tertiary,
                onPlus: () => _adjust(2, 1),
                onMinus: () => _adjust(2, -1),
                plusLabel: l10n.riftboundPlusBattlefield,
                winLabel: l10n.riftboundWinBadge,
              ),
            ];
            if (stacked) {
              return Column(
                children: [
                  cards[0],
                  const SizedBox(height: 12),
                  cards[1],
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: cards[0]),
                const SizedBox(width: 12),
                Expanded(child: cards[1]),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _ScoreSeat extends StatelessWidget {
  final String name;
  final int score;
  final int goal;
  final Color accent;
  final VoidCallback onPlus;
  final VoidCallback onMinus;
  final String plusLabel;
  final String winLabel;

  const _ScoreSeat({
    required this.name,
    required this.score,
    required this.goal,
    required this.accent,
    required this.onPlus,
    required this.onMinus,
    required this.plusLabel,
    required this.winLabel,
  });

  @override
  Widget build(BuildContext context) {
    final won = score >= goal;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: accent.withValues(alpha: won ? 0.22 : 0.12),
        border: Border.all(
          color: won ? accent : accent.withValues(alpha: 0.4),
          width: won ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            name,
            style: TextStyle(fontWeight: FontWeight.w800, color: accent),
          ),
          const SizedBox(height: 8),
          Text(
            '$score',
            style: TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.w900,
              height: 1,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Text(
            '/ $goal',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55),
            ),
          ),
          if (won) ...[
            const SizedBox(height: 8),
            Chip(
              avatar: Icon(Icons.emoji_events_rounded, color: accent, size: 18),
              label: Text(
                winLabel,
                style: TextStyle(fontWeight: FontWeight.w800, color: accent),
              ),
              backgroundColor: accent.withValues(alpha: 0.16),
            ),
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: onPlus,
              style: FilledButton.styleFrom(backgroundColor: accent),
              child: Text(plusLabel),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: onMinus,
              child: const Text('-1'),
            ),
          ),
        ],
      ),
    );
  }
}
