import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/l10n.dart';
import '../../decks/deck_model.dart';
import '../../decks/deck_repository.dart';
import '../../matches/add_match_dialog.dart';

class LifeCounterView extends ConsumerStatefulWidget {
  const LifeCounterView({super.key});

  @override
  ConsumerState<LifeCounterView> createState() => _LifeCounterBoardState();
}

class _LifeCounterBoardState extends ConsumerState<LifeCounterView> {
  int _starting = 20;
  int _you = 20;
  int _opponent = 20;

  bool get _gameOver => _you == 0 || _opponent == 0;

  void _setPreset(int value) {
    HapticFeedback.mediumImpact();
    setState(() {
      _starting = value;
      _you = value;
      _opponent = value;
    });
  }

  void _adjustYou(int delta) {
    setState(() => _you = (_you + delta).clamp(0, 99999));
  }

  void _adjustOpponent(int delta) {
    setState(() => _opponent = (_opponent + delta).clamp(0, 99999));
  }

  int get _tapStep => _starting >= 1000 ? 100 : 1;
  int get _holdStep => _starting >= 1000 ? 500 : 5;

  Future<void> _saveMatch() async {
    final l10n = context.l10n;
    List<Deck> resolved;
    try {
      resolved = await ref.read(userDecksProvider.future);
    } catch (_) {
      resolved = const [];
    }
    if (!mounted) return;
    if (resolved.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.needDeckForMatch)),
      );
      return;
    }

    final chosen = await showDialog<Deck>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.chooseOwnDeck),
        content: SizedBox(
          width: 360,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: resolved.length,
            itemBuilder: (context, index) {
              final deck = resolved[index];
              return ListTile(
                title: Text(deck.name),
                subtitle: Text(deck.gameName ?? ''),
                onTap: () => Navigator.pop(ctx, deck),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
    if (chosen == null || !mounted) return;

    final result = _you == _opponent
        ? 'draw'
        : (_you > _opponent ? 'win' : 'loss');

    await showDialog<void>(
      context: context,
      builder: (_) => AddMatchDialog(
        deckId: chosen.id,
        gameId: chosen.gameId,
        suggestedResult: result,
        suggestedScore: '$_you-$_opponent',
        suggestedNotes: 'Life Counter: $_you – $_opponent',
      ),
    );
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
            child: _LifeSeat(
              name: l10n.lifeOpponent,
              life: _opponent,
              accent: scheme.tertiary,
              tapStep: _tapStep,
              holdStep: _holdStep,
              onChange: _adjustOpponent,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            children: [
              SegmentedButton<int>(
                segments: [
                  ButtonSegment(value: 20, label: Text(l10n.lifePresetMtg)),
                  ButtonSegment(value: 50, label: Text(l10n.lifePresetOp)),
                  ButtonSegment(value: 8000, label: Text(l10n.lifePresetYgo)),
                ],
                selected: {_starting},
                onSelectionChanged: (values) => _setPreset(values.first),
              ),
              if (_gameOver) ...[
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton.icon(
                    onPressed: _saveMatch,
                    icon: const Icon(Icons.save_outlined),
                    label: Text(l10n.saveMatch),
                  ),
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: _LifeSeat(
            name: l10n.lifeYou,
            life: _you,
            accent: scheme.primary,
            tapStep: _tapStep,
            holdStep: _holdStep,
            onChange: _adjustYou,
          ),
        ),
      ],
    );
  }
}

class _LifeSeat extends StatefulWidget {
  final String name;
  final int life;
  final Color accent;
  final int tapStep;
  final int holdStep;
  final ValueChanged<int> onChange;

  const _LifeSeat({
    required this.name,
    required this.life,
    required this.accent,
    required this.tapStep,
    required this.holdStep,
    required this.onChange,
  });

  @override
  State<_LifeSeat> createState() => _LifeSeatState();
}

class _LifeSeatState extends State<_LifeSeat> {
  String? _flash;
  Timer? _flashTimer;

  @override
  void dispose() {
    _flashTimer?.cancel();
    super.dispose();
  }

  void _apply(int delta) {
    HapticFeedback.selectionClick();
    widget.onChange(delta);
    setState(() => _flash = delta > 0 ? '+$delta' : '$delta');
    _flashTimer?.cancel();
    _flashTimer = Timer(const Duration(milliseconds: 420), () {
      if (mounted) setState(() => _flash = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: widget.accent.withValues(alpha: 0.14)),
            Row(
              children: [
                Expanded(
                  child: _TouchZone(
                    label: '-${widget.tapStep}',
                    align: Alignment.centerLeft,
                    onTap: () => _apply(-widget.tapStep),
                    onLongPress: () => _apply(-widget.holdStep),
                  ),
                ),
                Expanded(
                  child: _TouchZone(
                    label: '+${widget.tapStep}',
                    align: Alignment.centerRight,
                    onTap: () => _apply(widget.tapStep),
                    onLongPress: () => _apply(widget.holdStep),
                  ),
                ),
              ],
            ),
            IgnorePointer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: widget.accent,
                    ),
                  ),
                  Text(
                    '${widget.life}',
                    style: TextStyle(
                      fontSize: widget.life >= 1000 ? 56 : 72,
                      fontWeight: FontWeight.w900,
                      height: 1,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: _flash == null ? 0 : 1,
                    duration: const Duration(milliseconds: 180),
                    child: Text(
                      _flash ?? '',
                      style: TextStyle(
                        fontSize: 22,
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
          ],
        ),
      ),
    );
  }
}

class _TouchZone extends StatelessWidget {
  final String label;
  final Alignment align;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _TouchZone({
    required this.label,
    required this.align,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Align(
          alignment: align,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.28),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
