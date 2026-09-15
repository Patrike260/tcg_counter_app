import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/supabase_constants.dart';
import 'deck_model.dart';

final deckRepositoryProvider = Provider<DeckRepository>((ref) {
  return DeckRepository(supabase);
});

// Verfügbare Kartenspiele
final gamesListProvider = FutureProvider<List<Game>>((ref) async {
  final repo = ref.watch(deckRepositoryProvider);
  return repo.fetchGames();
});

// Aktive Decks des Nutzers
final userDecksProvider = FutureProvider<List<Deck>>((ref) async {
  final repo = ref.watch(deckRepositoryProvider);
  return repo.fetchUserDecks();
});

class DeckRepository {
  final SupabaseClient _client;

  DeckRepository(this._client);

  // Kartenspiele abrufen
  Future<List<Game>> fetchGames() async {
    final response = await _client.from('games').select('id, name').order('name');
    return (response as List).map((json) => Game.fromJson(json)).toList();
  }

  // Decks des Nutzers abrufen (Standard: nur aktive)
  Future<List<Deck>> fetchUserDecks({bool activeOnly = true}) async {
    var query = _client
        .from('decks')
        .select('id, user_id, game_id, name, notes, is_active, games(name)');

    if (activeOnly) {
      query = query.eq('is_active', true);
    }

    final response = await query.order('created_at', ascending: false);
    return (response as List).map((json) => Deck.fromJson(json)).toList();
  }

  // Neues Deck erstellen
  Future<void> createDeck({
    required String gameId,
    required String name,
    String? notes,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Kein Nutzer eingeloggt');

    await _client.from('decks').insert({
      'user_id': user.id,
      'game_id': gameId,
      'name': name,
      'notes': notes,
      'is_active': true,
    });
  }

  // Deck aktualisieren (Name & Notizen)
  Future<void> updateDeck({
    required String deckId,
    required String name,
    String? notes,
  }) async {
    await _client.from('decks').update({
      'name': name,
      'notes': notes,
    }).eq('id', deckId);
  }

  // Deck archivieren (inaktiv schalten)
  Future<void> archiveDeck(String deckId) async {
    await _client.from('decks').update({
      'is_active': false,
    }).eq('id', deckId);
  }

  // Deck endgültig löschen (kaskadiert zu Matches durch Foreign Key)
  Future<void> deleteDeck(String deckId) async {
    await _client.from('decks').delete().eq('id', deckId);
  }
}