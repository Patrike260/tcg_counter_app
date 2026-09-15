import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/supabase_constants.dart';
import 'match_model.dart';

final matchRepositoryProvider = Provider<MatchRepository>((ref) {
  return MatchRepository(supabase);
});

// Liefert alle Matches für ein bestimmtes Deck
final deckMatchesProvider = FutureProvider.family<List<MatchRecord>, String>((ref, deckId) async {
  final repo = ref.watch(matchRepositoryProvider);
  return repo.fetchMatchesForDeck(deckId);
});

// Liefert Archetypen für Auto-Suggest
final archetypesProvider = FutureProvider.family<List<String>, String>((ref, gameId) async {
  final repo = ref.watch(matchRepositoryProvider);
  return repo.fetchArchetypes(gameId);
});

class MatchRepository {
  final SupabaseClient _client;

  MatchRepository(this._client);

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
}