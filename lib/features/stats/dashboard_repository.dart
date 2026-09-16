import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/supabase_constants.dart';
import '../matches/match_model.dart';
import '../settings/app_preferences_service.dart';

enum DashboardTimeRange {
  week,
  month,
  season,
  year,
  allTime;

  String get label {
    switch (this) {
      case DashboardTimeRange.week:
        return 'Woche';
      case DashboardTimeRange.month:
        return 'Monat';
      case DashboardTimeRange.season:
        return 'Saison';
      case DashboardTimeRange.year:
        return 'Jahr';
      case DashboardTimeRange.allTime:
        return 'Gesamt';
    }
  }

  DateTime? cutoffDate([DateTime? now]) {
    final current = now ?? DateTime.now();
    switch (this) {
      case DashboardTimeRange.week:
        return current.subtract(const Duration(days: 7));
      case DashboardTimeRange.month:
        return current.subtract(const Duration(days: 30));
      case DashboardTimeRange.season:
        return current.subtract(const Duration(days: 90));
      case DashboardTimeRange.year:
        return current.subtract(const Duration(days: 365));
      case DashboardTimeRange.allTime:
        return null;
    }
  }

  static DashboardTimeRange fromStorage(String? value) {
    return DashboardTimeRange.values.firstWhere(
      (range) => range.name == value,
      orElse: () => DashboardTimeRange.month,
    );
  }
}

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

class OpponentMatchup {
  final String opponentDeck;
  final int wins;
  final int losses;
  final int total;

  OpponentMatchup({
    required this.opponentDeck,
    required this.wins,
    required this.losses,
    required this.total,
  });

  double get winRate => total > 0 ? (wins / total) * 100 : 0.0;

  double get lossRate => total > 0 ? (losses / total) * 100 : 0.0;
}

class DashboardData {
  final int totalMatches;
  final int totalWins;
  final int unfilteredTotal;
  final List<GameSummary> gameSummaries;
  final List<MatchRecord> recentMatches;
  final OpponentMatchup? bestMatchup;
  final OpponentMatchup? nemesisMatchup;
  final DashboardTimeRange timeRange;

  DashboardData({
    required this.totalMatches,
    required this.totalWins,
    required this.unfilteredTotal,
    required this.gameSummaries,
    required this.recentMatches,
    required this.timeRange,
    this.bestMatchup,
    this.nemesisMatchup,
  });

  double get overallWinRate => totalMatches > 0 ? (totalWins / totalMatches) * 100 : 0.0;
}

final dashboardDataProvider = FutureProvider<DashboardData>((ref) async {
  final prefs = ref.watch(appPreferencesProvider);
  final timeRange = DashboardTimeRange.fromStorage(prefs.dashboardTimeRange);
  final focusGameId = prefs.resolvedDashboardGameId;
  final hiddenIds = prefs.hiddenGameIds;
  final user = supabase.auth.currentUser;
  if (user == null) {
    return DashboardData(
      totalMatches: 0,
      totalWins: 0,
      unfilteredTotal: 0,
      gameSummaries: [],
      recentMatches: [],
      timeRange: timeRange,
    );
  }

  final response = await supabase
      .from('matches')
      .select('*, decks(name, game_id, games(id, name))')
      .order('created_at', ascending: false);

  final List rawList = response as List;
  final cutoff = timeRange.cutoffDate();

  String? gameIdOf(Map raw) {
    return raw['decks']?['game_id'] as String? ?? raw['decks']?['games']?['id'] as String?;
  }

  final filteredRaw = rawList.where((raw) {
    if (raw is! Map) return false;
    final map = Map<String, dynamic>.from(raw);
    final gameId = gameIdOf(map);
    if (gameId != null && hiddenIds.contains(gameId)) return false;
    if (focusGameId != null && gameId != focusGameId) return false;
    if (cutoff != null) {
      final createdAt = DateTime.tryParse(map['created_at']?.toString() ?? '');
      if (createdAt == null || createdAt.isBefore(cutoff)) return false;
    }
    return true;
  }).toList();

  final matches = filteredRaw.map((m) => MatchRecord.fromJson(Map<String, dynamic>.from(m as Map))).toList();
  final totalWins = matches.where((m) => m.result == 'win').length;

  final byGame = <String, List<Map<String, dynamic>>>{};
  for (final raw in filteredRaw) {
    final map = Map<String, dynamic>.from(raw as Map);
    final gameName = map['decks']?['games']?['name'] as String? ?? 'Unbekannt';
    byGame.putIfAbsent(gameName, () => []).add(map);
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

  final byOpponent = <String, List<MatchRecord>>{};
  for (final match in matches) {
    final name = match.opponentDeck.trim();
    if (name.isEmpty) continue;
    byOpponent.putIfAbsent(name, () => []).add(match);
  }

  final matchups = byOpponent.entries
      .map((entry) {
        final list = entry.value;
        return OpponentMatchup(
          opponentDeck: entry.key,
          wins: list.where((m) => m.result == 'win').length,
          losses: list.where((m) => m.result == 'loss').length,
          total: list.length,
        );
      })
      .where((matchup) => matchup.total >= 2)
      .toList();

  OpponentMatchup? bestMatchup;
  OpponentMatchup? nemesisMatchup;
  if (matchups.isNotEmpty) {
    final byWinRate = [...matchups]..sort((a, b) {
        final wr = b.winRate.compareTo(a.winRate);
        if (wr != 0) return wr;
        return b.total.compareTo(a.total);
      });
    final best = byWinRate.first;

    final byLossRate = [...matchups]..sort((a, b) {
        final wr = a.winRate.compareTo(b.winRate);
        if (wr != 0) return wr;
        return b.losses.compareTo(a.losses);
      });
    var nemesis = byLossRate.first;

    if (matchups.length > 1 && nemesis.opponentDeck == best.opponentDeck) {
      nemesis = byLossRate.firstWhere(
        (matchup) => matchup.opponentDeck != best.opponentDeck,
        orElse: () => byLossRate.last,
      );
    }

    bestMatchup = best;
    nemesisMatchup = nemesis;
  }

  return DashboardData(
    totalMatches: matches.length,
    totalWins: totalWins,
    unfilteredTotal: rawList.where((raw) {
      if (raw is! Map) return false;
      final gameId = gameIdOf(Map<String, dynamic>.from(raw));
      return gameId == null || !hiddenIds.contains(gameId);
    }).length,
    gameSummaries: summaries,
    recentMatches: matches.take(5).toList(),
    bestMatchup: bestMatchup,
    nemesisMatchup: nemesisMatchup,
    timeRange: timeRange,
  );
});
