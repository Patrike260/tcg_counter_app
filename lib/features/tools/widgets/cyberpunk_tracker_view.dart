import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../l10n/l10n.dart';

const _kGigCyan = Color(0xFF00E5FF);
const _kGigPink = Color(0xFFFF2A85);
const _kGigYellow = Color(0xFFFFF176);
const _kGigPanel = Color(0xFF12131C);
const _kPolySides = [4, 6, 8, 10, 12, 20];
const _kUnlockSides = [4, 6, 8, 10, 12];
const _kDieSize = 58.0;

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

  Color get originColor => originalPlayer == 1 ? _kGigCyan : _kGigPink;
}

class CyberpunkTrackerView extends StatefulWidget {
  const CyberpunkTrackerView({super.key});

  @override
  State<CyberpunkTrackerView> createState() => _FacetGigTableState();
}

class _FacetGigTableState extends State<CyberpunkTrackerView> {
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

  bool _d20Locked(int player) {
    return _kUnlockSides.any((sides) {
      return _dice.any(
        (die) =>
            die.originalPlayer == player &&
            die.sides == sides &&
            !die.isRolled,
      );
    });
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

  void _resetRound() {
    HapticFeedback.mediumImpact();
    setState(() => _dice = _buildStartDice());
  }

  void _rollDie(GigDie die) {
    if (die.isRolled || die.isSpent) return;
    if (die.sides == 20 && _d20Locked(die.originalPlayer)) return;
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

  Future<void> _openBoardDie(BuildContext context, GigDie die) async {
    final l10n = context.l10n;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: _kGigPanel,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: StatefulBuilder(
            builder: (context, setSheet) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: die.originColor.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                    const SizedBox(height: 12),
                    PolyhedralDiceWidget(
                      sides: die.sides,
                      label: '${die.value}',
                      color: die.originColor,
                      stolen: die.isStolen,
                      size: 64,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.gigAdjustValue,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton.filledTonal(
                          onPressed: die.value > 1
                              ? () {
                                  _nudgeValue(die, -1);
                                  setSheet(() {});
                                }
                              : null,
                          icon: const Icon(Icons.remove),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Text(
                            '${die.value}',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: die.originColor,
                            ),
                          ),
                        ),
                        IconButton.filledTonal(
                          onPressed: die.value < die.sides
                              ? () {
                                  _nudgeValue(die, 1);
                                  setSheet(() {});
                                }
                              : null,
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                    ListTile(
                      leading: const Icon(Icons.swap_horiz, color: _kGigPink),
                      title: Text(l10n.gigSteal),
                      onTap: () {
                        Navigator.pop(ctx);
                        _stealDie(die);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      title: Text(l10n.gigRemove),
                      onTap: () {
                        Navigator.pop(ctx);
                        _spendDie(die);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ColoredBox(
      color: _kGigPanel.withValues(alpha: 0.42),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
        child: Row(
          children: [
            _SideGigField(
              playerLabel: l10n.playerOne,
              poolTitle: l10n.gigPool,
              accent: _kGigCyan,
              cred: _streetCred(1),
              pool: _poolOf(1),
              d20Locked: _d20Locked(1),
              onRoll: _rollDie,
            ),
            const SizedBox(width: 6),
            Expanded(
              flex: 4,
              child: _CenterGigField(
                title: l10n.gigCenter,
                playerOneLabel: l10n.playerOne,
                playerTwoLabel: l10n.playerTwo,
                playerOneDice: _boardOf(1),
                playerTwoDice: _boardOf(2),
                playerOneCred: _streetCred(1),
                playerTwoCred: _streetCred(2),
                onTapDie: (die) => _openBoardDie(context, die),
                onReset: _resetRound,
              ),
            ),
            const SizedBox(width: 6),
            _SideGigField(
              playerLabel: l10n.playerTwo,
              poolTitle: l10n.gigPool,
              accent: _kGigPink,
              cred: _streetCred(2),
              pool: _poolOf(2),
              d20Locked: _d20Locked(2),
              onRoll: _rollDie,
            ),
          ],
        ),
      ),
    );
  }
}

class _SideGigField extends StatelessWidget {
  final String playerLabel;
  final String poolTitle;
  final Color accent;
  final int cred;
  final List<GigDie> pool;
  final bool d20Locked;
  final ValueChanged<GigDie> onRoll;

  const _SideGigField({
    required this.playerLabel,
    required this.poolTitle,
    required this.accent,
    required this.cred,
    required this.pool,
    required this.d20Locked,
    required this.onRoll,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: accent.withValues(alpha: 0.6)),
          color: _kGigPanel.withValues(alpha: 0.78),
        ),
        padding: const EdgeInsets.fromLTRB(6, 8, 6, 8),
        child: Column(
          children: [
            Text(
              playerLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.w800, color: accent, fontSize: 12),
            ),
            const SizedBox(height: 4),
            _CredBadge(value: cred, accent: accent),
            const SizedBox(height: 4),
            Text(
              poolTitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: accent.withValues(alpha: 0.75)),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: ListView(
                children: [
                  for (final die in pool)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Center(
                        child: PolyhedralDiceWidget(
                          sides: die.sides,
                          label: 'D${die.sides}',
                          color: die.originColor,
                          locked: die.sides == 20 && d20Locked,
                          onTap: () => onRoll(die),
                        ),
                      ),
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

class _CenterGigField extends StatelessWidget {
  final String title;
  final String playerOneLabel;
  final String playerTwoLabel;
  final List<GigDie> playerOneDice;
  final List<GigDie> playerTwoDice;
  final int playerOneCred;
  final int playerTwoCred;
  final ValueChanged<GigDie> onTapDie;
  final VoidCallback onReset;

  const _CenterGigField({
    required this.title,
    required this.playerOneLabel,
    required this.playerTwoLabel,
    required this.playerOneDice,
    required this.playerTwoDice,
    required this.playerOneCred,
    required this.playerTwoCred,
    required this.onTapDie,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kGigYellow.withValues(alpha: 0.5)),
        color: _kGigPanel,
      ),
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: _kGigYellow,
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: _PlayerBoardLane(
              label: playerTwoLabel,
              accent: _kGigPink,
              cred: playerTwoCred,
              dice: playerTwoDice,
              onTapDie: onTapDie,
            ),
          ),
          IconButton(
            tooltip: l10n.gigNewRound,
            onPressed: onReset,
            icon: const Icon(Icons.restart_alt_rounded, color: _kGigYellow),
          ),
          Expanded(
            child: _PlayerBoardLane(
              label: playerOneLabel,
              accent: _kGigCyan,
              cred: playerOneCred,
              dice: playerOneDice,
              onTapDie: onTapDie,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayerBoardLane extends StatelessWidget {
  final String label;
  final Color accent;
  final int cred;
  final List<GigDie> dice;
  final ValueChanged<GigDie> onTapDie;

  const _PlayerBoardLane({
    required this.label,
    required this.accent,
    required this.cred,
    required this.dice,
    required this.onTapDie,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _CredBadge(value: cred, accent: accent, compact: false),
        Text(
          label,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: accent),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: dice.isEmpty
              ? Center(
                  child: Text(
                    '—',
                    style: TextStyle(color: accent.withValues(alpha: 0.35), fontSize: 22),
                  ),
                )
              : SingleChildScrollView(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      for (final die in dice)
                        PolyhedralDiceWidget(
                          sides: die.sides,
                          label: '${die.value}',
                          color: die.originColor,
                          stolen: die.isStolen,
                          onTap: () => onTapDie(die),
                        ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}

class _CredBadge extends StatelessWidget {
  final int value;
  final Color accent;
  final bool compact;

  const _CredBadge({
    required this.value,
    required this.accent,
    this.compact = true,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        '${context.l10n.gigCredShort} $value',
        style: TextStyle(
          fontSize: compact ? 22 : 32,
          fontWeight: FontWeight.w900,
          color: accent,
          letterSpacing: 1.1,
          shadows: [
            Shadow(color: accent.withValues(alpha: 0.55), blurRadius: 12),
          ],
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
    final paintColor = locked ? Colors.blueGrey : color;
    final stolenLabel = context.l10n.gigStolen;

    return Opacity(
      opacity: locked ? 0.4 : 1,
      child: SizedBox(
        width: size,
        height: size + (stolen ? 10 : 0),
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
                    fontSize: label.startsWith('D') ? 13 : 20,
                    fontWeight: FontWeight.w900,
                    color: locked ? Colors.white70 : Colors.white,
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
                    bottom: 4,
                    right: 6,
                    child: Icon(Icons.lock, size: 12, color: Colors.white70),
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
      ..color = color.withValues(alpha: locked ? 0.12 : 0.22)
      ..style = PaintingStyle.fill;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.1
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);

    if (sides == 20 && !locked) {
      final inner = _regularPolygon(size, 6, inset: size.width * 0.22);
      canvas.drawPath(
        inner,
        Paint()
          ..color = color.withValues(alpha: 0.45)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
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
              const Radius.circular(10),
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
    final path = Path()
      ..moveTo(c.dx, 3)
      ..lineTo(size.width - 4, c.dy)
      ..lineTo(c.dx, size.height - 3)
      ..lineTo(4, c.dy)
      ..close();
    return path;
  }

  Path _kite(Size size) {
    final path = Path()
      ..moveTo(size.width / 2, 3)
      ..lineTo(size.width - 5, size.height * 0.42)
      ..lineTo(size.width / 2, size.height - 3)
      ..lineTo(5, size.height * 0.42)
      ..close();
    return path;
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
