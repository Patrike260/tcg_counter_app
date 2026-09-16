import 'dart:math';

import 'package:flutter/material.dart';

class DiceCoinDialog extends StatefulWidget {
  const DiceCoinDialog({super.key});

  @override
  State<DiceCoinDialog> createState() => _DiceCoinDialogState();
}

enum _RollMode { d20, d6, coin, multi }

class _DiceCoinDialogState extends State<DiceCoinDialog>
    with SingleTickerProviderStateMixin {
  static const _gold = Color(0xFFFFC107);
  static const _surface = Color(0xFF1E1E2C);
  static const _multiDiceTypes = [4, 6, 8, 10, 12, 20];

  final _random = Random();
  late final AnimationController _controller;
  late final Animation<double> _spin;

  _RollMode _mode = _RollMode.d20;
  bool _isHeads = true;
  int? _diceValue;
  int _multiSides = 6;
  int _multiCount = 2;
  List<int> _multiRolls = const [];
  final List<String> _history = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _spin = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _busy => _controller.isAnimating;

  int get _multiTotal => _multiRolls.fold(0, (sum, value) => sum + value);

  bool get _isMaxSingle {
    if (_diceValue == null) return false;
    if (_mode == _RollMode.d20) return _diceValue == 20;
    if (_mode == _RollMode.d6) return _diceValue == 6;
    return false;
  }

  Future<void> _animateThen(VoidCallback applyResult) async {
    if (_busy) return;
    await _controller.forward(from: 0);
    if (!mounted) return;
    setState(applyResult);
  }

  void _pushHistory(String entry) {
    _history.insert(0, entry);
    if (_history.length > 5) _history.removeLast();
  }

  Future<void> _rollSingle(int sides) async {
    final next = _random.nextInt(sides) + 1;
    await _animateThen(() {
      _diceValue = next;
      _pushHistory('D$sides: $next');
    });
  }

  Future<void> _flipCoin() async {
    final nextHeads = _random.nextBool();
    await _animateThen(() {
      _isHeads = nextHeads;
      _pushHistory(nextHeads ? 'Kopf' : 'Zahl');
    });
  }

  Future<void> _rollMulti() async {
    final rolls = List<int>.generate(
      _multiCount,
      (_) => _random.nextInt(_multiSides) + 1,
    );
    await _animateThen(() {
      _multiRolls = rolls;
      _pushHistory('${rolls.length}×D$_multiSides = ${rolls.fold(0, (a, b) => a + b)}');
    });
  }

  void _setMode(_RollMode mode) {
    if (_busy || mode == _mode) return;
    setState(() {
      _mode = mode;
      _diceValue = null;
      _controller.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: _surface,
      surfaceTintColor: Colors.deepPurple.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Auslosen'),
      content: SizedBox(
        width: 380,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Wer fängt an? Modus wählen und tippen.',
                style: TextStyle(color: Colors.white70, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              SegmentedButton<_RollMode>(
                showSelectedIcon: false,
                style: const ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                segments: const [
                  ButtonSegment(value: _RollMode.d20, label: Text('D20')),
                  ButtonSegment(value: _RollMode.d6, label: Text('D6')),
                  ButtonSegment(value: _RollMode.coin, label: Text('Münze')),
                  ButtonSegment(value: _RollMode.multi, label: Text('Multi')),
                ],
                selected: {_mode},
                onSelectionChanged: _busy
                    ? null
                    : (set) => _setMode(set.first),
              ),
              const SizedBox(height: 20),
              switch (_mode) {
                _RollMode.d20 => _buildSingleDiceArea(sides: 20),
                _RollMode.d6 => _buildSingleDiceArea(sides: 6),
                _RollMode.coin => _buildCoinArea(),
                _RollMode.multi => _buildMultiArea(),
              },
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _history.isEmpty
                      ? 'Historie: –'
                      : 'Historie: ${_history.join(' · ')}',
                  style: const TextStyle(color: Colors.white60, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Schließen'),
        ),
      ],
    );
  }

  Widget _buildSingleDiceArea({required int sides}) {
    final accent = (!_busy && _isMaxSingle) ? _gold : Colors.deepPurpleAccent;
    return Column(
      children: [
        AnimatedBuilder(
          animation: _spin,
          builder: (context, child) {
            final shake = sin(_spin.value * pi * 8) * (1 - _spin.value) * 12;
            return Transform.rotate(
              angle: shake * 0.08,
              child: Transform.translate(
                offset: Offset(shake, 0),
                child: _DiceDisplay(
                  value: _diceValue,
                  gold: accent,
                  sides: sides,
                  busy: _busy,
                  onTap: _busy ? null : () => _rollSingle(sides),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: _busy ? null : () => _rollSingle(sides),
          icon: const Icon(Icons.casino),
          label: Text('D$sides würfeln'),
        ),
        const SizedBox(height: 10),
        Text(
          _busy ? '…' : '${_diceValue ?? '–'}',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: accent,
          ),
        ),
      ],
    );
  }

  Widget _buildCoinArea() {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _spin,
          builder: (context, child) {
            final angle = _spin.value * pi * 6;
            final showHeads = (angle / pi).floor().isEven ? _isHeads : !_isHeads;
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0012)
                ..rotateY(angle),
              child: GestureDetector(
                onTap: _busy ? null : _flipCoin,
                child: _CoinFace(isHeads: showHeads, gold: _gold),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: _busy ? null : _flipCoin,
          icon: const Icon(Icons.sync),
          label: const Text('Münze werfen'),
        ),
        const SizedBox(height: 10),
        Text(
          _busy ? '…' : (_isHeads ? 'Kopf' : 'Zahl'),
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: _gold,
          ),
        ),
      ],
    );
  }

  Widget _buildMultiArea() {
    final hasResult = _multiRolls.isNotEmpty;
    final isMax = hasResult && !_busy && _multiRolls.every((v) => v == _multiSides);
    final accent = isMax ? _gold : Colors.deepPurpleAccent;

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Welcher Würfel?',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: _multiDiceTypes.map((sides) {
            final selected = _multiSides == sides;
            return ChoiceChip(
              label: Text('D$sides'),
              selected: selected,
              onSelected: _busy
                  ? null
                  : (_) {
                      setState(() {
                        _multiSides = sides;
                        _multiRolls = const [];
                      });
                    },
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Text(
              'Anzahl',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            ),
            const Spacer(),
            IconButton.outlined(
              onPressed: _busy || _multiCount <= 1
                  ? null
                  : () => setState(() {
                        _multiCount--;
                        _multiRolls = const [];
                      }),
              icon: const Icon(Icons.remove),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                '$_multiCount',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton.outlined(
              onPressed: _busy || _multiCount >= 12
                  ? null
                  : () => setState(() {
                        _multiCount++;
                        _multiRolls = const [];
                      }),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        const SizedBox(height: 12),
        AnimatedBuilder(
          animation: _spin,
          builder: (context, child) {
            final shake = sin(_spin.value * pi * 8) * (1 - _spin.value) * 10;
            return Transform.translate(
              offset: Offset(shake, 0),
              child: child,
            );
          },
          child: GestureDetector(
            onTap: _busy ? null : _rollMulti,
            child: Column(
            children: [
              Text(
                _busy ? '…' : (hasResult ? '$_multiTotal' : '–'),
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  color: accent,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                hasResult && !_busy
                    ? '$_multiCount×D$_multiSides'
                    : '$_multiCount×D$_multiSides bereit',
                style: const TextStyle(color: Colors.white60, fontSize: 12),
              ),
            ],
          ),
          ),
        ),
        if (hasResult && !_busy) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            alignment: WrapAlignment.center,
            children: [
              for (var i = 0; i < _multiRolls.length; i++) ...[
                _ResultChip(
                  value: _multiRolls[i],
                  highlight: _multiRolls[i] == _multiSides,
                ),
                if (i != _multiRolls.length - 1)
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Text('+', style: TextStyle(color: Colors.white54)),
                  ),
              ],
              const Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text('=', style: TextStyle(color: Colors.white54)),
              ),
              _ResultChip(value: _multiTotal, highlight: isMax, isTotal: true),
            ],
          ),
        ],
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: _busy ? null : _rollMulti,
          icon: const Icon(Icons.casino),
          label: Text('$_multiCount×D$_multiSides würfeln'),
        ),
      ],
    );
  }
}

class _CoinFace extends StatelessWidget {
  final bool isHeads;
  final Color gold;

  const _CoinFace({required this.isHeads, required this.gold});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 128,
      height: 128,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            gold.withValues(alpha: 0.95),
            const Color(0xFFB8860B),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: gold.withValues(alpha: 0.35),
            blurRadius: 16,
            spreadRadius: 1,
          ),
        ],
        border: Border.all(color: Colors.white24, width: 3),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isHeads ? Icons.person : Icons.paid,
            size: 48,
            color: const Color(0xFF1E1E2C),
          ),
          const SizedBox(height: 4),
          Text(
            isHeads ? 'KOPF' : 'ZAHL',
            style: const TextStyle(
              color: Color(0xFF1E1E2C),
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _DiceDisplay extends StatelessWidget {
  final int? value;
  final Color gold;
  final int sides;
  final bool busy;
  final VoidCallback? onTap;

  _DiceDisplay({
    required this.value,
    required this.gold,
    required this.sides,
    required this.busy,
    this.onTap,
  });

  IconData get _icon {
    if (sides > 6) return Icons.hexagon_outlined;
    final shown = value ?? sides;
    switch (shown.clamp(1, 6)) {
      case 1:
        return Icons.looks_one;
      case 2:
        return Icons.looks_two;
      case 3:
        return Icons.looks_3;
      case 4:
        return Icons.looks_4;
      case 5:
        return Icons.looks_5;
      default:
        return Icons.looks_6;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(sides > 6 ? 64 : 22),
        ),
        child: Container(
          width: 128,
          height: 128,
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A3C),
            borderRadius: BorderRadius.circular(sides > 6 ? 64 : 22),
            border: Border.all(color: gold.withValues(alpha: 0.7), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withValues(alpha: 0.35),
                blurRadius: 16,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_icon, size: 48, color: gold),
              Text(
                busy ? 'D$sides' : '${value ?? 'D$sides'}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: gold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultChip extends StatelessWidget {
  final int value;
  final bool highlight;
  final bool isTotal;

  const _ResultChip({
    required this.value,
    this.highlight = false,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: highlight
            ? const Color(0xFFFFC107).withValues(alpha: 0.2)
            : Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: highlight ? const Color(0xFFFFC107) : Colors.white24,
        ),
      ),
      child: Text(
        isTotal ? '= $value' : '$value',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: highlight ? const Color(0xFFFFC107) : Colors.white,
        ),
      ),
    );
  }
}
