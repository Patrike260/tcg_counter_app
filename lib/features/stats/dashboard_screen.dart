import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../settings/app_preferences_service.dart';
import '../tournaments/tournament_repository.dart';
import 'dashboard_config_model.dart';
import 'dashboard_repository.dart';
import 'dashboard_widgets.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardDataProvider);
    final activeTabs = ref.watch(appPreferencesProvider).enabledDashboardTabs;

    return Scaffold(
      body: dashboardAsync.when(
        data: (data) {
          if (activeTabs.isEmpty) {
            return const Center(child: Text('Kein Dashboard-Tab aktiv.'));
          }

          if (activeTabs.length == 1) {
            return _DashboardTabPage(tab: activeTabs.first, data: data);
          }

          return DefaultTabController(
            key: ValueKey(activeTabs.map((tab) => tab.id).join('|')),
            length: activeTabs.length,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    dividerColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1.5,
                      ),
                    ),
                    splashBorderRadius: BorderRadius.circular(24),
                    labelColor: Theme.of(context).colorScheme.primary,
                    unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55),
                    labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                    tabs: [
                      for (final tab in activeTabs)
                        Tab(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(dashboardTabIcon(tab.iconName), size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  tab.title,
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      for (final tab in activeTabs)
                        _DashboardTabPage(tab: tab, data: data),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Fehler: $err')),
      ),
    );
  }
}

class _DashboardTabPage extends ConsumerWidget {
  final DashboardTabConfig tab;
  final DashboardData data;

  const _DashboardTabPage({required this.tab, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keys = tab.sanitizedWidgetKeys;
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(dashboardDataProvider);
        ref.invalidate(tournamentsListProvider);
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          for (var i = 0; i < keys.length; i++) ...[
            if (i > 0) const SizedBox(height: 20),
            buildDashboardWidget(keys[i], data, context),
          ],
        ],
      ),
    );
  }
}
