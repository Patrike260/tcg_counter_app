import 'package:flutter/material.dart';

enum AppThemePreset {
  onePiece,
  gundam,
  dragonBall,
  magic,
  cyberpunk,
  weissSchwarz,
  yugioh,
  riftbound,
  digimon,
  fleshAndBlood,
}

class FranchiseThemePalette {
  final Color primaryColor;
  final Color secondaryColor;
  final Color scaffoldBackgroundColor;
  final Color surfaceColor;

  const FranchiseThemePalette({
    required this.primaryColor,
    required this.secondaryColor,
    required this.scaffoldBackgroundColor,
    required this.surfaceColor,
  });

  Color get cardColor => surfaceColor;
}

extension AppThemePresetX on AppThemePreset {
  FranchiseThemePalette get palette {
    switch (this) {
      case AppThemePreset.onePiece:
        return const FranchiseThemePalette(
          primaryColor: Color(0xFFE53935),
          secondaryColor: Color(0xFFFFC107),
          scaffoldBackgroundColor: Color(0xFF0C1420),
          surfaceColor: Color(0xFF162536),
        );
      case AppThemePreset.gundam:
        return const FranchiseThemePalette(
          primaryColor: Color(0xFF00BCD4),
          secondaryColor: Color(0xFFE53935),
          scaffoldBackgroundColor: Color(0xFF12151D),
          surfaceColor: Color(0xFF1B2230),
        );
      case AppThemePreset.dragonBall:
        return const FranchiseThemePalette(
          primaryColor: Color(0xFFFF6D00),
          secondaryColor: Color(0xFF2979FF),
          scaffoldBackgroundColor: Color(0xFF0D1322),
          surfaceColor: Color(0xFF151F36),
        );
      case AppThemePreset.magic:
        return const FranchiseThemePalette(
          primaryColor: Color(0xFF7C4DFF),
          secondaryColor: Color(0xFFFFC107),
          scaffoldBackgroundColor: Color(0xFF151324),
          surfaceColor: Color(0xFF221C38),
        );
      case AppThemePreset.cyberpunk:
        return const FranchiseThemePalette(
          primaryColor: Color(0xFF00E5FF),
          secondaryColor: Color(0xFFFF007F),
          scaffoldBackgroundColor: Color(0xFF050508),
          surfaceColor: Color(0xFF12121A),
        );
      case AppThemePreset.weissSchwarz:
        return const FranchiseThemePalette(
          primaryColor: Color(0xFFECEFF1),
          secondaryColor: Color(0xFFE91E63),
          scaffoldBackgroundColor: Color(0xFF18122B),
          surfaceColor: Color(0xFF261E40),
        );
      case AppThemePreset.yugioh:
        return const FranchiseThemePalette(
          primaryColor: Color(0xFFFFC107),
          secondaryColor: Color(0xFF8E24AA),
          scaffoldBackgroundColor: Color(0xFF141118),
          surfaceColor: Color(0xFF221C28),
        );
      case AppThemePreset.riftbound:
        return const FranchiseThemePalette(
          primaryColor: Color(0xFF3D5AFE),
          secondaryColor: Color(0xFF00E5FF),
          scaffoldBackgroundColor: Color(0xFF0A0E1A),
          surfaceColor: Color(0xFF121A2E),
        );
      case AppThemePreset.digimon:
        return const FranchiseThemePalette(
          primaryColor: Color(0xFF2979FF),
          secondaryColor: Color(0xFFFF9100),
          scaffoldBackgroundColor: Color(0xFF0B1528),
          surfaceColor: Color(0xFF13233F),
        );
      case AppThemePreset.fleshAndBlood:
        return const FranchiseThemePalette(
          primaryColor: Color(0xFFB71C1C),
          secondaryColor: Color(0xFFD7CCC8),
          scaffoldBackgroundColor: Color(0xFF141010),
          surfaceColor: Color(0xFF221818),
        );
    }
  }
}

String getThemeTitle(AppThemePreset preset) {
  switch (preset) {
    case AppThemePreset.onePiece:
      return 'One Piece';
    case AppThemePreset.gundam:
      return 'Gundam';
    case AppThemePreset.dragonBall:
      return 'Dragon Ball';
    case AppThemePreset.magic:
      return 'Magic: The Gathering';
    case AppThemePreset.cyberpunk:
      return 'Cyberpunk';
    case AppThemePreset.weissSchwarz:
      return 'Weiss Schwarz';
    case AppThemePreset.yugioh:
      return 'Yu-Gi-Oh!';
    case AppThemePreset.riftbound:
      return 'Riftbound';
    case AppThemePreset.digimon:
      return 'Digimon';
    case AppThemePreset.fleshAndBlood:
      return 'Flesh and Blood';
  }
}

AppThemePreset parseAppThemePreset(String? raw) {
  for (final preset in AppThemePreset.values) {
    if (preset.name == raw) return preset;
  }
  return AppThemePreset.onePiece;
}

Color _onColor(Color color) {
  return ThemeData.estimateBrightnessForColor(color) == Brightness.dark
      ? Colors.white
      : const Color(0xFF121212);
}

ThemeData buildAppTheme(AppThemePreset preset) {
  final palette = preset.palette;
  final primary = palette.primaryColor;
  final secondary = palette.secondaryColor;
  final scaffoldBackground = palette.scaffoldBackgroundColor;
  final surface = palette.surfaceColor;
  final onPrimary = _onColor(primary);
  final onSecondary = _onColor(secondary);
  final onSurface = Color.lerp(Colors.white, primary, 0.08)!;

  final scheme = ColorScheme.dark(
    primary: primary,
    onPrimary: onPrimary,
    secondary: secondary,
    onSecondary: onSecondary,
    surface: surface,
    onSurface: onSurface,
    error: const Color(0xFFFF5252),
    onError: Colors.white,
  );

  final cardShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: scheme,
    applyElevationOverlayColor: false,
    scaffoldBackgroundColor: scaffoldBackground,
    canvasColor: scaffoldBackground,
    cardColor: surface,
    dividerColor: onSurface.withValues(alpha: 0.12),
    cardTheme: CardThemeData(
      color: surface,
      elevation: 2,
      shadowColor: Colors.black54,
      surfaceTintColor: Colors.transparent,
      shape: cardShape,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: surface,
      surfaceTintColor: Colors.transparent,
      shape: cardShape,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: surface,
      surfaceTintColor: Colors.transparent,
      modalBackgroundColor: surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: scaffoldBackground,
      foregroundColor: onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: primary),
      actionsIconTheme: IconThemeData(color: primary),
      titleTextStyle: TextStyle(
        color: onSurface,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: surface,
      indicatorColor: primary.withValues(alpha: 0.28),
      surfaceTintColor: Colors.transparent,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(
          color: selected ? primary : onSurface.withValues(alpha: 0.7),
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          fontSize: 12,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
          color: selected ? primary : onSurface.withValues(alpha: 0.75),
        );
      }),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: onPrimary,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: onPrimary,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: surface,
      contentTextStyle: TextStyle(color: onSurface),
    ),
  );
}
