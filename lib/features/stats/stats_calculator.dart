import '../matches/match_model.dart';

class MatchupStat {
  final String opponentDeck;
  final int wins;
  final int total;

  MatchupStat({
    required this.opponentDeck,
    required this.wins,
    required this.total,
  });

  double get winRate => total > 0 ? (wins / total) * 100 : 0.0;
}

class DeckStats {
  final int totalMatches;
  final int totalWins;
  final int firstMatches;
  final int firstWins;
  final int secondMatches;
  final int secondWins;
  final List<MatchupStat> matchups;

  DeckStats({
    required this.totalMatches,
    required this.totalWins,
    required this.firstMatches,
    required this.firstWins,
    required this.secondMatches,
    required this.secondWins,
    required this.matchups,
  });

  double get overallWinRate => totalMatches > 0 ? (totalWins / totalMatches) * 100 : 0.0;
  double get firstWinRate => firstMatches > 0 ? (firstWins / firstMatches) * 100 : 0.0;
  double get secondWinRate => secondMatches > 0 ? (secondWins / secondMatches) * 100 : 0.0;

  factory DeckStats.fromMatches(List<MatchRecord> matches) {
    int totalMatches = matches.length;
    int totalWins = matches.where((m) => m.result == 'win').length;

    final firstGames = matches.where((m) => m.turnOrder == 'first');
    int firstMatches = firstGames.length;
    int firstWins = firstGames.where((m) => m.result == 'win').length;

    final secondGames = matches.where((m) => m.turnOrder == 'second');
    int secondMatches = secondGames.length;
    int secondWins = secondGames.where((m) => m.result == 'win').length;

    // Archetyp-Gruppierung
    final Map<String, List<MatchRecord>> grouped = {};
    for (var m in matches) {
      grouped.putIfAbsent(m.opponentDeck, () => []).add(m);
    }

    final matchupList = grouped.entries.map((entry) {
      final wins = entry.value.where((m) => m.result == 'win').length;
      return MatchupStat(
        opponentDeck: entry.key,
        wins: wins,
        total: entry.value.length,
      );
    }).toList()
      ..sort((a, b) => b.total.compareTo(a.total)); // Beliebteste Archetypen zuerst

    return DeckStats(
      totalMatches: totalMatches,
      totalWins: totalWins,
      firstMatches: firstMatches,
      firstWins: firstWins,
      secondMatches: secondMatches,
      secondWins: secondWins,
      matchups: matchupList,
    );
  }
}