import 'package:flutter/material.dart';

class TcgColors {
  TcgColors._();

  static const Map<String, Color> _knownGames = {
    'yu-gi-oh!': Color(0xFF8E24AA),
    'yu-gi-oh': Color(0xFF8E24AA),
    'yugioh': Color(0xFF8E24AA),
    'pokémon': Color(0xFFE53935),
    'pokemon': Color(0xFFE53935),
    'magic: the gathering': Color(0xFFFFB300),
    'magic': Color(0xFFFFB300),
    'mtg': Color(0xFFFFB300),
    'one piece': Color(0xFF1E88E5),
    'lorcana': Color(0xFF7E57C2),
    'flesh and blood': Color(0xFFC62828),
    'digimon': Color(0xFF00897B),
    'star wars: unlimited': Color(0xFF3949AB),
    'star wars': Color(0xFF3949AB),
    'dragon ball': Color(0xFFFB8C00),
    'weiss schwarz': Color(0xFF546E7A),
    'union arena': Color(0xFF00838F),
  };

  static Color forGame(String? name) {
    final key = (name ?? '').trim().toLowerCase();
    if (key.isEmpty) return Colors.deepPurple;

    final exact = _knownGames[key];
    if (exact != null) return exact;

    for (final entry in _knownGames.entries) {
      if (key.startsWith(entry.key) || entry.key.startsWith(key)) {
        return entry.value;
      }
    }

    final hash = key.codeUnits.fold<int>(0, (sum, unit) => sum + unit);
    return HSVColor.fromAHSV(1, (hash % 360).toDouble(), 0.55, 0.78).toColor();
  }

  static String initials(String? name) {
    if (name == null || name.trim().isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  static Color winRateColor(double winRate, int totalMatches) {
    if (totalMatches == 0) return Colors.blueGrey;
    if (winRate >= 55) return Colors.greenAccent;
    if (winRate >= 45) return Colors.amber;
    return Colors.redAccent;
  }
}
