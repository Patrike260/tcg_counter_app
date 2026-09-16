import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../stats/dashboard_config_model.dart';
import '../stats/dashboard_widgets.dart';
import 'app_preferences_service.dart';

class DashboardSettingsScreen extends ConsumerWidget {
  const DashboardSettingsScreen({super.key});

  Future<void> _editWidgets(
    BuildContext context,
    WidgetRef ref,
    DashboardTabConfig tab,
  ) async {
    final selected = {...tab.sanitizedWidgetKeys};
    final saved = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Widgets in „${tab.title}“',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    for (final key in DashboardWidgetKeys.all)
                      CheckboxListTile(
                        value: selected.contains(key),
                        title: Text(DashboardWidgetKeys.labelOf(key)),
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (checked) {
                          setModalState(() {
                            if (checked == true) {
                              selected.add(key);
                            } else if (selected.length > 1) {
                              selected.remove(key);
                            }
                          });
                        },
                      ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton(
                        onPressed: () => Navigator.pop(ctx, selected.toList()),
                        child: const Text('Übernehmen'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
    if (saved == null) return;
    await ref.read(appPreferencesProvider.notifier).setDashboardTabWidgets(tab.id, saved);
  }

  Future<void> _addTab(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eigenen Tab anlegen'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Tab-Name',
            hintText: 'z. B. Locals',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Abbrechen')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Anlegen'),
          ),
        ],
      ),
    );
    if (name == null || name.isEmpty) return;
    await ref.read(appPreferencesProvider.notifier).addDashboardTab(name);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabs = ref.watch(appPreferencesProvider).dashboardTabs;
    final notifier = ref.read(appPreferencesProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard-Tabs'),
        actions: [
          IconButton(
            tooltip: 'Standard wiederherstellen',
            icon: const Icon(Icons.restore),
            onPressed: () => notifier.resetDashboardTabs(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTab(context, ref),
        child: const Icon(Icons.add),
      ),
      body: ReorderableListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 88),
        itemCount: tabs.length,
        onReorder: (oldIndex, newIndex) {
          notifier.reorderDashboardTabs(oldIndex, newIndex);
        },
        itemBuilder: (context, index) {
          final tab = tabs[index];
          return Card(
            key: ValueKey(tab.id),
            margin: const EdgeInsets.only(bottom: 10),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
              child: Column(
                children: [
                  SwitchListTile(
                    value: tab.isEnabled,
                    secondary: Icon(dashboardTabIcon(tab.iconName)),
                    title: Text(tab.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text(
                      '${tab.sanitizedWidgetKeys.length} Widgets • ${tab.sanitizedWidgetKeys.map(DashboardWidgetKeys.labelOf).join(', ')}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onChanged: (enabled) async {
                      final ok = await notifier.toggleDashboardTab(tab.id, enabled);
                      if (!ok && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Mindestens ein Tab muss aktiv bleiben.')),
                        );
                      }
                    },
                  ),
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () => _editWidgets(context, ref, tab),
                        icon: const Icon(Icons.widgets_outlined, size: 18),
                        label: const Text('Widgets'),
                      ),
                      if (tabs.length > 1)
                        TextButton.icon(
                          onPressed: () async {
                            final ok = await notifier.deleteDashboardTab(tab.id);
                            if (!ok && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Mindestens ein Tab muss erhalten bleiben.')),
                              );
                            }
                          },
                          icon: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                          label: const Text('Entfernen'),
                        ),
                      const Spacer(),
                      const Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: Icon(Icons.drag_handle),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
