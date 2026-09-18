import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../l10n/l10n.dart';

const _kReadyBlue = Color(0xFF00B0FF);
const _kTappedGray = Color(0xFF90A4AE);
const int _kChakraDeckSize = 12;

class ChakraTrackerView extends StatefulWidget {
  const ChakraTrackerView({super.key});

  @override
  State<ChakraTrackerView> createState() => _MythosChakraBoardState();
}

class _MythosChakraBoardState extends State<ChakraTrackerView> {
  int totalChakra = 1;
  int availableChakra = 1;
  int remainingDeck = 11;

  int get _tapped => (totalChakra - availableChakra).clamp(0, totalChakra);

  void _pay(int cost) {
    if (availableChakra < 1) return;
    HapticFeedback.selectionClick();
    setState(() {
      availableChakra = (availableChakra - cost).clamp(0, totalChakra);
    });
  }

  void _endTurn() {
    HapticFeedback.mediumImpact();
    setState(() {
      if (totalChakra < _kChakraDeckSize) {
        totalChakra += 1;
      }
      if (remainingDeck > 0) {
        remainingDeck -= 1;
      }
      availableChakra = totalChakra;
    });
  }

  void _refreshOnly() {
    HapticFeedback.selectionClick();
    setState(() => availableChakra = totalChakra);
  }

  void _adjustDeck(int delta) {
    HapticFeedback.selectionClick();
    setState(() {
      remainingDeck = (remainingDeck + delta).clamp(0, _kChakraDeckSize);
    });
  }

  void _adjustZoneMax(int delta) {
    HapticFeedback.selectionClick();
    setState(() {
      final next = (totalChakra + delta).clamp(1, _kChakraDeckSize);
      if (next > totalChakra) {
        availableChakra = (availableChakra + (next - totalChakra)).clamp(0, next);
      } else {
        availableChakra = availableChakra.clamp(0, next);
      }
      totalChakra = next;
    });
  }

  void _resetTurnOne() {
    HapticFeedback.mediumImpact();
    setState(() {
      totalChakra = 1;
      availableChakra = 1;
      remainingDeck = 11;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _kReadyBlue.withValues(alpha: 0.18),
                scheme.surface,
              ],
            ),
            border: Border.all(color: _kReadyBlue.withValues(alpha: 0.45)),
          ),
          child: Column(
            children: [
              Text(
                l10n.chakraReadyLabel,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface.withValues(alpha: 0.75),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 168,
                height: 168,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 168,
                      height: 168,
                      child: CircularProgressIndicator(
                        value: totalChakra == 0 ? 0 : 1,
                        strokeWidth: 12,
                        color: _kTappedGray.withValues(alpha: 0.45),
                        backgroundColor: scheme.surfaceContainerHighest,
                      ),
                    ),
                    SizedBox(
                      width: 168,
                      height: 168,
                      child: CircularProgressIndicator(
                        value: totalChakra == 0
                            ? 0
                            : availableChakra / totalChakra,
                        strokeWidth: 12,
                        color: _kReadyBlue,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.chakraReadyRatio(availableChakra, totalChakra),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: _kReadyBlue,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.chakraTappedHint(_tapped),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _kTappedGray,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: availableChakra >= 1 ? () => _pay(1) : null,
                style: FilledButton.styleFrom(
                  backgroundColor: scheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(l10n.chakraPay1),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton.tonal(
                onPressed: availableChakra >= 2 ? () => _pay(2) : null,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(l10n.chakraPay2),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        FilledButton.icon(
          onPressed: _endTurn,
          icon: const Icon(Icons.skip_next_rounded),
          style: FilledButton.styleFrom(
            backgroundColor: _kReadyBlue,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          label: Text(
            l10n.chakraEndTurn,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _refreshOnly,
          icon: const Icon(Icons.autorenew_rounded),
          label: Text(l10n.chakraRefreshOnly),
        ),
        const SizedBox(height: 20),
        _AdjustBar(
          title: l10n.chakraDeckTitle,
          valueLabel: l10n.chakraDeckRemaining(remainingDeck),
          onMinus: remainingDeck > 0 ? () => _adjustDeck(-1) : null,
          onPlus: remainingDeck < _kChakraDeckSize ? () => _adjustDeck(1) : null,
        ),
        const SizedBox(height: 10),
        _AdjustBar(
          title: l10n.chakraZoneMax,
          valueLabel: '$totalChakra / $_kChakraDeckSize',
          onMinus: totalChakra > 1 ? () => _adjustZoneMax(-1) : null,
          onPlus: totalChakra < _kChakraDeckSize ? () => _adjustZoneMax(1) : null,
        ),
        const SizedBox(height: 14),
        TextButton.icon(
          onPressed: _resetTurnOne,
          icon: const Icon(Icons.restart_alt_rounded),
          label: Text(l10n.chakraResetTurn1),
        ),
      ],
    );
  }
}

class _AdjustBar extends StatelessWidget {
  final String title;
  final String valueLabel;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;

  const _AdjustBar({
    required this.title,
    required this.valueLabel,
    required this.onMinus,
    required this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: scheme.surface,
        border: Border.all(color: scheme.outline.withValues(alpha: 0.28)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                Text(
                  valueLabel,
                  style: TextStyle(
                    fontSize: 13,
                    color: scheme.onSurface.withValues(alpha: 0.65),
                  ),
                ),
              ],
            ),
          ),
          IconButton.filledTonal(
            onPressed: onMinus,
            icon: const Icon(Icons.remove),
          ),
          IconButton.filledTonal(
            onPressed: onPlus,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
