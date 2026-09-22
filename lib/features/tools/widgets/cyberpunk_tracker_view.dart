import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/l10n.dart';
import '../round_timer_service.dart';

const _kHudBg = Color(0xFF0A0E14);
const _kHudBorder = Color(0xFF1E2638);
const _kGigCyan = Color(0xFF00E5FF);
const _kGigGreen = Color(0xFFB6FF3C);
const _kGigYellow = Color(0xFFFFF176);
const _kPolySides = [4, 6, 8, 10, 12, 6, 20];
const _kDieSize = 56.0;

class GigDie {
  final String id;
  final int sides;
  int value;
  final int originalPlayer;
  int currentPlayer;
  bool isRolled;
  bool isSpent;

  GigDie({
    required this.id,
    required this.sides,
    this.value = 0,
    required this.originalPlayer,
    int? currentPlayer,
    this.isRolled = false,
    this.isSpent = false,
  }) : currentPlayer = currentPlayer ?? originalPlayer;

  bool get isStolen => currentPlayer != originalPlayer;

  Color get originColor => originalPlayer == 1 ? _kGigCyan : _kGigGreen;

  bool get isD20 => sides == 20;
}

class CyberpunkTrackerView extends ConsumerStatefulWidget {
  const CyberpunkTrackerView({super.key});

  @override
  ConsumerState<CyberpunkTrackerView> createState() => _CyberHudBoardState();
}

class _CyberHudBoardState extends ConsumerState<CyberpunkTrackerView> {
  final _random = Random();
  int _seq = 0;
  late List<GigDie> _dice;

  @override
  void initState() {
    super.initState();
    _dice = _buildStartDice();
  }

  String _nextId() {
    _seq += 1;
    return 'gig_$_seq';
  }

  List<GigDie> _buildStartDice() {
    return [
      for (final player in [1, 2])
        for (final sides in _kPolySides)
          GigDie(
            id: _nextId(),
            sides: sides,
            originalPlayer: player,
          ),
    ];
  }

  int get _gigsPerPlayer => _kPolySides.length;

  bool _d20Locked(int originalPlayer) {
    return _dice.any(
      (die) =>
          die.originalPlayer == originalPlayer &&
          !die.isD20 &&
          !die.isRolled &&
          !die.isSpent,
    );
  }

  List<GigDie> _poolOf(int player) {
    return _dice
        .where((die) => die.currentPlayer == player && !die.isRolled && !die.isSpent)
        .toList()
      ..sort((a, b) => a.sides.compareTo(b.sides));
  }

  List<GigDie> _boardOf(int player) {
    return _dice
        .where((die) => die.currentPlayer == player && die.isRolled && !die.isSpent)
        .toList()
      ..sort((a, b) => a.sides.compareTo(b.sides));
  }

  int _streetCred(int player) {
    return _boardOf(player).fold<int>(0, (sum, die) => sum + die.value);
  }

  int _gigsRolled(int player) {
    return _boardOf(player).length;
  }

  void _resetRound() {
    HapticFeedback.mediumImpact();
    setState(() => _dice = _buildStartDice());
  }

  void _rollDie(GigDie die) {
    if (die.isRolled || die.isSpent) return;
    if (die.isD20 && _d20Locked(die.originalPlayer)) return;
    HapticFeedback.mediumImpact();
    setState(() {
      die.value = _random.nextInt(die.sides) + 1;
      die.isRolled = true;
    });
  }

  void _stealDie(GigDie die) {
    HapticFeedback.heavyImpact();
    setState(() {
      die.currentPlayer = die.currentPlayer == 1 ? 2 : 1;
    });
  }

  void _spendDie(GigDie die) {
    HapticFeedback.mediumImpact();
    setState(() => die.isSpent = true);
  }

  void _nudgeValue(GigDie die, int delta) {
    HapticFeedback.selectionClick();
    setState(() {
      die.value = (die.value + delta).clamp(1, die.sides);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final clock = ref.watch(roundTimerProvider);

    return ColoredBox(
      color: _kHudBg,
      child: OrientationBuilder(
        builder: (context, orientation) {
          final landscape = orientation == Orientation.landscape;
          final p1 = _HudSeat(
            name: l10n.playerOne,
            accent: _kGigCyan,
            landscape: landscape,
            cred: _streetCred(1),
            gigsRolled: _gigsRolled(1),
            gigsTotal: _gigsPerPlayer,
            clockLabel: clock.clockLabel,
            overtime: clock.isOvertime,
            pool: _poolOf(1),
            board: _boardOf(1),
            d20Locked: _d20Locked(1),
            onRoll: _rollDie,
            onNudge: _nudgeValue,
            onSteal: _stealDie,
            onSpend: _spendDie,
          );
          final p2 = _HudSeat(
            name: l10n.playerTwo,
            accent: _kGigGreen,
            landscape: landscape,
            cred: _streetCred(2),
            gigsRolled: _gigsRolled(2),
            gigsTotal: _gigsPerPlayer,
            clockLabel: clock.clockLabel,
            overtime: clock.isOvertime,
            pool: _poolOf(2),
            board: _boardOf(2),
            d20Locked: _d20Locked(2),
            onRoll: _rollDie,
            onNudge: _nudgeValue,
            onSteal: _stealDie,
            onSpend: _spendDie,
          );

          if (landscape) {
            return Row(
              children: [
                Expanded(child: p1),
                _HudSpine(landscape: true, onReset: _resetRound, label: l10n.gigNewRound),
                Expanded(child: RotatedBox(quarterTurns: 2, child: p2)),
              ],
            );
          }

          return Column(
            children: [
              Expanded(child: RotatedBox(quarterTurns: 2, child: p2)),
              _HudSpine(landscape: false, onReset: _resetRound, label: l10n.gigNewRound),
              Expanded(child: p1),
            ],
          );
        },
      ),
    );
  }
}

class _HudSpine extends StatelessWidget {
  final bool landscape;
  final VoidCallback onReset;
  final String label;

  const _HudSpine({
    required this.landscape,
    required this.onReset,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final line = Container(
      color: _kHudBorder,
      width: landscape ? 1 : double.infinity,
      height: landscape ? double.infinity : 1,
    );
    return landscape
        ? SizedBox(
            width: 42,
            child: Column(
              children: [
                Expanded(child: line),
                IconButton(
                  tooltip: label,
                  onPressed: onReset,
                  icon: const Icon(Icons.restart_alt_rounded, color: _kGigYellow, size: 18),
                ),
                Expanded(child: line),
              ],
            ),
          )
        : SizedBox(
            height: 36,
            child: Row(
              children: [
                Expanded(child: line),
                IconButton(
                  tooltip: label,
                  onPressed: onReset,
                  icon: const Icon(Icons.restart_alt_rounded, color: _kGigYellow, size: 18),
                ),
                Expanded(child: line),
              ],
            ),
          );
  }
}

class _HudSeat extends StatelessWidget {
  final String name;
  final Color accent;
  final bool landscape;
  final int cred;
  final int gigsRolled;
  final int gigsTotal;
  final String clockLabel;
  final bool overtime;
  final List<GigDie> pool;
  final List<GigDie> board;
  final bool d20Locked;
  final ValueChanged<GigDie> onRoll;
  final void Function(GigDie die, int delta) onNudge;
  final ValueChanged<GigDie> onSteal;
  final ValueChanged<GigDie> onSpend;

  const _HudSeat({
    required this.name,
    required this.accent,
    required this.landscape,
    required this.cred,
    required this.gigsRolled,
    required this.gigsTotal,
    required this.clockLabel,
    required this.overtime,
    required this.pool,
    required this.board,
    required this.d20Locked,
    required this.onRoll,
    required this.onNudge,
    required this.onSteal,
    required this.onSpend,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _kHudBg,
        border: Border.all(color: _kHudBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
        child: Column(
          children: [
            _StatusStrip(
              name: name,
              accent: accent,
              cred: cred,
              gigsRolled: gigsRolled,
              gigsTotal: gigsTotal,
              clockLabel: clockLabel,
              overtime: overtime,
              credLabel: l10n.gigStreetCred,
              gigsLabel: l10n.gigGigs,
            ),
            const SizedBox(height: 6),
            Expanded(
              child: landscape
                  ? Row(
                      children: [
                        SizedBox(
                          width: 92,
                          child: _PoolRack(
                            title: l10n.gigPool,
                            accent: accent,
                            pool: pool,
                            d20Locked: d20Locked,
                            onRoll: onRoll,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: _ActiveField(
                            accent: accent,
                            board: board,
                            onNudge: onNudge,
                            onSteal: onSteal,
                            onSpend: onSpend,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: _ActiveField(
                            accent: accent,
                            board: board,
                            onNudge: onNudge,
                            onSteal: onSteal,
                            onSpend: onSpend,
                          ),
                        ),
                        const SizedBox(height: 6),
                        _PoolRack(
                          title: l10n.gigPool,
                          accent: accent,
                          pool: pool,
                          d20Locked: d20Locked,
                          onRoll: onRoll,
                          horizontal: true,
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusStrip extends StatelessWidget {
  final String name;
  final Color accent;
  final int cred;
  final int gigsRolled;
  final int gigsTotal;
  final String clockLabel;
  final bool overtime;
  final String credLabel;
  final String gigsLabel;

  const _StatusStrip({
    required this.name,
    required this.accent,
    required this.cred,
    required this.gigsRolled,
    required this.gigsTotal,
    required this.clockLabel,
    required this.overtime,
    required this.credLabel,
    required this.gigsLabel,
  });

  @override
  Widget build(BuildContext context) {
    final clockColor = overtime ? Colors.redAccent : accent.withValues(alpha: 0.85);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
        color: accent.withValues(alpha: 0.06),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: accent,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                fontSize: 13,
                shadows: [Shadow(color: accent.withValues(alpha: 0.55), blurRadius: 10)],
              ),
            ),
          ),
          _KpiChip(label: credLabel, value: '$cred', accent: accent),
          const SizedBox(width: 8),
          _KpiChip(label: gigsLabel, value: '$gigsRolled / $gigsTotal', accent: accent),
          const SizedBox(width: 8),
          _KpiChip(
            label: context.l10n.roundTimer,
            value: clockLabel,
            accent: clockColor,
          ),
        ],
      ),
    );
  }
}

class _KpiChip extends StatelessWidget {
  final String label;
  final String value;
  final Color accent;

  const _KpiChip({
    required this.label,
    required this.value,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 8,
            letterSpacing: 0.8,
            fontWeight: FontWeight.w700,
            color: accent.withValues(alpha: 0.65),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
            height: 1.05,
            color: accent,
          ),
        ),
      ],
    );
  }
}

class _PoolRack extends StatelessWidget {
  final String title;
  final Color accent;
  final List<GigDie> pool;
  final bool d20Locked;
  final ValueChanged<GigDie> onRoll;
  final bool horizontal;

  const _PoolRack({
    required this.title,
    required this.accent,
    required this.pool,
    required this.d20Locked,
    required this.onRoll,
    this.horizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    final tiles = [
      for (final die in pool)
        PolyhedralDiceWidget(
          sides: die.sides,
          label: 'D${die.sides}',
          color: die.originColor,
          locked: die.isD20 && d20Locked,
          size: horizontal ? 44 : 40,
          onTap: () => onRoll(die),
        ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(6, 5, 6, 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _kHudBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
              color: accent.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 6),
          if (horizontal)
            SizedBox(
              height: 52,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (final tile in tiles)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: tile,
                    ),
                ],
              ),
            )
          else
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  alignment: WrapAlignment.center,
                  children: tiles,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ActiveField extends StatelessWidget {
  final Color accent;
  final List<GigDie> board;
  final void Function(GigDie die, int delta) onNudge;
  final ValueChanged<GigDie> onSteal;
  final ValueChanged<GigDie> onSpend;

  const _ActiveField({
    required this.accent,
    required this.board,
    required this.onNudge,
    required this.onSteal,
    required this.onSpend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: accent.withValues(alpha: 0.22)),
      ),
      child: board.isEmpty
          ? Center(
              child: Text(
                '—',
                style: TextStyle(color: accent.withValues(alpha: 0.28), fontSize: 28),
              ),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                final dieSize = (min(constraints.maxHeight, constraints.maxWidth) / 3.4)
                    .clamp(42.0, 72.0);
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(6),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: [
                      for (final die in board)
                        _ActiveDieCard(
                          die: die,
                          size: dieSize,
                          onNudge: onNudge,
                          onSteal: onSteal,
                          onSpend: onSpend,
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class _ActiveDieCard extends StatelessWidget {
  final GigDie die;
  final double size;
  final void Function(GigDie die, int delta) onNudge;
  final ValueChanged<GigDie> onSteal;
  final ValueChanged<GigDie> onSpend;

  const _ActiveDieCard({
    required this.die,
    required this.size,
    required this.onNudge,
    required this.onSteal,
    required this.onSpend,
  });

  @override
  Widget build(BuildContext context) {
    final accent = die.originColor;
    return SizedBox(
      width: size + 18,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _HudMiniBtn(
                label: '−1',
                accent: accent,
                onTap: die.value > 1 ? () => onNudge(die, -1) : null,
              ),
              const SizedBox(width: 4),
              _HudMiniBtn(
                label: '⇄',
                accent: accent,
                onTap: () => onSteal(die),
              ),
              const SizedBox(width: 4),
              _HudMiniBtn(
                label: '+1',
                accent: accent,
                onTap: die.value < die.sides ? () => onNudge(die, 1) : null,
              ),
            ],
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onLongPress: () => onSpend(die),
            child: PolyhedralDiceWidget(
              sides: die.sides,
              label: '${die.value}',
              color: accent,
              stolen: die.isStolen,
              size: size,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'd${die.sides}',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: accent.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _HudMiniBtn extends StatelessWidget {
  final String label;
  final Color accent;
  final VoidCallback? onTap;

  const _HudMiniBtn({
    required this.label,
    required this.accent,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          width: 26,
          height: 20,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: accent.withValues(alpha: enabled ? 0.7 : 0.25)),
            color: accent.withValues(alpha: enabled ? 0.12 : 0.04),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              height: 1,
              color: accent.withValues(alpha: enabled ? 1 : 0.35),
            ),
          ),
        ),
      ),
    );
  }
}

class PolyhedralDiceWidget extends StatelessWidget {
  final int sides;
  final String label;
  final Color color;
  final bool locked;
  final bool stolen;
  final VoidCallback? onTap;
  final double size;

  const PolyhedralDiceWidget({
    super.key,
    required this.sides,
    required this.label,
    required this.color,
    this.locked = false,
    this.stolen = false,
    this.onTap,
    this.size = _kDieSize,
  });

  @override
  Widget build(BuildContext context) {
    final paintColor = locked ? const Color(0xFF5A6578) : color;
    final stolenLabel = context.l10n.gigStolen;

    return Opacity(
      opacity: locked ? 0.38 : 1,
      child: SizedBox(
        width: size,
        height: size,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: locked ? null : onTap,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: Size(size, size),
                  painter: CyberDiceShape(
                    sides: sides,
                    color: paintColor,
                    locked: locked,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: (label.startsWith('D') ? size * 0.22 : size * 0.38).clamp(9.0, 24.0),
                    fontWeight: FontWeight.w900,
                    color: locked ? Colors.white54 : Colors.white,
                    shadows: [
                      Shadow(color: paintColor, blurRadius: 8),
                      const Shadow(color: Colors.black87, blurRadius: 4),
                    ],
                  ),
                ),
                if (stolen)
                  Positioned(
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: _kGigYellow,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        stolenLabel,
                        style: const TextStyle(
                          fontSize: 7,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                if (locked)
                  const Positioned(
                    bottom: 3,
                    right: 4,
                    child: Icon(Icons.lock, size: 11, color: Colors.white70),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CyberDiceShape extends CustomPainter {
  final int sides;
  final Color color;
  final bool locked;

  const CyberDiceShape({
    required this.sides,
    required this.color,
    required this.locked,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = _shapePath(size);
    final fill = Paint()
      ..color = color.withValues(alpha: locked ? 0.06 : 0.10)
      ..style = PaintingStyle.fill;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);

    if (sides == 20 && !locked) {
      final inner = _regularPolygon(size, 6, inset: size.width * 0.22);
      canvas.drawPath(
        inner,
        Paint()
          ..color = color.withValues(alpha: 0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8,
      );
    }
  }

  Path _shapePath(Size size) {
    switch (sides) {
      case 4:
        return _regularPolygon(size, 3, startAngle: -pi / 2, inset: 4);
      case 6:
        return Path()
          ..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(5, 5, size.width - 10, size.height - 10),
              const Radius.circular(3),
            ),
          );
      case 8:
        return _diamond(size);
      case 10:
        return _kite(size);
      case 12:
        return _regularPolygon(size, 5, startAngle: -pi / 2, inset: 4);
      case 20:
      default:
        return _regularPolygon(size, 6, startAngle: -pi / 2, inset: 4);
    }
  }

  Path _diamond(Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    return Path()
      ..moveTo(c.dx, 3)
      ..lineTo(size.width - 4, c.dy)
      ..lineTo(c.dx, size.height - 3)
      ..lineTo(4, c.dy)
      ..close();
  }

  Path _kite(Size size) {
    return Path()
      ..moveTo(size.width / 2, 3)
      ..lineTo(size.width - 5, size.height * 0.42)
      ..lineTo(size.width / 2, size.height - 3)
      ..lineTo(5, size.height * 0.42)
      ..close();
  }

  Path _regularPolygon(
    Size size,
    int n, {
    double startAngle = -pi / 2,
    double inset = 4,
  }) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - inset;
    final path = Path();
    for (var i = 0; i < n; i++) {
      final angle = startAngle + (i * 2 * pi / n);
      final point = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant CyberDiceShape oldDelegate) {
    return oldDelegate.sides != sides ||
        oldDelegate.color != color ||
        oldDelegate.locked != locked;
  }
}
