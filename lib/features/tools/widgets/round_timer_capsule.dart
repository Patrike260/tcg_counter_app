import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/l10n.dart';
import '../round_timer_service.dart';

class RoundTimerCapsule extends ConsumerStatefulWidget {
  const RoundTimerCapsule({super.key});

  @override
  ConsumerState<RoundTimerCapsule> createState() => _RoundTimerCapsuleState();
}

class _RoundTimerCapsuleState extends ConsumerState<RoundTimerCapsule>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _syncPulse(ref.read(roundTimerProvider));
    });
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  void _syncPulse(RoundTimerState timer) {
    if (timer.isOvertime) {
      if (!_pulse.isAnimating) _pulse.repeat(reverse: true);
    } else {
      _pulse
        ..stop()
        ..value = 0;
    }
  }

  Future<void> _openSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const _RoundTimerSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timer = ref.watch(roundTimerProvider);
    ref.listen<RoundTimerState>(roundTimerProvider, (previous, next) {
      _syncPulse(next);
    });
    final scheme = Theme.of(context).colorScheme;

    Color border;
    Color fill;
    Color foreground;
    if (timer.isOvertime) {
      border = const Color(0xFFFF1744);
      fill = const Color(0xFFFF1744).withValues(alpha: 0.22);
      foreground = const Color(0xFFFF8A80);
    } else if (timer.isWarning) {
      border = const Color(0xFFFFB300);
      fill = const Color(0xFFFFB300).withValues(alpha: 0.16);
      foreground = const Color(0xFFFFC107);
    } else {
      border = scheme.outline.withValues(alpha: 0.45);
      fill = scheme.primary.withValues(alpha: 0.10);
      foreground = scheme.onSurface.withValues(alpha: 0.82);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (context, _) {
          final glow = timer.isOvertime ? 0.35 + (_pulse.value * 0.45) : 0.0;
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _openSheet,
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Color.lerp(fill, Colors.redAccent, glow * 0.45),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Color.lerp(border, Colors.redAccent, glow) ?? border,
                    width: timer.isOvertime ? 1.6 : 1,
                  ),
                  boxShadow: timer.isOvertime
                      ? [
                          BoxShadow(
                            color: Colors.redAccent.withValues(alpha: 0.25 + glow * 0.35),
                            blurRadius: 10 + glow * 8,
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      timer.isRunning
                          ? Icons.timer_outlined
                          : Icons.timer_off_outlined,
                      size: 16,
                      color: foreground,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      timer.clockLabel,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                        fontFeatures: const [FontFeature.tabularFigures()],
                        color: foreground.withValues(
                          alpha: timer.isOvertime ? 0.55 + _pulse.value * 0.45 : 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RoundTimerSheet extends ConsumerWidget {
  const _RoundTimerSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final timer = ref.watch(roundTimerProvider);
    final notifier = ref.read(roundTimerProvider.notifier);
    final scheme = Theme.of(context).colorScheme;
    final clockColor = timer.isOvertime
        ? Colors.redAccent
        : timer.isWarning
            ? const Color(0xFFFFB300)
            : scheme.onSurface;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.roundTimer,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Text(
              timer.clockLabel,
              style: TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.w900,
                height: 1,
                letterSpacing: 1.5,
                color: clockColor,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      if (timer.isRunning) {
                        notifier.pauseTimer();
                      } else if (timer.durationSeconds <= 0 && !timer.isOvertime) {
                        notifier.startTimer();
                      } else {
                        notifier.resumeTimer();
                      }
                    },
                    icon: Icon(
                      timer.isRunning
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                    ),
                    label: Text(timer.isRunning ? l10n.timerPause : l10n.timerStart),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => notifier.resetTimer(),
                    icon: const Icon(Icons.restart_alt_rounded),
                    label: Text(l10n.reset),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SegmentedButton<int>(
              segments: [
                ButtonSegment(value: 30, label: Text(l10n.timerPreset30)),
                ButtonSegment(value: 45, label: Text(l10n.timerPreset45)),
                ButtonSegment(value: 50, label: Text(l10n.timerPreset50)),
              ],
              selected: {timer.presetMinutes},
              onSelectionChanged: (values) {
                notifier.resetTimer(minutes: values.first);
              },
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonalIcon(
                onPressed: () => notifier.addMinutes(5),
                icon: const Icon(Icons.more_time_rounded),
                label: Text(l10n.timerAddFive),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
