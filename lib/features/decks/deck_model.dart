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
  final String? gameName;
  final String? deckListUrl;
  final DateTime createdAt;

  Deck({
    required this.id,
    required this.userId,
    required this.gameId,
    required this.name,
    this.notes,
    this.isActive = true,
    this.gameName,
    this.deckListUrl,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);

  factory Deck.fromJson(Map<String, dynamic> json) {
    return Deck(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      gameId: json['game_id'] as String,
      name: json['name'] as String,
      notes: json['notes'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      gameName: _readGameName(json),
      deckListUrl: json['deck_list_url'] as String?,
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  static String? _readGameName(Map<String, dynamic> json) {
    final nested = json['games'];
    if (nested is Map && nested['name'] is String) {
      return nested['name'] as String;
    }
    final flat = json['game_name'];
    return flat is String ? flat : null;
  }

  bool get hasDeckListUrl => (deckListUrl ?? '').trim().isNotEmpty;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'game_id': gameId,
      'name': name,
      'notes': notes,
      'is_active': isActive,
      'deck_list_url': deckListUrl,
      'game_name': gameName,
      'created_at': createdAt.toIso8601String(),
      if (gameName != null) 'games': {'name': gameName},
    };
  }
}