import 'package:flutter/material.dart';
import '../theme/tcg_colors.dart';

class GameLogo extends StatelessWidget {
  final String? gameName;
  final double size;

  const GameLogo({
    super.key,
    this.gameName,
    this.size = 40.0,
  });

  static const Map<String, String> _assetByKeyword = {
    'one piece': 'assets/games/one_piece.png',
    'pokémon': 'assets/games/pokemon.png',
    'pokemon': 'assets/games/pokemon.png',
    'magic: the gathering': 'assets/games/mtg.png',
    'magic': 'assets/games/mtg.png',
    'mtg': 'assets/games/mtg.png',
    'lorcana': 'assets/games/lorcana.png',
    'star wars': 'assets/games/star_wars.png',
    'yu-gi-oh!': 'assets/games/yugioh.png',
    'yu-gi-oh': 'assets/games/yugioh.png',
    'yugioh': 'assets/games/yugioh.png',
    'gundam': 'assets/games/gundam.png',
    'dragon ball': 'assets/games/dragonball.png',
    'dragonball': 'assets/games/dragonball.png',
  };

  static String? assetPathFor(String? gameName) {
    final key = (gameName ?? '').trim().toLowerCase();
    if (key.isEmpty) return null;

    final exact = _assetByKeyword[key];
    if (exact != null) return exact;

    for (final entry in _assetByKeyword.entries) {
      if (key.contains(entry.key)) return entry.value;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final path = assetPathFor(gameName);
    if (path == null) {
      return _GameLogoFallback(gameName: gameName, size: size);
    }

    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        path,
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return _GameLogoFallback(gameName: gameName, size: size);
        },
      ),
    );
  }
}

class _GameLogoFallback extends StatelessWidget {
  final String? gameName;
  final double size;

  const _GameLogoFallback({
    required this.gameName,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final letter = (gameName == null || gameName!.trim().isEmpty)
        ? '?'
        : gameName!.trim().substring(0, 1).toUpperCase();

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.deepPurple.withValues(alpha: 0.28),
        shape: BoxShape.circle,
      ),
      child: Text(
        letter,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: size * 0.42,
          color: TcgColors.forGame(gameName),
        ),
      ),
    );
  }
}
