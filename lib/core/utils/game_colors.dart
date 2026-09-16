import 'package:flutter/material.dart';

Color getGameBaseColor(String? gameName, {required Color fallback}) {
  final key = (gameName ?? '').trim().toLowerCase();
  if (key.isEmpty) return fallback;

  if (key.contains('pokémon') || key.contains('pokemon')) return Colors.amber;
  if (key.contains('one piece')) return Colors.redAccent;
  if (key.contains('dragon ball') || key.contains('dragonball')) {
    return Colors.orangeAccent;
  }
  if (key.contains('gundam')) return Colors.cyan;
  if (key.contains('magic') || key.contains('mtg')) return Colors.deepPurpleAccent;
  if (key.contains('lorcana')) return Colors.tealAccent;
  if (key.contains('star wars')) return Colors.lightBlueAccent;
  if (key.contains('yu-gi-oh') || key.contains('yugioh')) return Colors.amber.shade700;

  return fallback;
}

BoxDecoration gameColorWashDecoration(Color baseColor, {double radius = 14}) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    gradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        baseColor.withValues(alpha: 0.22),
        baseColor.withValues(alpha: 0.08),
      ],
    ),
    border: Border.all(
      color: baseColor.withValues(alpha: 0.35),
      width: 1,
    ),
  );
}
