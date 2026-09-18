import '../../l10n/app_localizations.dart';

class Tournament {
  final String id;
  final String userId;
  final String gameId;
  final String? deckId;
  final String name;
  final DateTime tournamentDate;
  final int? placement;
  final int? totalParticipants;
  final String? notes;
  final String? deckName;
  final String? gameName;
  final List<String> tags;

  const Tournament({
    required this.id,
    required this.userId,
    required this.gameId,
    this.deckId,
    required this.name,
    required this.tournamentDate,
    this.placement,
    this.totalParticipants,
    this.notes,
    this.deckName,
    this.gameName,
    this.tags = const [],
  });

  String get dateLabel {
    final day = tournamentDate.day.toString().padLeft(2, '0');
    final month = tournamentDate.month.toString().padLeft(2, '0');
    return '$day.$month.${tournamentDate.year}';
  }

  String get placementLabel {
    if (placement == null) return 'Keine Platzierung';
    if (totalParticipants != null) return '#$placement / $totalParticipants';
    if (placement == 1) return '1. Platz';
    if (placement! <= 8) return 'Top $placement';
    return 'Platz $placement';
  }

  String localizedPlacement(AppLocalizations l10n) {
    if (placement == null) return l10n.noPlacement;
    if (totalParticipants != null) {
      return l10n.placementOf(placement!, totalParticipants!);
    }
    if (placement == 1) return l10n.firstPlace;
    if (placement! <= 8) return l10n.topPlacement(placement!);
    return l10n.placeNumber(placement!);
  }

  bool get isTopCut => placement != null && placement! <= 8;

  factory Tournament.fromJson(Map<String, dynamic> json) {
    final decks = json['decks'];
    final games = json['games'];
    return Tournament(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      gameId: json['game_id'] as String,
      deckId: json['deck_id'] as String?,
      name: json['name'] as String,
      tournamentDate: DateTime.parse(json['tournament_date'] as String),
      placement: _asInt(json['placement']),
      totalParticipants: _asInt(json['total_participants']),
      notes: json['notes'] as String?,
      deckName: decks is Map<String, dynamic> ? decks['name'] as String? : null,
      gameName: games is Map<String, dynamic> ? games['name'] as String? : null,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'game_id': gameId,
      'deck_id': deckId,
      'name': name,
      'tournament_date': tournamentDate.toIso8601String().split('T').first,
      'placement': placement,
      'total_participants': totalParticipants,
      'notes': notes,
      'tags': tags,
    };
  }

  static int? _asInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
}
