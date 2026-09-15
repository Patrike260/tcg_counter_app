class Game {
  final String id;
  final String name;

  Game({required this.id, required this.name});

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}

class Deck {
  final String id;
  final String userId;
  final String gameId;
  final String name;
  final String? notes;
  final bool isActive;
  final String? gameName; // Aus dem Join geladen

  Deck({
    required this.id,
    required this.userId,
    required this.gameId,
    required this.name,
    this.notes,
    this.isActive = true,
    this.gameName,
  });

  factory Deck.fromJson(Map<String, dynamic> json) {
    return Deck(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      gameId: json['game_id'] as String,
      name: json['name'] as String,
      notes: json['notes'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      gameName: json['games'] != null ? json['games']['name'] as String? : null,
    );
  }
}