import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../l10n/l10n.dart';

class DiceCoinView extends StatefulWidget {
  const DiceCoinView({super.key});

  @override
  State<DiceCoinView> createState() => _DiceCoinBoardState();
}

class _DiceCoinBoardState extends State<DiceCoinView>
    with SingleTickerProviderStateMixin {
  final _random = Random();
  late final AnimationController _spin;
  bool _heads = true;
  int? _d6;
  int? _d20;
  String? _starter;

  @override
  void initState() {
    super.initState();
    _spin = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 720),
    );
  }

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  bool get _busy => _spin.isAnimating;

  Future<void> _animate(VoidCallback apply) async {
    if (_busy) return;
    HapticFeedback.mediumImpact();
    await _spin.forward(from: 0);
    if (!mounted) return;
    setState(apply);
  }

  Future<void> _flip() async {
    final next = _random.nextBool();
    await _animate(() => _heads = next);
  }

  Future<void> _roll(int sides) async {
    final next = _random.nextInt(sides) + 1;
    await _animate(() {
      if (sides == 6) {
        _d6 = next;
      } else {
        _d20 = next;
      }
    });
  }

  Future<void> _pickStarter() async {
    final l10n = context.l10n;
    final first = _random.nextBool() ? l10n.playerOne : l10n.playerTwo;
    await _animate(() => _starter = first);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        _ToolCard(
          child: Column(
            children: [
              AnimatedBuilder(
                animation: _spin,
                builder: (context, _) {
                  final turns = _spin.value * 2;
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.002)
                      ..rotateY(turns * pi),
                    child: Container(
                      width: 140,
                      height: 140,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            scheme.primary,
                            scheme.tertiary,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: scheme.primary.withValues(alpha: 0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Text(
                        _heads ? l10n.coinHeads : l10n.coinTails,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: _busy ? null : _flip,
                  icon: const Icon(Icons.toll_rounded),
                  label: Text(l10n.flipCoin),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _DiceButton(
                label: l10n.d6,
                value: _d6,
                onTap: _busy ? null : () => _roll(6),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _DiceButton(
                label: l10n.d20,
                value: _d20,
                onTap: _busy ? null : () => _roll(20),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _ToolCard(
          child: Column(
            children: [
              if (_starter != null) ...[
                Text(
                  l10n.starterResult(_starter!),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: scheme.primary,
                  ),
                ),
                const SizedBox(height: 12),
              ],
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.tonalIcon(
                  onPressed: _busy ? null : _pickStarter,
                  icon: const Icon(Icons.people_alt_rounded),
                  label: Text(l10n.randomStarter),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ToolCard extends StatelessWidget {
  final Widget child;

  const _ToolCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: scheme.surface,
        border: Border.all(color: scheme.outline.withValues(alpha: 0.25)),
      ),
      child: child,
    );
  }
}

class _DiceButton extends StatelessWidget {
  final String label;
  final int? value;
  final VoidCallback? onTap;

  const _DiceButton({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 148,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: scheme.primary.withValues(alpha: 0.35)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: scheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${value ?? '–'}',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: scheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
