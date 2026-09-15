import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/supabase_constants.dart';
import 'deck_model.dart';

final deckRepositoryProvider = Provider<DeckRepository>((ref) {
  return DeckRepository(supabase);
});

// Stream/Future für alle Spiele (MTG, Pokémon, Gundam etc.)
final gamesListProvider = FutureProvider<List<Game>>((ref) async {
  final repo = ref.watch(deckRepositoryProvider);
  return repo.fetchGames();
});

// Stream/Future für die Decks des aktuellen Nutzers
final userDecksProvider = FutureProvider<List<Deck>>((ref) async {
  final repo = ref.watch(deckRepositoryProvider);
  return repo.fetchUserDecks();
});

class DeckRepository {
  final SupabaseClient _client;

  DeckRepository(this._client);

  // Verfügbare Kartenspiele abrufen
  Future<List<Game>> fetchGames() async {
    final response = await _client.from('games').select('id, name').order('name');
    return (response as List).map((json) => Game.fromJson(json)).toList();
  }

  // Decks des Nutzers abrufen inkl. Spielname
  Future<List<Deck>> fetchUserDecks() async {
    final response = await _client
        .from('decks')
        .select('id, user_id, game_id, name, notes, is_active, games(name)')
        .eq('is_active', true)
        .order('created_at', ascending: false);

    return (response as List).map((json) => Deck.fromJson(json)).toList();
  }

  // Neues Deck anlegen
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
}