import 'dart:convert';

class LifePreset {
  final String id;
  final String name;
  final int startingLife;
  final int stepSmall;
  final int stepLarge;
  final bool isBuiltIn;

  const LifePreset({
    required this.id,
    required this.name,
    required this.startingLife,
    required this.stepSmall,
    required this.stepLarge,
    this.isBuiltIn = false,
  });

  static const List<LifePreset> defaults = [
    LifePreset(
      id: 'mtg60',
      name: 'Magic 60-Card',
      startingLife: 20,
      stepSmall: 1,
      stepLarge: 5,
      isBuiltIn: true,
    ),
    LifePreset(
      id: 'commander',
      name: 'Commander',
      startingLife: 40,
      stepSmall: 1,
      stepLarge: 5,
      isBuiltIn: true,
    ),
    LifePreset(
      id: 'ygo',
      name: 'Yu-Gi-Oh!',
      startingLife: 8000,
      stepSmall: 100,
      stepLarge: 1000,
      isBuiltIn: true,
    ),
  ];

  int get safeStart => startingLife.clamp(1, 99999);
  int get safeSmall => stepSmall.clamp(1, 99999);
  int get safeLarge => stepLarge.clamp(safeSmall, 99999);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'startingLife': safeStart,
      'stepSmall': safeSmall,
      'stepLarge': safeLarge,
      'isBuiltIn': isBuiltIn,
    };
  }

  factory LifePreset.fromMap(Map<String, dynamic> map) {
    final small = (map['stepSmall'] as num?)?.toInt() ?? 1;
    final large = (map['stepLarge'] as num?)?.toInt() ?? small;
    return LifePreset(
      id: map['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: (map['name'] as String?)?.trim().isNotEmpty == true
          ? (map['name'] as String).trim()
          : 'Preset',
      startingLife: (map['startingLife'] as num?)?.toInt() ?? 20,
      stepSmall: small,
      stepLarge: large < small ? small : large,
      isBuiltIn: map['isBuiltIn'] as bool? ?? false,
    );
  }

  String encode() => jsonEncode(toMap());

  static LifePreset decode(String source) {
    final decoded = jsonDecode(source);
    if (decoded is Map<String, dynamic>) {
      return LifePreset.fromMap(decoded);
    }
    return LifePreset.fromMap(Map<String, dynamic>.from(decoded as Map));
  }

  static List<LifePreset> decodeCustomList(List<String>? raw) {
    if (raw == null || raw.isEmpty) return const [];
    final parsed = <LifePreset>[];
    for (final item in raw) {
      try {
        final preset = LifePreset.decode(item);
        if (!preset.isBuiltIn) parsed.add(preset);
      } catch (_) {}
    }
    return parsed;
  }

  static List<String> encodeList(List<LifePreset> presets) {
    return presets.map((preset) => preset.encode()).toList();
  }
}
