import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences muss in main() initialisiert werden');
});

final appPreferencesProvider =
    NotifierProvider<AppPreferencesNotifier, AppPreferencesState>(() {
  return AppPreferencesNotifier();
});

class AppPreferencesState {
  final String defaultFormat; // 'bo1' oder 'bo3'
  final String defaultTurnOrder; // 'none', 'first', 'second'
  final String? defaultGameId;
  final bool rememberLastTags;
  final List<String> lastUsedTags;
  final List<String> customTags;

  // Die unveränderlichen Standard-Tags
  static const List<String> defaultBaseTags = [
    'Local',
    'Regional',
    'Casual',
    'Testing',
    'Online',
  ];

  const AppPreferencesState({
    this.defaultFormat = 'bo1',
    this.defaultTurnOrder = 'none',
    this.defaultGameId,
    this.rememberLastTags = false,
    this.lastUsedTags = const [],
    this.customTags = const [],
  });

  // Liefert alle verfügbaren Tags (Standard + Eigene ohne Duplikate)
  List<String> get allAvailableTags {
    final combined = <String>{...defaultBaseTags, ...customTags};
    return combined.toList();
  }

  AppPreferencesState copyWith({
    String? defaultFormat,
    String? defaultTurnOrder,
    String? defaultGameId,
    bool? rememberLastTags,
    List<String>? lastUsedTags,
    List<String>? customTags,
  }) {
    return AppPreferencesState(
      defaultFormat: defaultFormat ?? this.defaultFormat,
      defaultTurnOrder: defaultTurnOrder ?? this.defaultTurnOrder,
      defaultGameId: defaultGameId ?? this.defaultGameId,
      rememberLastTags: rememberLastTags ?? this.rememberLastTags,
      lastUsedTags: lastUsedTags ?? this.lastUsedTags,
      customTags: customTags ?? this.customTags,
    );
  }
}

class AppPreferencesNotifier extends Notifier<AppPreferencesState> {
  static const _keyFormat = 'pref_default_format';
  static const _keyTurnOrder = 'pref_default_turn_order';
  static const _keyGameId = 'pref_default_game_id';
  static const _keyRememberTags = 'pref_remember_last_tags';
  static const _keyLastUsedTags = 'pref_last_used_tags';
  static const _keyCustomTags = 'pref_custom_tags';

  @override
  AppPreferencesState build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return AppPreferencesState(
      defaultFormat: prefs.getString(_keyFormat) ?? 'bo1',
      defaultTurnOrder: prefs.getString(_keyTurnOrder) ?? 'none',
      defaultGameId: prefs.getString(_keyGameId),
      rememberLastTags: prefs.getBool(_keyRememberTags) ?? false,
      lastUsedTags: prefs.getStringList(_keyLastUsedTags) ?? const [],
      customTags: prefs.getStringList(_keyCustomTags) ?? const [],
    );
  }

  Future<void> setDefaultFormat(String format) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_keyFormat, format);
    state = state.copyWith(defaultFormat: format);
  }

  Future<void> setDefaultTurnOrder(String turnOrder) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_keyTurnOrder, turnOrder);
    state = state.copyWith(defaultTurnOrder: turnOrder);
  }

  Future<void> setDefaultGameId(String? gameId) async {
    final prefs = ref.read(sharedPreferencesProvider);
    if (gameId == null) {
      await prefs.remove(_keyGameId);
    } else {
      await prefs.setString(_keyGameId, gameId);
    }
    state = state.copyWith(defaultGameId: gameId);
  }

  Future<void> setRememberLastTags(bool value) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_keyRememberTags, value);
    state = state.copyWith(rememberLastTags: value);
  }

  Future<void> setLastUsedTags(List<String> tags) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setStringList(_keyLastUsedTags, tags);
    state = state.copyWith(lastUsedTags: tags);
  }

  Future<void> addCustomTag(String tag) async {
    final cleanTag = tag.trim();
    if (cleanTag.isEmpty || state.allAvailableTags.contains(cleanTag)) return;

    final updated = [...state.customTags, cleanTag];
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setStringList(_keyCustomTags, updated);
    state = state.copyWith(customTags: updated);
  }

  Future<void> removeCustomTag(String tag) async {
    final updated = state.customTags.where((t) => t != tag).toList();
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setStringList(_keyCustomTags, updated);

    final updatedLastUsed = state.lastUsedTags.where((t) => t != tag).toList();
    await prefs.setStringList(_keyLastUsedTags, updatedLastUsed);

    state = state.copyWith(
      customTags: updated,
      lastUsedTags: updatedLastUsed,
    );
  }
}