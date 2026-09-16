import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/supabase_constants.dart';
import 'match_model.dart';

class DeckMatchSummary {
  final int totalMatches;
  final int wins;

  const DeckMatchSummary({this.totalMatches = 0, this.wins = 0});

  double get winRate => totalMatches > 0 ? (wins / totalMatches) * 100 : 0.0;
}

final matchRepositoryProvider = Provider<MatchRepository>((ref) {
  return MatchRepository(supabase);
});

// Liefert alle Matches für ein bestimmtes Deck
final deckMatchesProvider = FutureProvider.family<List<MatchRecord>, String>((ref, deckId) async {
  final repo = ref.watch(matchRepositoryProvider);
  return repo.fetchMatchesForDeck(deckId);
});

// Winrate und Match-Anzahl je Deck (eine Query für die Deck-Liste)
final deckMatchSummariesProvider = FutureProvider<Map<String, DeckMatchSummary>>((ref) async {
  final repo = ref.watch(matchRepositoryProvider);
  return repo.fetchDeckMatchSummaries();
});

// Liefert Archetypen für Auto-Suggest
final archetypesProvider = FutureProvider.family<List<String>, String>((ref, gameId) async {
  final repo = ref.watch(matchRepositoryProvider);
  return repo.fetchArchetypes(gameId);
});

class MatchRepository {
  final SupabaseClient _client;

  MatchRepository(this._client);

  Future<Map<String, DeckMatchSummary>> fetchDeckMatchSummaries() async {
    final user = _client.auth.currentUser;
    if (user == null) return {};

    final response = await _client.from('matches').select('deck_id, result');
    final totals = <String, int>{};
    final wins = <String, int>{};

    for (final row in response as List) {
      final deckId = row['deck_id'] as String;
      totals[deckId] = (totals[deckId] ?? 0) + 1;
      if (row['result'] == 'win') {
        wins[deckId] = (wins[deckId] ?? 0) + 1;
      }
    }

    return {
      for (final id in totals.keys)
        id: DeckMatchSummary(
          totalMatches: totals[id]!,
          wins: wins[id] ?? 0,
        ),
    };
  }

  // Matches eines Decks abfragen
  Future<List<MatchRecord>> fetchMatchesForDeck(String deckId) async {
    final response = await _client
        .from('matches')
        .select()
        .eq('deck_id', deckId)
        .order('created_at', ascending: false);

    return (response as List).map((json) => MatchRecord.fromJson(json)).toList();
  }

  // Bereits bekannte gegnerische Decks (Archetypen) vorschlagen
  Future<List<String>> fetchArchetypes(String gameId) async {
    final response = await _client
        .from('archetypes')
        .select('name')
        .eq('game_id', gameId)
        .order('name');

    return (response as List).map((item) => item['name'] as String).toList();
  }

  // Neues Match eintragen
  Future<void> addMatch({
    required String deckId,
    required String opponentDeck,
    required String result,
    required String matchFormat,
    String? score,
    String? turnOrder,
    List<String> tags = const [],
    String? notes,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Kein Nutzer eingeloggt');

    await _client.from('matches').insert({
      'user_id': user.id,
      'deck_id': deckId,
      'opponent_deck': opponentDeck,
      'result': result,
      'match_format': matchFormat,
      'score': score,
      'turn_order': turnOrder,
      'tags': tags,
      'notes': notes,
    });
  }
  // Match aktualisieren
  Future<void> updateMatch({
    required String matchId,
    required String opponentDeck,
    required String result,
    required String matchFormat,
    String? score,
    String? turnOrder,
    List<String> tags = const [],
    String? notes,
  }) async {
    await _client.from('matches').update({
      'opponent_deck': opponentDeck,
      'result': result,
      'match_format': matchFormat,
      'score': score,
      'turn_order': turnOrder,
      'tags': tags,
      'notes': notes,
    }).eq('id', matchId);
  }

  // Match löschen
  Future<void> deleteMatch(String matchId) async {
    await _client.from('matches').delete().eq('id', matchId);
  }
}