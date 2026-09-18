import 'package:flutter/material.dart';

class AppThemeKeys {
  static const cyberpunk = 'cyberpunk';
  static const paper = 'paper';
  static const crimson = 'crimson';
  static const cell = 'cell';

  static const all = <String>[cyberpunk, paper, crimson, cell];

  static String normalize(String? raw) {
    if (raw != null && all.contains(raw)) return raw;
    return cyberpunk;
  }
}

class _PresetColors {
  final Color primary;
  final Color secondary;
  final Color tertiary;
  final Color lightScaffold;
  final Color lightSurface;
  final Color darkScaffold;
  final Color darkSurface;

  const _PresetColors({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.lightScaffold,
    required this.lightSurface,
    required this.darkScaffold,
    required this.darkSurface,
  });
}

class AppThemes {
  static const _palettes = <String, _PresetColors>{
    AppThemeKeys.cyberpunk: _PresetColors(
      primary: Color(0xFF00E5FF),
      secondary: Color(0xFFB388FF),
      tertiary: Color(0xFFFF4081),
      lightScaffold: Color(0xFFEEF7FA),
      lightSurface: Color(0xFFFFFFFF),
      darkScaffold: Color(0xFF12131C),
      darkSurface: Color(0xFF1A1C28),
    ),
    AppThemeKeys.paper: _PresetColors(
      primary: Color(0xFF1A1A1A),
      secondary: Color(0xFF455A64),
      tertiary: Color(0xFFD32F2F),
      lightScaffold: Color(0xFFF7F7F8),
      lightSurface: Color(0xFFFFFFFF),
      darkScaffold: Color(0xFF161616),
      darkSurface: Color(0xFF222222),
    ),
    AppThemeKeys.crimson: _PresetColors(
      primary: Color(0xFFC2185B),
      secondary: Color(0xFFD4A017),
      tertiary: Color(0xFF880E4F),
      lightScaffold: Color(0xFFFBF4F7),
      lightSurface: Color(0xFFFFFFFF),
      darkScaffold: Color(0xFF1A0A12),
      darkSurface: Color(0xFF2A121C),
    ),
    AppThemeKeys.cell: _PresetColors(
      primary: Color(0xFF00E676),
      secondary: Color(0xFFAA00FF),
      tertiary: Color(0xFF69F0AE),
      lightScaffold: Color(0xFFEFF8F1),
      lightSurface: Color(0xFFFFFFFF),
      darkScaffold: Color(0xFF1B2B1B),
      darkSurface: Color(0xFF243624),
    ),
  };

  static ThemeData buildLightTheme(String preset) {
    return _build(AppThemeKeys.normalize(preset), Brightness.light);
  }

  static ThemeData buildDarkTheme(String preset) {
    return _build(AppThemeKeys.normalize(preset), Brightness.dark);
  }

  static _PresetColors _colors(String preset) {
    return _palettes[AppThemeKeys.normalize(preset)]!;
  }

  static ThemeData _build(String preset, Brightness brightness) {
    final colors = _colors(preset);
    final isDark = brightness == Brightness.dark;
    final scaffold = isDark ? colors.darkScaffold : colors.lightScaffold;
    final surface = isDark ? colors.darkSurface : colors.lightSurface;
    final onSurface = isDark ? const Color(0xFFF2F2F2) : const Color(0xFF1A1A1A);
    final onPrimary = _onColor(colors.primary);

    final scheme = ColorScheme(
      brightness: brightness,
      primary: colors.primary,
      onPrimary: onPrimary,
      secondary: colors.secondary,
      onSecondary: _onColor(colors.secondary),
      tertiary: colors.tertiary,
      onTertiary: _onColor(colors.tertiary),
      error: const Color(0xFFD32F2F),
      onError: Colors.white,
      surface: surface,
      onSurface: onSurface,
      onSurfaceVariant: isDark ? const Color(0xFFB0B8C4) : const Color(0xFF4A4A4A),
      outline: isDark ? const Color(0xFF4A5160) : const Color(0xFFC5C5C8),
    );

    final textTheme = ThemeData(brightness: brightness).textTheme.apply(
          bodyColor: onSurface,
          displayColor: onSurface,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffold,
      canvasColor: surface,
      textTheme: textTheme,
      iconTheme: IconThemeData(color: onSurface),
      appBarTheme: AppBarTheme(
        backgroundColor: scaffold,
        foregroundColor: onSurface,
        elevation: 0,
        iconTheme: IconThemeData(color: onSurface),
        titleTextStyle: TextStyle(
          color: onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: colors.primary.withValues(alpha: 0.22),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(color: selected ? colors.primary : onSurface);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontWeight: FontWeight.w600,
            color: selected ? colors.primary : onSurface,
          );
        }),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: onPrimary,
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return onPrimary;
            return onSurface;
          }),
        ),
      ),
    );
  }

  static Color _onColor(Color color) {
    return ThemeData.estimateBrightnessForColor(color) == Brightness.dark
        ? Colors.white
        : const Color(0xFF121212);
  }
}

ThemeMode parseThemeMode(String? raw) {
  switch (raw) {
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    default:
      return ThemeMode.system;
  }
}

String themeModeStorage(ThemeMode mode) {
  switch (mode) {
    case ThemeMode.light:
      return 'light';
    case ThemeMode.dark:
      return 'dark';
    case ThemeMode.system:
      return 'system';
  }
}
