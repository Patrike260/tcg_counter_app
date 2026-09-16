import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/supabase_constants.dart';
import '../matches/match_model.dart';
import 'tournament_model.dart';

final tournamentRepositoryProvider = Provider<TournamentRepository>((ref) {
  return TournamentRepository(supabase);
});

final tournamentsListProvider = FutureProvider<List<Tournament>>((ref) async {
  return ref.watch(tournamentRepositoryProvider).fetchTournaments();
});

final tournamentsStreamProvider = StreamProvider<List<Tournament>>((ref) {
  return ref.watch(tournamentRepositoryProvider).watchTournaments();
});

final tournamentRelatedMatchesProvider =
    FutureProvider.family<List<MatchRecord>, String>((ref, tournamentId) async {
  final tournaments = await ref.watch(tournamentsListProvider.future);
  Tournament? tournament;
  for (final item in tournaments) {
    if (item.id == tournamentId) {
      tournament = item;
      break;
    }
  }
  if (tournament == null) return [];
  return ref.watch(tournamentRepositoryProvider).fetchRelatedMatches(tournament);
});

class TournamentRepository {
  static const _select =
      'id, user_id, game_id, deck_id, name, tournament_date, placement, total_participants, notes, tags, decks(name), games(name)';

  final SupabaseClient _client;

  TournamentRepository(this._client);

  Future<List<Tournament>> fetchTournaments() async {
    final user = _client.auth.currentUser;
    if (user == null) return [];

    final response = await _client
        .from('tournaments')
        .select(_select)
        .eq('user_id', user.id)
        .order('tournament_date', ascending: false);

    return (response as List)
        .map((json) => Tournament.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Stream<List<Tournament>> watchTournaments() async* {
    yield await fetchTournaments();
    final user = _client.auth.currentUser;
    if (user == null) return;

    yield* _client
        .from('tournaments')
        .stream(primaryKey: ['id'])
        .eq('user_id', user.id)
        .asyncMap((_) => fetchTournaments());
  }

  Future<void> createTournament({
    required String gameId,
    required String deckId,
    required String name,
    required DateTime tournamentDate,
    int? placement,
    int? totalParticipants,
    String? notes,
    List<String> tags = const [],
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Kein Nutzer eingeloggt');

    await _client.from('tournaments').insert({
      'user_id': user.id,
      'game_id': gameId,
      'deck_id': deckId,
      'name': name,
      'tournament_date': tournamentDate.toIso8601String().split('T').first,
      'placement': placement,
      'total_participants': totalParticipants,
      'notes': notes,
      'tags': tags,
    });
  }

  Future<void> updateTournament({
    required String tournamentId,
    required String gameId,
    required String deckId,
    required String name,
    required DateTime tournamentDate,
    int? placement,
    int? totalParticipants,
    String? notes,
    List<String> tags = const [],
  }) async {
    await _client.from('tournaments').update({
      'game_id': gameId,
      'deck_id': deckId,
      'name': name,
      'tournament_date': tournamentDate.toIso8601String().split('T').first,
      'placement': placement,
      'total_participants': totalParticipants,
      'notes': notes,
      'tags': tags,
    }).eq('id', tournamentId);
  }

  Future<void> deleteTournament(String tournamentId) async {
    await _client.from('tournaments').delete().eq('id', tournamentId);
  }

  Future<List<MatchRecord>> fetchRelatedMatches(Tournament tournament) async {
    final user = _client.auth.currentUser;
    if (user == null) return [];

    final response = await _client
        .from('matches')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    final matches = (response as List)
        .map((json) => MatchRecord.fromJson(json as Map<String, dynamic>))
        .toList();

    return matches.where((match) {
      final tagOverlap = tournament.tags.isNotEmpty &&
          match.tags.any((tag) => tournament.tags.contains(tag));
      if (!tagOverlap) return false;
      if (tournament.deckId != null && match.deckId != tournament.deckId) {
        return false;
      }
      return true;
    }).toList();
  }
}
