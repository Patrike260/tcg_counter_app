class MatchRecord {
  final String id;
  final String userId;
  final String deckId;
  final String opponentDeck;
  final String result; // 'win', 'loss', 'draw', 'timeout'
  final String matchFormat; // 'bo1', 'bo3'
  final String? score;
  final String? turnOrder; // 'first', 'second'
  final List<String> tags;
  final String? notes;
  final DateTime createdAt;

  MatchRecord({
    required this.id,
    required this.userId,
    required this.deckId,
    required this.opponentDeck,
    required this.result,
    this.matchFormat = 'bo1',
    this.score,
    this.turnOrder,
    this.tags = const [],
    this.notes,
    required this.createdAt,
  });

  factory MatchRecord.fromJson(Map<String, dynamic> json) {
    return MatchRecord(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      deckId: json['deck_id'] as String,
      opponentDeck: json['opponent_deck'] as String,
      result: json['result'] as String,
      matchFormat: json['match_format'] as String? ?? 'bo1',
      score: json['score'] as String?,
      turnOrder: json['turn_order'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}