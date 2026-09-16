import 'dart:convert';

class ToolPreset {
  final String id;
  final String name;
  final int playerCount;
  final int startingLife;
  final bool hasTimer;
  final int timerMinutes;

  const ToolPreset({
    required this.id,
    required this.name,
    required this.playerCount,
    required this.startingLife,
    required this.hasTimer,
    required this.timerMinutes,
  });

  static const List<ToolPreset> defaults = [
    ToolPreset(
      id: 'preset_1v1',
      name: '1vs1 Standard',
      playerCount: 2,
      startingLife: 20,
      hasTimer: true,
      timerMinutes: 50,
    ),
    ToolPreset(
      id: 'preset_commander',
      name: 'Commander / EDH',
      playerCount: 4,
      startingLife: 40,
      hasTimer: false,
      timerMinutes: 0,
    ),
    ToolPreset(
      id: 'preset_8000',
      name: '8000 LP',
      playerCount: 2,
      startingLife: 8000,
      hasTimer: true,
      timerMinutes: 45,
    ),
  ];

  int get clampedPlayerCount => playerCount.clamp(2, 4);

  String get summary {
    final timer = hasTimer && timerMinutes > 0 ? '$timerMinutes Min' : 'kein Timer';
    return '$clampedPlayerCount Spieler • $startingLife LP • $timer';
  }

  List<int> get lifeSteps {
    if (startingLife >= 1000) return const [-500, -100, 100, 500];
    return const [-5, -1, 1, 5];
  }

  List<String> get defaultNames {
    final count = clampedPlayerCount;
    if (count == 2) return const ['Spieler 1', 'Gegner'];
    return List.generate(count, (index) => 'Spieler ${index + 1}');
  }

  Duration get timerDuration => Duration(minutes: timerMinutes < 0 ? 0 : timerMinutes);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'playerCount': clampedPlayerCount,
      'startingLife': startingLife,
      'hasTimer': hasTimer,
      'timerMinutes': timerMinutes,
    };
  }

  factory ToolPreset.fromMap(Map<String, dynamic> map) {
    final players = (map['playerCount'] as num?)?.toInt() ?? 2;
    return ToolPreset(
      id: map['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: (map['name'] as String?)?.trim().isNotEmpty == true
          ? (map['name'] as String).trim()
          : 'Preset',
      playerCount: players.clamp(2, 4),
      startingLife: (map['startingLife'] as num?)?.toInt() ?? 20,
      hasTimer: map['hasTimer'] as bool? ?? false,
      timerMinutes: (map['timerMinutes'] as num?)?.toInt() ?? 0,
    );
  }

  String encode() => jsonEncode(toMap());

  static ToolPreset decode(String source) {
    final decoded = jsonDecode(source);
    if (decoded is Map<String, dynamic>) {
      return ToolPreset.fromMap(decoded);
    }
    return ToolPreset.fromMap(Map<String, dynamic>.from(decoded as Map));
  }

  static List<ToolPreset> decodeList(List<String>? raw) {
    if (raw == null || raw.isEmpty) return List<ToolPreset>.from(defaults);
    final parsed = <ToolPreset>[];
    for (final item in raw) {
      try {
        parsed.add(ToolPreset.decode(item));
      } catch (_) {}
    }
    return parsed.isEmpty ? List<ToolPreset>.from(defaults) : parsed;
  }

  static List<String> encodeList(List<ToolPreset> presets) {
    return presets.map((preset) => preset.encode()).toList();
  }

  ToolPreset copyWith({
    String? id,
    String? name,
    int? playerCount,
    int? startingLife,
    bool? hasTimer,
    int? timerMinutes,
  }) {
    return ToolPreset(
      id: id ?? this.id,
      name: name ?? this.name,
      playerCount: (playerCount ?? this.playerCount).clamp(2, 4),
      startingLife: startingLife ?? this.startingLife,
      hasTimer: hasTimer ?? this.hasTimer,
      timerMinutes: timerMinutes ?? this.timerMinutes,
    );
  }
}
