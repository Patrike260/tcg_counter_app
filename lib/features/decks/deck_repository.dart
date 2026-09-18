import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/supabase_constants.dart';
import '../settings/app_preferences_service.dart';
import 'deck_model.dart';

final deckRepositoryProvider = Provider<DeckRepository>((ref) {
  return DeckRepository(supabase, ref.watch(sharedPreferencesProvider));
});

final gamesListProvider = FutureProvider<List<Game>>((ref) async {
  final repo = ref.watch(deckRepositoryProvider);
  return repo.fetchGames();
});

final userDecksProvider = FutureProvider<List<Deck>>((ref) async {
  final repo = ref.watch(deckRepositoryProvider);
  return repo.fetchUserDecks();
});

class DeckRepository {
  static const _cacheKey = 'cached_user_decks';

  final SupabaseClient _client;
  final SharedPreferences _prefs;

  DeckRepository(this._client, this._prefs);

  Future<List<Game>> fetchGames() async {
    final response = await _client.from('games').select('id, name').order('name');
    return (response as List).map((json) => Game.fromJson(json)).toList();
  }

  Future<List<Deck>> fetchUserDecks({bool activeOnly = true}) async {
    try {
      var query = _client
          .from('decks')
          .select('id, user_id, game_id, name, notes, is_active, deck_list_url, games(name)');

      if (activeOnly) {
        query = query.eq('is_active', true);
      }

      final response = await query.order('created_at', ascending: false);
      final decks = (response as List)
          .map((json) => Deck.fromJson(Map<String, dynamic>.from(json as Map)))
          .toList();
      if (activeOnly) {
        await _writeCache(decks);
      }
      return decks;
    } catch (error) {
      final cached = _readCache();
      if (cached != null) return cached;
      rethrow;
    }
  }

  Future<void> _writeCache(List<Deck> decks) async {
    final payload = jsonEncode(decks.map((deck) => deck.toJson()).toList());
    await _prefs.setString(_cacheKey, payload);
  }

  List<Deck>? _readCache() {
    final raw = _prefs.getString(_cacheKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return null;
      return decoded
          .whereType<Map>()
          .map((item) => Deck.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> createDeck({
    required String gameId,
    required String name,
    String? notes,
    String? deckListUrl,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Kein Nutzer eingeloggt');

    await _client.from('decks').insert({
      'user_id': user.id,
      'game_id': gameId,
      'name': name,
      'notes': notes,
      'deck_list_url': deckListUrl,
      'is_active': true,
    });
  }

  Future<void> updateDeck({
    required String deckId,
    required String name,
    String? notes,
    String? deckListUrl,
  }) async {
    await _client.from('decks').update({
      'name': name,
      'notes': notes,
      'deck_list_url': deckListUrl,
    }).eq('id', deckId);
  }

  Future<void> archiveDeck(String deckId) async {
    await _client.from('decks').update({
      'is_active': false,
    }).eq('id', deckId);
  }

  Future<void> deleteDeck(String deckId) async {
    await _client.from('decks').delete().eq('id', deckId);
  }
}
