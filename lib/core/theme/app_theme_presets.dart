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
  dragonBallCell,
  cyberpunkNeonOverdrive,
  paperManga,
  vaporwave80s,
}

class AppThemeSwatch {
  final Brightness brightness;
  final Color primaryColor;
  final Color secondaryColor;
  final Color tertiaryColor;
  final Color scaffoldBackgroundColor;
  final Color surfaceColor;
  final Color textColor;
  final Color? cardBorderColor;

  const AppThemeSwatch({
    required this.brightness,
    required this.primaryColor,
    required this.secondaryColor,
    required this.tertiaryColor,
    required this.scaffoldBackgroundColor,
    required this.surfaceColor,
    required this.textColor,
    this.cardBorderColor,
  });

  bool get isLight => brightness == Brightness.light;

  Color get cardColor => surfaceColor;

  List<Color> get previewAccents {
    final accents = <Color>[primaryColor, secondaryColor];
    if (tertiaryColor != primaryColor && tertiaryColor != secondaryColor) {
      accents.add(tertiaryColor);
    }
    return accents;
  }
}

extension AppThemePresetX on AppThemePreset {
  AppThemeSwatch get palette {
    switch (this) {
      case AppThemePreset.onePiece:
        return const AppThemeSwatch(
          brightness: Brightness.light,
          primaryColor: Color(0xFFD32F2F),
          secondaryColor: Color(0xFFF9A825),
          tertiaryColor: Color(0xFF1565C0),
          scaffoldBackgroundColor: Color(0xFFF4EBD9),
          surfaceColor: Color(0xFFFFFFF8),
          textColor: Color(0xFF1C1C1E),
        );
      case AppThemePreset.gundam:
        return const AppThemeSwatch(
          brightness: Brightness.light,
          primaryColor: Color(0xFF00838F),
          secondaryColor: Color(0xFFC62828),
          tertiaryColor: Color(0xFF37474F),
          scaffoldBackgroundColor: Color(0xFFE8ECEF),
          surfaceColor: Color(0xFFFFFFFF),
          textColor: Color(0xFF1C1C1E),
        );
      case AppThemePreset.dragonBall:
        return const AppThemeSwatch(
          brightness: Brightness.light,
          primaryColor: Color(0xFFEF6C00),
          secondaryColor: Color(0xFF1565C0),
          tertiaryColor: Color(0xFFFFC107),
          scaffoldBackgroundColor: Color(0xFFFFF4E5),
          surfaceColor: Color(0xFFFFFFFF),
          textColor: Color(0xFF1C1C1E),
        );
      case AppThemePreset.magic:
        return const AppThemeSwatch(
          brightness: Brightness.dark,
          primaryColor: Color(0xFFB388FF),
          secondaryColor: Color(0xFFFFC107),
          tertiaryColor: Color(0xFF80CBC4),
          scaffoldBackgroundColor: Color(0xFF151324),
          surfaceColor: Color(0xFF221C38),
          textColor: Color(0xFFF3EEFF),
        );
      case AppThemePreset.cyberpunk:
        return const AppThemeSwatch(
          brightness: Brightness.dark,
          primaryColor: Color(0xFF00E5FF),
          secondaryColor: Color(0xFFFF007F),
          tertiaryColor: Color(0xFFE040FB),
          scaffoldBackgroundColor: Color(0xFF050508),
          surfaceColor: Color(0xFF12121A),
          textColor: Color(0xFFE8FBFF),
        );
      case AppThemePreset.weissSchwarz:
        return const AppThemeSwatch(
          brightness: Brightness.light,
          primaryColor: Color(0xFFC2185B),
          secondaryColor: Color(0xFF455A64),
          tertiaryColor: Color(0xFF7E57C2),
          scaffoldBackgroundColor: Color(0xFFF5F7FB),
          surfaceColor: Color(0xFFFFFFFF),
          textColor: Color(0xFF1C1C1E),
        );
      case AppThemePreset.yugioh:
        return const AppThemeSwatch(
          brightness: Brightness.dark,
          primaryColor: Color(0xFFFFC107),
          secondaryColor: Color(0xFFCE93D8),
          tertiaryColor: Color(0xFFFF8A65),
          scaffoldBackgroundColor: Color(0xFF141118),
          surfaceColor: Color(0xFF221C28),
          textColor: Color(0xFFFFF8E7),
        );
      case AppThemePreset.riftbound:
        return const AppThemeSwatch(
          brightness: Brightness.dark,
          primaryColor: Color(0xFF8C9EFF),
          secondaryColor: Color(0xFF00E5FF),
          tertiaryColor: Color(0xFF69F0AE),
          scaffoldBackgroundColor: Color(0xFF0A0E1A),
          surfaceColor: Color(0xFF121A2E),
          textColor: Color(0xFFE8EEFF),
        );
      case AppThemePreset.digimon:
        return const AppThemeSwatch(
          brightness: Brightness.light,
          primaryColor: Color(0xFF1565C0),
          secondaryColor: Color(0xFFEF6C00),
          tertiaryColor: Color(0xFF00897B),
          scaffoldBackgroundColor: Color(0xFFEAF3FF),
          surfaceColor: Color(0xFFFFFFFF),
          textColor: Color(0xFF1C1C1E),
        );
      case AppThemePreset.fleshAndBlood:
        return const AppThemeSwatch(
          brightness: Brightness.dark,
          primaryColor: Color(0xFFE53935),
          secondaryColor: Color(0xFFD7CCC8),
          tertiaryColor: Color(0xFFFF8A80),
          scaffoldBackgroundColor: Color(0xFF141010),
          surfaceColor: Color(0xFF221818),
          textColor: Color(0xFFF5EDED),
        );
      case AppThemePreset.dragonBallCell:
        return const AppThemeSwatch(
          brightness: Brightness.dark,
          primaryColor: Color(0xFF00E676),
          secondaryColor: Color(0xFFAA00FF),
          tertiaryColor: Color(0xFF76FF03),
          scaffoldBackgroundColor: Color(0xFF09130D),
          surfaceColor: Color(0xFF132418),
          textColor: Color(0xFFE8FFE9),
        );
      case AppThemePreset.cyberpunkNeonOverdrive:
        return const AppThemeSwatch(
          brightness: Brightness.dark,
          primaryColor: Color(0xFFFF007F),
          secondaryColor: Color(0xFFFFE600),
          tertiaryColor: Color(0xFF00E5FF),
          scaffoldBackgroundColor: Color(0xFF0C0614),
          surfaceColor: Color(0xFF1A0F26),
          textColor: Color(0xFFFFF3FA),
        );
      case AppThemePreset.paperManga:
        return const AppThemeSwatch(
          brightness: Brightness.light,
          primaryColor: Color(0xFF1A1A1A),
          secondaryColor: Color(0xFFD32F2F),
          tertiaryColor: Color(0xFF2A2A2A),
          scaffoldBackgroundColor: Color(0xFFF7EEDD),
          surfaceColor: Color(0xFFFFFFFF),
          textColor: Color(0xFF1A1A1A),
          cardBorderColor: Color(0xFF2A2A2A),
        );
      case AppThemePreset.vaporwave80s:
        return const AppThemeSwatch(
          brightness: Brightness.dark,
          primaryColor: Color(0xFFFF71CE),
          secondaryColor: Color(0xFF01CDFE),
          tertiaryColor: Color(0xFFB967FF),
          scaffoldBackgroundColor: Color(0xFF0B0E23),
          surfaceColor: Color(0xFF1A1636),
          textColor: Color(0xFFFFE6F8),
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
    case AppThemePreset.dragonBallCell:
      return 'Dragon Ball: Perfect Cell';
    case AppThemePreset.cyberpunkNeonOverdrive:
      return 'Cyberpunk: Neon Overdrive';
    case AppThemePreset.paperManga:
      return 'Paper Manga (Light)';
    case AppThemePreset.vaporwave80s:
      return 'Miami Vaporwave';
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
  final isLight = palette.brightness == Brightness.light;
  final isPaperManga = preset == AppThemePreset.paperManga;
  final primary = palette.primaryColor;
  final secondary = palette.secondaryColor;
  final tertiary = palette.tertiaryColor;
  final scaffoldBackground = palette.scaffoldBackgroundColor;
  final surface = palette.surfaceColor;
  final textColor = palette.textColor;
  final onPrimary = _onColor(primary);
  final onSecondary = _onColor(secondary);
  final onTertiary = _onColor(tertiary);
  final mutedText = textColor.withValues(alpha: isLight ? 0.64 : 0.72);
  final iconColor = isPaperManga ? textColor : primary;

  final colorScheme = isLight
      ? ColorScheme.light(
          primary: primary,
          onPrimary: onPrimary,
          secondary: secondary,
          onSecondary: onSecondary,
          tertiary: tertiary,
          onTertiary: onTertiary,
          surface: surface,
          onSurface: textColor,
          error: const Color(0xFFC62828),
          onError: Colors.white,
        )
      : ColorScheme.dark(
          primary: primary,
          onPrimary: onPrimary,
          secondary: secondary,
          onSecondary: onSecondary,
          tertiary: tertiary,
          onTertiary: onTertiary,
          surface: surface,
          onSurface: textColor,
          error: const Color(0xFFFF5252),
          onError: Colors.white,
        );

  final cardBorder = palette.cardBorderColor != null
      ? BorderSide(color: palette.cardBorderColor!, width: isPaperManga ? 1.4 : 1)
      : (isLight
          ? BorderSide(color: Colors.black.withValues(alpha: 0.08))
          : BorderSide.none);

  final cardShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(isPaperManga ? 8 : 16),
    side: cardBorder,
  );

  final textTheme = (isLight ? ThemeData.light() : ThemeData.dark()).textTheme.apply(
    bodyColor: textColor,
    displayColor: textColor,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: palette.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme,
    applyElevationOverlayColor: false,
    scaffoldBackgroundColor: scaffoldBackground,
    canvasColor: scaffoldBackground,
    cardColor: surface,
    dividerColor: textColor.withValues(alpha: 0.12),
    iconTheme: IconThemeData(color: isPaperManga ? textColor : textColor.withValues(alpha: 0.86)),
    cardTheme: CardThemeData(
      color: surface,
      elevation: isPaperManga ? 0 : (isLight ? 1 : 2),
      shadowColor: Colors.black.withValues(alpha: isLight ? 0.12 : 0.45),
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
      foregroundColor: textColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: iconColor),
      actionsIconTheme: IconThemeData(color: iconColor),
      titleTextStyle: TextStyle(
        color: textColor,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: surface,
      indicatorColor: primary.withValues(alpha: isPaperManga ? 0.12 : 0.22),
      surfaceTintColor: Colors.transparent,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(
          color: selected ? (isPaperManga ? textColor : primary) : mutedText,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          fontSize: 12,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
          color: selected ? (isPaperManga ? textColor : primary) : mutedText,
        );
      }),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: isPaperManga ? textColor : primary,
      textColor: textColor,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: isLight
          ? Colors.black.withValues(alpha: 0.04)
          : Colors.white.withValues(alpha: 0.08),
      selectedColor: primary.withValues(alpha: 0.18),
      labelStyle: TextStyle(color: textColor),
      side: BorderSide(
        color: isPaperManga ? textColor : primary.withValues(alpha: 0.28),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: isLight ? Colors.white : surface,
      hintStyle: TextStyle(color: mutedText),
      labelStyle: TextStyle(color: mutedText),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: isPaperManga ? textColor : primary,
      foregroundColor: isPaperManga ? Colors.white : onPrimary,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: isPaperManga ? textColor : primary,
        foregroundColor: isPaperManga ? Colors.white : onPrimary,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: isLight ? const Color(0xFF2C2C2E) : surface,
      contentTextStyle: TextStyle(color: isLight ? Colors.white : textColor),
    ),
  );
}
