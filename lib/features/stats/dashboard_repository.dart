import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/supabase_constants.dart';
import '../matches/match_model.dart';

class GameSummary {
  final String gameName;
  final int totalMatches;
  final int wins;

  GameSummary({
    required this.gameName,
    required this.totalMatches,
    required this.wins,
  });

  double get winRate => totalMatches > 0 ? (wins / totalMatches) * 100 : 0.0;
}

class DashboardData {
  final int totalMatches;
  final int totalWins;
  final List<GameSummary> gameSummaries;
  final List<MatchRecord> recentMatches;

  DashboardData({
    required this.totalMatches,
    required this.totalWins,
    required this.gameSummaries,
    required this.recentMatches,
  });

  double get overallWinRate => totalMatches > 0 ? (totalWins / totalMatches) * 100 : 0.0;
}

final dashboardDataProvider = FutureProvider<DashboardData>((ref) async {
  final user = supabase.auth.currentUser;
  if (user == null) {
    return DashboardData(totalMatches: 0, totalWins: 0, gameSummaries: [], recentMatches: []);
  }

  // Alle Matches mit Deck- und Spiel-Infos laden
  final response = await supabase
      .from('matches')
      .select('*, decks(name, games(name))')
      .order('created_at', ascending: false);

  final List rawList = response as List;
  final List<MatchRecord> matches = rawList.map((m) => MatchRecord.fromJson(m)).toList();

  int totalWins = matches.where((m) => m.result == 'win').length;

  // Nach Spiel gruppieren
  final Map<String, List<Map<String, dynamic>>> byGame = {};
  for (var raw in rawList) {
    final gameName = raw['decks']?['games']?['name'] as String? ?? 'Unbekannt';
    byGame.putIfAbsent(gameName, () => []).add(raw);
  }

  final summaries = byGame.entries.map((entry) {
    final gameMatches = entry.value;
    final wins = gameMatches.where((m) => m['result'] == 'win').length;
    return GameSummary(
      gameName: entry.key,
      totalMatches: gameMatches.length,
      wins: wins,
    );
  }).toList()
    ..sort((a, b) => b.totalMatches.compareTo(a.totalMatches));

  return DashboardData(
    totalMatches: matches.length,
    totalWins: totalWins,
    gameSummaries: summaries,
    recentMatches: matches.take(5).toList(),
  );
});