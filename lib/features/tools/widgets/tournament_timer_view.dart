import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../l10n/l10n.dart';

class TournamentTimerView extends StatefulWidget {
  const TournamentTimerView({super.key});

  @override
  State<TournamentTimerView> createState() => _TournamentTimerViewState();
}

class _TournamentTimerViewState extends State<TournamentTimerView>
    with SingleTickerProviderStateMixin {
  int _minutes = 50;
  late Duration _remaining;
  bool _running = false;
  Timer? _clock;
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _remaining = Duration(minutes: _minutes);
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void dispose() {
    _clock?.cancel();
    _pulse.dispose();
    super.dispose();
  }

  bool get _critical =>
      _remaining.inSeconds > 0 && _remaining.inSeconds <= 5 * 60;

  void _syncPulse() {
    if (_critical && _running) {
      if (!_pulse.isAnimating) _pulse.repeat(reverse: true);
    } else {
      _pulse
        ..stop()
        ..value = 0;
    }
  }

  void _selectMinutes(int minutes) {
    HapticFeedback.selectionClick();
    _clock?.cancel();
    setState(() {
      _minutes = minutes;
      _remaining = Duration(minutes: minutes);
      _running = false;
    });
    _syncPulse();
  }

  void _toggle() {
    HapticFeedback.mediumImpact();
    if (_running) {
      _clock?.cancel();
      setState(() => _running = false);
      _syncPulse();
      return;
    }
    if (_remaining.inSeconds <= 0) {
      setState(() => _remaining = Duration(minutes: _minutes));
    }
    _clock?.cancel();
    _clock = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_remaining.inSeconds <= 1) {
        _clock?.cancel();
        HapticFeedback.heavyImpact();
        setState(() {
          _remaining = Duration.zero;
          _running = false;
        });
        _syncPulse();
        return;
      }
      setState(() => _remaining -= const Duration(seconds: 1));
      _syncPulse();
    });
    setState(() => _running = true);
    _syncPulse();
  }

  void _reset() {
    HapticFeedback.selectionClick();
    _clock?.cancel();
    setState(() {
      _remaining = Duration(minutes: _minutes);
      _running = false;
    });
    _syncPulse();
  }

  String get _clockLabel {
    final total = _remaining.inSeconds;
    final minutes = (total ~/ 60).toString().padLeft(2, '0');
    final seconds = (total % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        children: [
          SegmentedButton<int>(
            segments: [
              ButtonSegment(value: 30, label: Text(l10n.timerPreset30)),
              ButtonSegment(value: 45, label: Text(l10n.timerPreset45)),
              ButtonSegment(value: 50, label: Text(l10n.timerPreset50)),
            ],
            selected: {_minutes},
            onSelectionChanged: (values) => _selectMinutes(values.first),
          ),
          const Spacer(),
          AnimatedBuilder(
            animation: _pulse,
            builder: (context, _) {
              final t = _critical ? _pulse.value : 0.0;
              final color = Color.lerp(
                scheme.onSurface,
                Colors.redAccent,
                _critical ? 0.55 + (t * 0.45) : 0,
              )!;
              return Text(
                _clockLabel,
                style: TextStyle(
                  fontSize: 84,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  height: 1,
                  color: color,
                  shadows: _critical
                      ? [
                          Shadow(
                            color: Colors.redAccent.withValues(alpha: 0.35 + t * 0.35),
                            blurRadius: 18 + t * 10,
                          ),
                        ]
                      : null,
                ),
              );
            },
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: _toggle,
                  icon: Icon(_running ? Icons.pause_rounded : Icons.play_arrow_rounded),
                  label: Text(_running ? l10n.timerPause : l10n.timerStart),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.restart_alt_rounded),
                  label: Text(l10n.reset),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
