import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../l10n/l10n.dart';

Color _onAccent(Color color) {
  return ThemeData.estimateBrightnessForColor(color) == Brightness.dark
      ? Colors.white
      : const Color(0xFF121212);
}

class DigimonMemoryView extends StatefulWidget {
  const DigimonMemoryView({super.key});

  @override
  State<DigimonMemoryView> createState() => _DigimonTapGaugeState();
}

class _DigimonTapGaugeState extends State<DigimonMemoryView> {
  /// -10 = Spieler 1 hat 10 Memory, 0 = Mitte, +10 = Spieler 2 hat 10 Memory.
  int _memory = 0;
  bool _turnPassed = false;

  bool get _playerOneTurn => _memory <= 0;

  int get _displayMemory => _memory.abs();

  void _setMemory(int next) {
    final clamped = next.clamp(-10, 10);
    final wasP1 = _playerOneTurn;
    HapticFeedback.selectionClick();
    setState(() {
      _memory = clamped;
      _turnPassed = wasP1 != (_memory <= 0);
    });
  }

  void _nudge(int delta) {
    _setMemory(_memory + delta);
  }

  void _resetZero() {
    HapticFeedback.mediumImpact();
    setState(() {
      _memory = 0;
      _turnPassed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final p1Color = scheme.primary;
    final p2Color = scheme.tertiary;
    final activeColor = _playerOneTurn ? p1Color : p2Color;
    final turnLabel = _playerOneTurn ? l10n.digimonTurnP1 : l10n.digimonTurnP2;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: activeColor.withValues(alpha: 0.18),
              border: Border.all(color: activeColor, width: 1.6),
            ),
            child: Column(
              children: [
                Text(
                  turnLabel,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: activeColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _memory == 0
                      ? '0'
                      : '${_playerOneTurn ? l10n.playerOne : l10n.playerTwo}: $_displayMemory',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface.withValues(alpha: 0.75),
                  ),
                ),
                if (_turnPassed) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: scheme.secondary.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      l10n.digimonTurnPass,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: scheme.secondary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          _MemoryTapStrip(
            memory: _memory,
            playerOneColor: p1Color,
            playerTwoColor: p2Color,
            playerOneLabel: l10n.playerOne,
            playerTwoLabel: l10n.playerTwo,
            onSelect: _setMemory,
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 64,
                  child: FilledButton(
                    onPressed: _memory > -10 ? () => _nudge(-1) : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: p1Color,
                      foregroundColor: _onAccent(p1Color),
                    ),
                    child: const Text(
                      '− 1',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 64,
                  child: FilledButton(
                    onPressed: _memory < 10 ? () => _nudge(1) : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: p2Color,
                      foregroundColor: _onAccent(p2Color),
                    ),
                    child: const Text(
                      '+ 1',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: _resetZero,
              icon: const Icon(Icons.restart_alt_rounded),
              label: Text(l10n.digimonResetZero),
            ),
          ),
        ],
      ),
    );
  }
}

class _MemoryTapStrip extends StatelessWidget {
  final int memory;
  final Color playerOneColor;
  final Color playerTwoColor;
  final String playerOneLabel;
  final String playerTwoLabel;
  final ValueChanged<int> onSelect;

  const _MemoryTapStrip({
    required this.memory,
    required this.playerOneColor,
    required this.playerTwoColor,
    required this.playerOneLabel,
    required this.playerTwoLabel,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                playerOneLabel,
                style: TextStyle(fontWeight: FontWeight.w800, color: playerOneColor),
              ),
            ),
            Expanded(
              child: Text(
                playerTwoLabel,
                textAlign: TextAlign.right,
                style: TextStyle(fontWeight: FontWeight.w800, color: playerTwoColor),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            final cellWidth = constraints.maxWidth / 21;
            return SizedBox(
              height: 72,
              child: Row(
                children: [
                  for (var i = 0; i < 21; i++)
                    _MemoryTapCell(
                      width: cellWidth,
                      label: i == 10 ? '0' : '${(i - 10).abs()}',
                      selected: i == memory + 10,
                      color: i < 10
                          ? playerOneColor
                          : i > 10
                              ? playerTwoColor
                              : scheme.onSurface,
                      isCenter: i == 10,
                      onTap: () => onSelect(i - 10),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _MemoryTapCell extends StatelessWidget {
  final double width;
  final String label;
  final bool selected;
  final Color color;
  final bool isCenter;
  final VoidCallback onTap;

  const _MemoryTapCell({
    required this.width,
    required this.label,
    required this.selected,
    required this.color,
    required this.isCenter,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            margin: const EdgeInsets.symmetric(horizontal: 0.6),
            decoration: BoxDecoration(
              color: selected ? color : color.withValues(alpha: isCenter ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: selected ? color : color.withValues(alpha: 0.4),
                width: selected ? 2.2 : 1,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                fontSize: selected ? 13 : 10,
                fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
                color: selected ? _onAccent(color) : color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
