import 'dart:convert';

class DashboardWidgetKeys {
  static const kpiWinrate = 'kpi_winrate';
  static const kpiNemesis = 'kpi_nemesis';
  static const performanceTcg = 'performance_tcg';
  static const recentMatches = 'recent_matches';
  static const tournamentsOverview = 'tournaments_overview';
  static const turnOrderStats = 'turn_order_stats';

  static const all = <String>[
    kpiWinrate,
    kpiNemesis,
    performanceTcg,
    recentMatches,
    tournamentsOverview,
    turnOrderStats,
  ];

  static String labelOf(String key) {
    switch (key) {
      case kpiWinrate:
        return 'Gesamte Winrate & Siegquote';
      case kpiNemesis:
        return 'Nemesis & Best Matchup';
      case performanceTcg:
        return 'Performance nach Kartenspiel';
      case recentMatches:
        return 'Letzte Matches';
      case tournamentsOverview:
        return 'Turniere & Platzierungen';
      case turnOrderStats:
        return '1st / 2nd Zugreihenfolge-Stats';
      default:
        return key;
    }
  }
}

class DashboardTabConfig {
  final String id;
  final String title;
  final String iconName;
  final bool isEnabled;
  final List<String> widgetKeys;
  final String? selectedTag;

  const DashboardTabConfig({
    required this.id,
    required this.title,
    required this.iconName,
    this.isEnabled = true,
    required this.widgetKeys,
    this.selectedTag,
  });

  static const presetIds = <String>{
    'tab_allround',
    'tab_tournament',
    'tab_minimal',
  };

  static const iconChoices = <String>[
    'dashboard_outlined',
    'emoji_events_outlined',
    'view_agenda_outlined',
    'tune_outlined',
    'sports_esports_outlined',
    'style_outlined',
    'analytics_outlined',
    'military_tech_outlined',
  ];

  bool get isPreset => presetIds.contains(id);

  static const List<DashboardTabConfig> defaults = [
    DashboardTabConfig(
      id: 'tab_allround',
      title: 'Allround',
      iconName: 'dashboard_outlined',
      widgetKeys: [
        DashboardWidgetKeys.kpiWinrate,
        DashboardWidgetKeys.kpiNemesis,
        DashboardWidgetKeys.performanceTcg,
        DashboardWidgetKeys.recentMatches,
      ],
    ),
    DashboardTabConfig(
      id: 'tab_tournament',
      title: 'Turnier',
      iconName: 'emoji_events_outlined',
      widgetKeys: [
        DashboardWidgetKeys.kpiNemesis,
        DashboardWidgetKeys.turnOrderStats,
        DashboardWidgetKeys.tournamentsOverview,
      ],
    ),
    DashboardTabConfig(
      id: 'tab_minimal',
      title: 'Minimal',
      iconName: 'view_agenda_outlined',
      widgetKeys: [
        DashboardWidgetKeys.kpiWinrate,
        DashboardWidgetKeys.recentMatches,
      ],
    ),
  ];

  List<String> get sanitizedWidgetKeys {
    final seen = <String>{};
    final result = <String>[];
    for (final key in widgetKeys) {
      if (!DashboardWidgetKeys.all.contains(key) || seen.contains(key)) continue;
      seen.add(key);
      result.add(key);
    }
    return result.isEmpty ? [DashboardWidgetKeys.kpiWinrate] : result;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'iconName': iconName,
      'isEnabled': isEnabled,
      'widgetKeys': sanitizedWidgetKeys,
      'selectedTag': selectedTag,
    };
  }

  factory DashboardTabConfig.fromMap(Map<String, dynamic> map) {
    final rawKeys = map['widgetKeys'];
    final keys = <String>[];
    if (rawKeys is List) {
      for (final item in rawKeys) {
        keys.add(item.toString());
      }
    }
    return DashboardTabConfig(
      id: map['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: (map['title'] as String?)?.trim().isNotEmpty == true
          ? (map['title'] as String).trim()
          : 'Tab',
      iconName: map['iconName'] as String? ?? 'dashboard_outlined',
      isEnabled: map['isEnabled'] as bool? ?? true,
      widgetKeys: keys,
      selectedTag: (map['selectedTag'] as String?)?.trim().isNotEmpty == true
          ? (map['selectedTag'] as String).trim()
          : null,
    );
  }

  String encode() => jsonEncode(toMap());

  static DashboardTabConfig decode(String source) {
    final decoded = jsonDecode(source);
    if (decoded is Map<String, dynamic>) {
      return DashboardTabConfig.fromMap(decoded);
    }
    return DashboardTabConfig.fromMap(Map<String, dynamic>.from(decoded as Map));
  }

  static List<DashboardTabConfig> decodeList(List<String>? raw) {
    if (raw == null || raw.isEmpty) {
      return List<DashboardTabConfig>.from(defaults);
    }
    final parsed = <DashboardTabConfig>[];
    for (final item in raw) {
      try {
        parsed.add(DashboardTabConfig.decode(item));
      } catch (_) {}
    }
    if (parsed.isEmpty) return List<DashboardTabConfig>.from(defaults);
    if (parsed.every((tab) => !tab.isEnabled)) {
      parsed[0] = parsed[0].copyWith(isEnabled: true);
    }
    return parsed;
  }

  static List<String> encodeList(List<DashboardTabConfig> tabs) {
    return tabs.map((tab) => tab.encode()).toList();
  }

  DashboardTabConfig copyWith({
    String? id,
    String? title,
    String? iconName,
    bool? isEnabled,
    List<String>? widgetKeys,
    Object? selectedTag = _copyWithUnset,
  }) {
    return DashboardTabConfig(
      id: id ?? this.id,
      title: title ?? this.title,
      iconName: iconName ?? this.iconName,
      isEnabled: isEnabled ?? this.isEnabled,
      widgetKeys: widgetKeys ?? this.widgetKeys,
      selectedTag: identical(selectedTag, _copyWithUnset)
          ? this.selectedTag
          : selectedTag as String?,
    );
  }
}

const _copyWithUnset = Object();
