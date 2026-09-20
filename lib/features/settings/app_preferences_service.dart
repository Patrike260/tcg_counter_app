import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_theme_presets.dart';
import '../../core/theme/app_themes.dart';
import '../stats/dashboard_config_model.dart';
import '../tools/life_preset_model.dart';
import '../tools/tool_preset_model.dart';

const _copyWithUnset = Object();

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
  final List<String> hiddenGameIds;
  final List<ToolPreset> toolPresets;
  final List<LifePreset> customLifePresets;
  final String activeLifePresetId;
  final String dashboardTimeRange;
  final String? dashboardGameId;
  final AppThemePreset themePreset;
  final ThemeMode themeMode;
  final String activePreset;
  final List<DashboardTabConfig> dashboardTabs;
  /// `system`, `de`, `en`, `fr` or `it`.
  final String localeCode;
  final bool showPromoBanner;
  final String deckSortMode;
  final List<String> customDeckOrder;

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
    this.hiddenGameIds = const [],
    this.toolPresets = ToolPreset.defaults,
    this.customLifePresets = const [],
    this.activeLifePresetId = 'mtg60',
    this.dashboardTimeRange = 'month',
    this.dashboardGameId,
    this.themePreset = AppThemePreset.onePiece,
    this.themeMode = ThemeMode.system,
    this.activePreset = AppThemeKeys.cyberpunk,
    this.dashboardTabs = DashboardTabConfig.defaults,
    this.localeCode = 'system',
    this.showPromoBanner = true,
    this.deckSortMode = 'newest',
    this.customDeckOrder = const [],
  });

  static const supportedLocaleCodes = ['de', 'en', 'fr', 'it'];

  bool get usesSystemLocale =>
      localeCode.isEmpty || localeCode == 'system';

  Locale? get localeOverride {
    if (usesSystemLocale) return null;
    return Locale(localeCode);
  }

  String localeLabel({
    required String system,
    required String german,
    required String english,
    required String french,
    required String italian,
  }) {
    switch (localeCode) {
      case 'de':
        return german;
      case 'en':
        return english;
      case 'fr':
        return french;
      case 'it':
        return italian;
      default:
        return system;
    }
  }

  // Liefert alle verfügbaren Tags (Standard + Eigene ohne Duplikate)
  List<String> get allAvailableTags {
    final combined = <String>{...defaultBaseTags, ...customTags};
    return combined.toList();
  }

  String get defaultFormatLabel => defaultFormat.toUpperCase();

  String get defaultTurnOrderLabel {
    switch (defaultTurnOrder) {
      case 'first':
        return '1st';
      case 'second':
        return '2nd';
      default:
        return 'Zug frei';
    }
  }

  bool isGameHidden(String gameId) => hiddenGameIds.contains(gameId);

  bool isGameVisible(String gameId) => !isGameHidden(gameId);

  /// Standard-TCG, oder null wenn keines gesetzt / ausgeblendet ist.
  String? get resolvedDefaultGameId {
    final id = defaultGameId;
    if (id == null || isGameHidden(id)) return null;
    return id;
  }

  /// Dashboard-Fokus, oder null (alle sichtbaren TCGs) wenn keines / ausgeblendet.
  String? get resolvedDashboardGameId {
    final id = dashboardGameId;
    if (id == null || isGameHidden(id)) return null;
    return id;
  }

  List<DashboardTabConfig> get enabledDashboardTabs {
    final enabled = dashboardTabs.where((tab) => tab.isEnabled).toList();
    if (enabled.isNotEmpty) return enabled;
    return [dashboardTabs.isNotEmpty ? dashboardTabs.first : DashboardTabConfig.defaults.first];
  }

  List<LifePreset> get lifePresets => [
        ...LifePreset.defaults,
        ...customLifePresets,
      ];

  LifePreset get resolvedLifePreset {
    for (final preset in lifePresets) {
      if (preset.id == activeLifePresetId) return preset;
    }
    return LifePreset.defaults.first;
  }

  AppPreferencesState copyWith({
    String? defaultFormat,
    String? defaultTurnOrder,
    Object? defaultGameId = _copyWithUnset,
    bool? rememberLastTags,
    List<String>? lastUsedTags,
    List<String>? customTags,
    List<String>? hiddenGameIds,
    List<ToolPreset>? toolPresets,
    List<LifePreset>? customLifePresets,
    String? activeLifePresetId,
    String? dashboardTimeRange,
    Object? dashboardGameId = _copyWithUnset,
    AppThemePreset? themePreset,
    ThemeMode? themeMode,
    String? activePreset,
    List<DashboardTabConfig>? dashboardTabs,
    String? localeCode,
    bool? showPromoBanner,
    String? deckSortMode,
    List<String>? customDeckOrder,
  }) {
    return AppPreferencesState(
      defaultFormat: defaultFormat ?? this.defaultFormat,
      defaultTurnOrder: defaultTurnOrder ?? this.defaultTurnOrder,
      defaultGameId: identical(defaultGameId, _copyWithUnset)
          ? this.defaultGameId
          : defaultGameId as String?,
      rememberLastTags: rememberLastTags ?? this.rememberLastTags,
      lastUsedTags: lastUsedTags ?? this.lastUsedTags,
      customTags: customTags ?? this.customTags,
      hiddenGameIds: hiddenGameIds ?? this.hiddenGameIds,
      toolPresets: toolPresets ?? this.toolPresets,
      customLifePresets: customLifePresets ?? this.customLifePresets,
      activeLifePresetId: activeLifePresetId ?? this.activeLifePresetId,
      dashboardTimeRange: dashboardTimeRange ?? this.dashboardTimeRange,
      dashboardGameId: identical(dashboardGameId, _copyWithUnset)
          ? this.dashboardGameId
          : dashboardGameId as String?,
      themePreset: themePreset ?? this.themePreset,
      themeMode: themeMode ?? this.themeMode,
      activePreset: activePreset ?? this.activePreset,
      dashboardTabs: dashboardTabs ?? this.dashboardTabs,
      localeCode: localeCode ?? this.localeCode,
      showPromoBanner: showPromoBanner ?? this.showPromoBanner,
      deckSortMode: deckSortMode ?? this.deckSortMode,
      customDeckOrder: customDeckOrder ?? this.customDeckOrder,
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
  static const _keyHiddenGameIds = 'pref_hidden_game_ids';
  static const _keyToolPresets = 'pref_tool_presets';
  static const _keyCustomLifePresets = 'pref_life_presets';
  static const _keyActiveLifePreset = 'pref_active_life_preset';
  static const _keyDashboardTimeRange = 'pref_dashboard_time_range';
  static const _keyDashboardGameId = 'pref_dashboard_game_id';
  static const _keyThemePreset = 'pref_app_theme_preset';
  static const _legacyKeyThemePreset = 'pref_selected_theme_preset';
  static const _keyThemeMode = 'pref_theme_mode';
  static const _keyActivePreset = 'pref_theme_preset';
  static const _keyDashboardTabs = 'pref_dashboard_tabs_config';
  static const _keyLocaleCode = 'pref_app_locale_code';
  static const _keyShowPromoBanner = 'pref_show_promo_banner';
  static const _keyDeckSortMode = 'pref_deck_sort_mode';
  static const _keyCustomDeckOrder = 'pref_custom_deck_order';

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
      hiddenGameIds: prefs.getStringList(_keyHiddenGameIds) ?? const [],
      toolPresets: ToolPreset.decodeList(prefs.getStringList(_keyToolPresets)),
      customLifePresets:
          LifePreset.decodeCustomList(prefs.getStringList(_keyCustomLifePresets)),
      activeLifePresetId: prefs.getString(_keyActiveLifePreset) ?? 'mtg60',
      dashboardTimeRange: prefs.getString(_keyDashboardTimeRange) ?? 'month',
      dashboardGameId: prefs.getString(_keyDashboardGameId),
      themePreset: parseAppThemePreset(
        prefs.getString(_keyThemePreset) ?? prefs.getString(_legacyKeyThemePreset),
      ),
      themeMode: parseThemeMode(prefs.getString(_keyThemeMode)),
      activePreset: AppThemeKeys.normalize(prefs.getString(_keyActivePreset)),
      dashboardTabs: DashboardTabConfig.decodeList(prefs.getStringList(_keyDashboardTabs)),
      localeCode: prefs.getString(_keyLocaleCode) ?? 'system',
      showPromoBanner: prefs.getBool(_keyShowPromoBanner) ?? true,
      deckSortMode: _normalizeDeckSortMode(prefs.getString(_keyDeckSortMode)),
      customDeckOrder: prefs.getStringList(_keyCustomDeckOrder) ?? const [],
    );
  }

  Future<void> setShowPromoBanner(bool value) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_keyShowPromoBanner, value);
    state = state.copyWith(showPromoBanner: value);
  }

  Future<void> setDeckSortMode(String mode) async {
    final normalized = _normalizeDeckSortMode(mode);
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_keyDeckSortMode, normalized);
    state = state.copyWith(deckSortMode: normalized);
  }

  Future<void> setCustomDeckOrder(List<String> deckIds) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setStringList(_keyCustomDeckOrder, deckIds);
    state = state.copyWith(customDeckOrder: deckIds);
  }

  Future<void> setLocaleCode(String code) async {
    final normalized = (code == 'system' ||
            AppPreferencesState.supportedLocaleCodes.contains(code))
        ? code
        : 'system';
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_keyLocaleCode, normalized);
    state = state.copyWith(localeCode: normalized);
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
    if (gameId == null || state.isGameHidden(gameId)) {
      await prefs.remove(_keyGameId);
      state = state.copyWith(defaultGameId: null);
      return;
    }
    await prefs.setString(_keyGameId, gameId);
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

  /// [isVisible] true = TCG anzeigen, false = in Dropdowns ausblenden.
  Future<bool> toggleGameVisibility(String gameId, bool isVisible) async {
    final hidden = [...state.hiddenGameIds];
    if (isVisible) {
      hidden.remove(gameId);
    } else if (!hidden.contains(gameId)) {
      hidden.add(gameId);
    }

    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setStringList(_keyHiddenGameIds, hidden);

    final hideDefault = !isVisible && state.defaultGameId == gameId;
    final hideDashboard = !isVisible && state.dashboardGameId == gameId;
    if (hideDefault) {
      await prefs.remove(_keyGameId);
    }
    if (hideDashboard) {
      await prefs.remove(_keyDashboardGameId);
    }

    state = state.copyWith(
      hiddenGameIds: hidden,
      defaultGameId: hideDefault ? null : _copyWithUnset,
      dashboardGameId: hideDashboard ? null : _copyWithUnset,
    );
    return true;
  }

  Future<void> setDashboardTimeRange(String timeRange) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_keyDashboardTimeRange, timeRange);
    state = state.copyWith(dashboardTimeRange: timeRange);
  }

  Future<void> setThemePreset(AppThemePreset preset) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_keyThemePreset, preset.name);
    state = state.copyWith(themePreset: preset);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_keyThemeMode, themeModeStorage(mode));
    state = state.copyWith(themeMode: mode);
  }

  Future<void> setActivePreset(String presetKey) async {
    final normalized = AppThemeKeys.normalize(presetKey);
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_keyActivePreset, normalized);
    state = state.copyWith(activePreset: normalized);
  }

  Future<void> setDashboardGameId(String? gameId) async {
    final prefs = ref.read(sharedPreferencesProvider);
    if (gameId == null || state.isGameHidden(gameId)) {
      await prefs.remove(_keyDashboardGameId);
      state = state.copyWith(dashboardGameId: null);
      return;
    }
    await prefs.setString(_keyDashboardGameId, gameId);
    state = state.copyWith(dashboardGameId: gameId);
  }

  Future<void> _persistDashboardTabs(List<DashboardTabConfig> tabs) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setStringList(_keyDashboardTabs, DashboardTabConfig.encodeList(tabs));
    state = state.copyWith(dashboardTabs: tabs);
  }

  Future<void> updateDashboardTabs(List<DashboardTabConfig> newTabs) async {
    var next = List<DashboardTabConfig>.from(newTabs);
    if (next.isEmpty) {
      next = List<DashboardTabConfig>.from(DashboardTabConfig.defaults);
    }
    if (next.every((tab) => !tab.isEnabled)) {
      next[0] = next[0].copyWith(isEnabled: true);
    }
    await _persistDashboardTabs(next);
  }

  Future<void> toggleDashboardTab(String tabId, bool isEnabled) async {
    final enabledCount = state.dashboardTabs.where((tab) => tab.isEnabled).length;
    if (!isEnabled && enabledCount <= 1) return;
    final updated = state.dashboardTabs
        .map((tab) => tab.id == tabId ? tab.copyWith(isEnabled: isEnabled) : tab)
        .toList();
    await updateDashboardTabs(updated);
  }

  Future<void> resetDashboardTabsToDefault() async {
    await updateDashboardTabs(List<DashboardTabConfig>.from(DashboardTabConfig.defaults));
  }

  Future<void> resetDashboardTabs() => resetDashboardTabsToDefault();

  Future<void> reorderDashboardTabs(int oldIndex, int newIndex) async {
    final updated = [...state.dashboardTabs];
    if (newIndex > oldIndex) newIndex -= 1;
    final item = updated.removeAt(oldIndex);
    updated.insert(newIndex, item);
    await updateDashboardTabs(updated);
  }

  Future<void> setDashboardTabSelectedTag(String tabId, String? tag) async {
    final cleaned = tag?.trim();
    final updated = state.dashboardTabs
        .map(
          (tab) => tab.id == tabId
              ? tab.copyWith(selectedTag: (cleaned == null || cleaned.isEmpty) ? null : cleaned)
              : tab,
        )
        .toList();
    await updateDashboardTabs(updated);
  }

  Future<void> updateTabWidgets(String tabId, List<String> widgetKeys) async {
    final updated = state.dashboardTabs
        .map((tab) => tab.id == tabId ? tab.copyWith(widgetKeys: widgetKeys) : tab)
        .toList();
    await updateDashboardTabs(updated);
  }

  Future<void> setDashboardTabWidgets(String id, List<String> widgetKeys) {
    return updateTabWidgets(id, widgetKeys);
  }

  Future<void> addCustomDashboardTab(DashboardTabConfig newTab) async {
    await updateDashboardTabs([...state.dashboardTabs, newTab]);
  }

  Future<void> addDashboardTab(String title) {
    return addCustomDashboardTab(
      DashboardTabConfig(
        id: 'tab_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        iconName: 'tune_outlined',
        widgetKeys: const [DashboardWidgetKeys.kpiWinrate],
      ),
    );
  }

  Future<void> deleteDashboardTab(String tabId) async {
    final target = state.dashboardTabs.where((tab) => tab.id == tabId);
    if (target.isEmpty || target.first.isPreset) return;
    if (state.dashboardTabs.length <= 1) return;
    final updated = state.dashboardTabs.where((tab) => tab.id != tabId).toList();
    if (updated.isEmpty) return;
    await updateDashboardTabs(updated);
  }

  Future<void> _persistToolPresets(List<ToolPreset> presets) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setStringList(_keyToolPresets, ToolPreset.encodeList(presets));
    state = state.copyWith(toolPresets: presets);
  }

  Future<void> addCustomLifePreset(LifePreset preset) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final next = [...state.customLifePresets, preset];
    await prefs.setStringList(_keyCustomLifePresets, LifePreset.encodeList(next));
    await prefs.setString(_keyActiveLifePreset, preset.id);
    state = state.copyWith(
      customLifePresets: next,
      activeLifePresetId: preset.id,
    );
  }

  Future<void> deleteCustomLifePreset(String id) async {
    final next = state.customLifePresets.where((item) => item.id != id).toList();
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setStringList(_keyCustomLifePresets, LifePreset.encodeList(next));
    final active = state.activeLifePresetId == id ? 'mtg60' : state.activeLifePresetId;
    await prefs.setString(_keyActiveLifePreset, active);
    state = state.copyWith(
      customLifePresets: next,
      activeLifePresetId: active,
    );
  }

  Future<void> setActiveLifePresetId(String id) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_keyActiveLifePreset, id);
    state = state.copyWith(activeLifePresetId: id);
  }

  Future<void> addToolPreset(ToolPreset preset) async {
    await _persistToolPresets([...state.toolPresets, preset]);
  }

  Future<void> updateToolPreset(ToolPreset preset) async {
    final updated = state.toolPresets
        .map((item) => item.id == preset.id ? preset : item)
        .toList();
    await _persistToolPresets(updated);
  }

  Future<bool> deleteToolPreset(String id) async {
    if (state.toolPresets.length <= 1) return false;
    final updated = state.toolPresets.where((item) => item.id != id).toList();
    if (updated.isEmpty) return false;
    await _persistToolPresets(updated);
    return true;
  }

  Future<void> resetToDefaultPresets() async {
    await _persistToolPresets(List<ToolPreset>.from(ToolPreset.defaults));
  }
}

String _normalizeDeckSortMode(String? raw) {
  switch (raw) {
    case 'grouped':
    case 'custom':
      return raw!;
    default:
      return 'newest';
  }
}
