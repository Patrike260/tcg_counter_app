import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/l10n.dart';
import '../settings/app_preferences_service.dart';
import '../tournaments/tournament_repository.dart';
import 'dashboard_config_model.dart';
import 'dashboard_repository.dart';
import 'dashboard_widgets.dart';
import 'widgets/promo_banner_widget.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final activeTabs = ref.watch(appPreferencesProvider).enabledDashboardTabs;

    if (activeTabs.isEmpty) {
      return Scaffold(body: Center(child: Text(l10n.noDashboardTab)));
    }

    if (activeTabs.length == 1) {
      return Scaffold(body: _DashboardTabPane(tab: activeTabs.first));
    }

    return Scaffold(
      body: DefaultTabController(
        key: ValueKey(
          activeTabs
              .map((tab) => '${tab.id}:${tab.selectedTag}:${tab.sanitizedWidgetKeys.join(',')}')
              .join('|'),
        ),
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
                              tab.localizedTitle(l10n),
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
                  for (final tab in activeTabs) _DashboardTabPane(tab: tab),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardTabPane extends ConsumerWidget {
  final DashboardTabConfig tab;

  const _DashboardTabPane({required this.tab});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final dashboardAsync = ref.watch(dashboardDataProvider(tab.selectedTag));
    final keys = tab.sanitizedWidgetKeys;

    return dashboardAsync.when(
      data: (data) {
        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(dashboardDataProvider);
            ref.invalidate(tournamentsListProvider);
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              if (data.focusTag != null) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Chip(
                    avatar: const Icon(Icons.label_outlined, size: 16),
                    label: Text(l10n.eventFilter(data.focusTag!)),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              for (var i = 0; i < keys.length; i++) ...[
                if (i > 0) const SizedBox(height: 20),
                buildDashboardWidget(keys[i], data, context),
              ],
              const SizedBox(height: 20),
              const PromoBannerWidget(),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text(l10n.errorWithDetails(err))),
    );
  }
}
