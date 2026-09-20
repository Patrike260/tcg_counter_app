import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../l10n/l10n.dart';

class ChakraTrackerView extends StatefulWidget {
  const ChakraTrackerView({super.key});

  @override
  State<ChakraTrackerView> createState() => _NarutoTouchTableState();
}

class _NarutoTouchScore {
  int chakra = 0;
  int points = 0;

  void reset() {
    chakra = 0;
    points = 0;
  }
}

class _NarutoTouchTableState extends State<ChakraTrackerView> {
  final _playerOne = _NarutoTouchScore();
  final _playerTwo = _NarutoTouchScore();

  void _nudgeChakra(_NarutoTouchScore player, int delta) {
    setState(() {
      player.chakra = (player.chakra + delta).clamp(0, 99999);
    });
  }

  void _nudgePoints(_NarutoTouchScore player, int delta) {
    setState(() {
      player.points = (player.points + delta).clamp(0, 99999);
    });
  }

  void _resetBoard() {
    HapticFeedback.mediumImpact();
    setState(() {
      _playerOne.reset();
      _playerTwo.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Expanded(
          child: RotatedBox(
            quarterTurns: 2,
            child: _MythosTapSeat(
              name: l10n.playerTwo,
              score: _playerTwo,
              accent: scheme.tertiary,
              chakraLabel: l10n.chakraCounterLabel,
              pointsLabel: l10n.chakraPointsLabel,
              onChakra: (delta) => _nudgeChakra(_playerTwo, delta),
              onPoints: (delta) => _nudgePoints(_playerTwo, delta),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Expanded(child: Divider()),
              IconButton.outlined(
                tooltip: l10n.chakraResetBoard,
                onPressed: _resetBoard,
                icon: const Icon(Icons.restart_alt_rounded),
              ),
              const Expanded(child: Divider()),
            ],
          ),
        ),
        Expanded(
          child: _MythosTapSeat(
            name: l10n.playerOne,
            score: _playerOne,
            accent: scheme.primary,
            chakraLabel: l10n.chakraCounterLabel,
            pointsLabel: l10n.chakraPointsLabel,
            onChakra: (delta) => _nudgeChakra(_playerOne, delta),
            onPoints: (delta) => _nudgePoints(_playerOne, delta),
          ),
        ),
      ],
    );
  }
}

class _MythosTapSeat extends StatelessWidget {
  final String name;
  final _NarutoTouchScore score;
  final Color accent;
  final String chakraLabel;
  final String pointsLabel;
  final ValueChanged<int> onChakra;
  final ValueChanged<int> onPoints;

  const _MythosTapSeat({
    required this.name,
    required this.score,
    required this.accent,
    required this.chakraLabel,
    required this.pointsLabel,
    required this.onChakra,
    required this.onPoints,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 4, 10, 8),
      child: Column(
        children: [
          Text(
            name,
            style: TextStyle(fontWeight: FontWeight.w800, color: accent),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _MythosTapBlock(
                    title: chakraLabel,
                    value: score.chakra,
                    accent: accent,
                    onDelta: onChakra,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _MythosTapBlock(
                    title: pointsLabel,
                    value: score.points,
                    accent: Theme.of(context).colorScheme.secondary,
                    onDelta: onPoints,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MythosTapBlock extends StatefulWidget {
  final String title;
  final int value;
  final Color accent;
  final ValueChanged<int> onDelta;

  const _MythosTapBlock({
    required this.title,
    required this.value,
    required this.accent,
    required this.onDelta,
  });

  @override
  State<_MythosTapBlock> createState() => _MythosTapBlockState();
}

class _MythosTapBlockState extends State<_MythosTapBlock> {
  String? _flash;
  Timer? _flashTimer;

  @override
  void dispose() {
    _flashTimer?.cancel();
    super.dispose();
  }

  void _apply(int delta) {
    if (delta < 0 && widget.value <= 0) return;
    HapticFeedback.selectionClick();
    widget.onDelta(delta);
    setState(() => _flash = delta > 0 ? '+1' : '-1');
    _flashTimer?.cancel();
    _flashTimer = Timer(const Duration(milliseconds: 380), () {
      if (mounted) setState(() => _flash = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: widget.accent.withValues(alpha: 0.16),
          border: Border.all(color: widget.accent.withValues(alpha: 0.45)),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Row(
              children: [
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _apply(-1),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 14),
                          child: Text(
                            '−',
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w300,
                              color: scheme.onSurface.withValues(alpha: 0.28),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _apply(1),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: Text(
                            '+',
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w300,
                              color: scheme.onSurface.withValues(alpha: 0.28),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            IgnorePointer(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Column(
                  children: [
                    Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: widget.accent,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '${widget.value}',
                            style: TextStyle(
                              fontSize: 56,
                              fontWeight: FontWeight.w900,
                              height: 1,
                              color: scheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: _flash == null ? 0 : 1,
                      duration: const Duration(milliseconds: 160),
                      child: Text(
                        _flash ?? ' ',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: (_flash ?? '').startsWith('-')
                              ? Colors.redAccent
                              : Colors.greenAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
