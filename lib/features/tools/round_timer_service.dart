import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../settings/app_preferences_service.dart';

class RoundTimerState {
  final int durationSeconds;
  final bool isRunning;
  final bool isOvertime;
  final int overtimeSeconds;
  final int presetMinutes;

  const RoundTimerState({
    required this.durationSeconds,
    required this.isRunning,
    required this.isOvertime,
    required this.overtimeSeconds,
    required this.presetMinutes,
  });

  static const int defaultPresetMinutes = 50;

  bool get isWarning =>
      !isOvertime && durationSeconds > 0 && durationSeconds <= 5 * 60;

  String get clockLabel {
    if (isOvertime) {
      return '+${_formatSeconds(overtimeSeconds)}';
    }
    return _formatSeconds(durationSeconds);
  }

  RoundTimerState copyWith({
    int? durationSeconds,
    bool? isRunning,
    bool? isOvertime,
    int? overtimeSeconds,
    int? presetMinutes,
  }) {
    return RoundTimerState(
      durationSeconds: durationSeconds ?? this.durationSeconds,
      isRunning: isRunning ?? this.isRunning,
      isOvertime: isOvertime ?? this.isOvertime,
      overtimeSeconds: overtimeSeconds ?? this.overtimeSeconds,
      presetMinutes: presetMinutes ?? this.presetMinutes,
    );
  }

  static String _formatSeconds(int total) {
    final clamped = total < 0 ? 0 : total;
    final minutes = (clamped ~/ 60).toString().padLeft(2, '0');
    final seconds = (clamped % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

final roundTimerProvider =
    NotifierProvider<RoundTimerNotifier, RoundTimerState>(RoundTimerNotifier.new);

class RoundTimerNotifier extends Notifier<RoundTimerState> {
  Timer? _ticker;
  DateTime? _targetEndTime;
  bool _expiryAlertPlayed = false;

  @override
  RoundTimerState build() {
    ref.onDispose(() {
      _ticker?.cancel();
      _ticker = null;
    });
    return const RoundTimerState(
      durationSeconds: RoundTimerState.defaultPresetMinutes * 60,
      isRunning: false,
      isOvertime: false,
      overtimeSeconds: 0,
      presetMinutes: RoundTimerState.defaultPresetMinutes,
    );
  }

  void startTimer({int? minutes}) {
    final preset = (minutes ?? state.presetMinutes).clamp(1, 180);
    _expiryAlertPlayed = false;
    _targetEndTime = DateTime.now().add(Duration(minutes: preset));
    state = RoundTimerState(
      durationSeconds: preset * 60,
      isRunning: true,
      isOvertime: false,
      overtimeSeconds: 0,
      presetMinutes: preset,
    );
    _ensureTicker();
    _syncFromTimestamp();
  }

  void pauseTimer() {
    if (!state.isRunning) return;
    _syncFromTimestamp();
    _ticker?.cancel();
    _ticker = null;
    _targetEndTime = null;
    state = state.copyWith(isRunning: false);
  }

  void resumeTimer() {
    if (state.isRunning) return;
    if (!state.isOvertime && state.durationSeconds <= 0) {
      startTimer();
      return;
    }
    final now = DateTime.now();
    if (state.isOvertime) {
      _targetEndTime = now.subtract(Duration(seconds: state.overtimeSeconds));
    } else {
      final remaining = state.durationSeconds <= 0 ? 0 : state.durationSeconds;
      _targetEndTime = now.add(Duration(seconds: remaining));
    }
    state = state.copyWith(isRunning: true);
    _ensureTicker();
    _syncFromTimestamp();
  }

  void resetTimer({int? minutes}) {
    final preset = (minutes ?? state.presetMinutes).clamp(1, 180);
    _ticker?.cancel();
    _ticker = null;
    _targetEndTime = null;
    _expiryAlertPlayed = false;
    state = RoundTimerState(
      durationSeconds: preset * 60,
      isRunning: false,
      isOvertime: false,
      overtimeSeconds: 0,
      presetMinutes: preset,
    );
  }

  void addMinutes(int minutes) {
    if (minutes == 0) return;
    final extra = Duration(minutes: minutes);
    if (_targetEndTime != null) {
      _targetEndTime = _targetEndTime!.add(extra);
    } else if (state.isOvertime) {
      final leftover = minutes * 60 - state.overtimeSeconds;
      if (leftover > 0) {
        _expiryAlertPlayed = false;
        state = state.copyWith(
          isOvertime: false,
          overtimeSeconds: 0,
          durationSeconds: leftover,
        );
      } else {
        state = state.copyWith(overtimeSeconds: -leftover);
      }
      return;
    } else {
      state = state.copyWith(durationSeconds: state.durationSeconds + minutes * 60);
      return;
    }
    _syncFromTimestamp();
  }

  void _ensureTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      _syncFromTimestamp();
    });
  }

  void _syncFromTimestamp() {
    final target = _targetEndTime;
    if (target == null) return;

    final now = DateTime.now();
    final remaining = target.difference(now).inSeconds;
    if (remaining > 0) {
      _expiryAlertPlayed = false;
      state = state.copyWith(
        durationSeconds: remaining,
        isOvertime: false,
        overtimeSeconds: 0,
      );
      return;
    }

    final justExpired = !state.isOvertime;
    if (justExpired) {
      _playExpiryAlert();
    }
    state = state.copyWith(
      durationSeconds: 0,
      isOvertime: true,
      overtimeSeconds: now.difference(target).inSeconds,
    );
  }

  void _playExpiryAlert() {
    if (_expiryAlertPlayed) return;
    _expiryAlertPlayed = true;
    final prefs = ref.read(appPreferencesProvider);
    try {
      if (prefs.timerVibrationEnabled) {
        HapticFeedback.heavyImpact();
        HapticFeedback.vibrate();
      }
      if (prefs.timerSoundEnabled) {
        SystemSound.play(SystemSoundType.alert);
      }
    } catch (_) {}
  }
}
