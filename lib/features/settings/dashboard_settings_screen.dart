import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/l10n.dart';
import '../stats/dashboard_config_model.dart';
import '../stats/dashboard_widgets.dart';
import 'app_preferences_service.dart';

class DashboardSettingsScreen extends ConsumerWidget {
  const DashboardSettingsScreen({super.key});

  Future<void> _editTabWidgets(
    BuildContext context,
    WidgetRef ref,
    DashboardTabConfig tab,
  ) async {
    final ordered = [
      ...tab.sanitizedWidgetKeys,
      ...DashboardWidgetKeys.all.where((key) => !tab.sanitizedWidgetKeys.contains(key)),
    ];
    final selected = {...tab.sanitizedWidgetKeys};

    final saved = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            final sheetL10n = ctx.l10n;
            return SafeArea(
              child: SizedBox(
                height: MediaQuery.sizeOf(ctx).height * 0.72,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Row(
                        children: [
                          Icon(dashboardTabIcon(tab.iconName)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Kacheln in „${tab.localizedTitle(sheetL10n)}“',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Aktiviere Kacheln und ziehe sie in die gewünschte Reihenfolge.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ReorderableListView.builder(
                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                        itemCount: ordered.length,
                        onReorder: (oldIndex, newIndex) {
                          setModalState(() {
                            if (newIndex > oldIndex) newIndex -= 1;
                            final item = ordered.removeAt(oldIndex);
                            ordered.insert(newIndex, item);
                          });
                        },
                        itemBuilder: (context, index) {
                          final key = ordered[index];
                          return CheckboxListTile(
                            key: ValueKey(key),
                            value: selected.contains(key),
                            title: Text(DashboardWidgetKeys.labelOf(key, sheetL10n)),
                            secondary: const Icon(Icons.drag_handle),
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
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            final keys = ordered.where(selected.contains).toList();
                            Navigator.pop(ctx, keys);
                          },
                          child: Text(sheetL10n.apply),
                        ),
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
    await ref.read(appPreferencesProvider.notifier).updateTabWidgets(tab.id, saved);
  }

  Future<void> _addCustomTab(BuildContext context, WidgetRef ref) async {
    final created = await showDialog<DashboardTabConfig>(
      context: context,
      builder: (ctx) => const _CreateDashboardTabDialog(),
    );
    if (created == null) return;
    await ref.read(appPreferencesProvider.notifier).addCustomDashboardTab(created);
  }

  Future<void> _confirmReset(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.resetDashboardQuestion),
        content: const Text(
          'Allround, Turnier und Minimal werden wiederhergestellt. Eigene Tabs gehen verloren.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.reset),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(appPreferencesProvider.notifier).resetDashboardTabsToDefault();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final tabs = ref.watch(appPreferencesProvider).dashboardTabs;
    final notifier = ref.read(appPreferencesProvider.notifier);
    final enabledCount = tabs.where((tab) => tab.isEnabled).length;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dashboardConfigTitle),
        actions: [
          IconButton(
            tooltip: l10n.customDashboard,
            icon: const Icon(Icons.add),
            onPressed: () => _addCustomTab(context, ref),
          ),
          PopupMenuButton<String>(
            tooltip: 'Weitere Aktionen',
            onSelected: (value) {
              if (value == 'reset') _confirmReset(context, ref);
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'reset',
                child: Text(l10n.resetToDefault),
              ),
            ],
          ),
        ],
      ),
      body: ReorderableListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
        itemCount: tabs.length,
        onReorder: (oldIndex, newIndex) {
          notifier.reorderDashboardTabs(oldIndex, newIndex);
        },
        itemBuilder: (context, index) {
          final tab = tabs[index];
          return Card(
            key: ValueKey(tab.id),
            margin: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _editTabWidgets(context, ref, tab),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
                child: Column(
                  children: [
                    SwitchListTile(
                      value: tab.isEnabled,
                      secondary: CircleAvatar(
                        backgroundColor: scheme.primary.withValues(alpha: 0.16),
                        child: Icon(dashboardTabIcon(tab.iconName), color: scheme.primary),
                      ),
                      title: Text(
                        tab.localizedTitle(l10n),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(
                        tab.isPreset ? 'Standard-Tab' : l10n.customDashboard,
                      ),
                      onChanged: (enabled) {
                        if (!enabled && enabledCount <= 1) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.atLeastOneTab)),
                          );
                          return;
                        }
                        notifier.toggleDashboardTab(tab.id, enabled);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: DropdownButtonFormField<String>(
                        key: ValueKey('tab-tag-${tab.id}-${tab.selectedTag}'),
                        initialValue: tab.selectedTag ?? '__all__',
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: l10n.focusEventTag,
                          border: const OutlineInputBorder(),
                          isDense: true,
                        ),
                        items: [
                          DropdownMenuItem(value: '__all__', child: Text(l10n.allEvents)),
                          for (final tag in {
                            ...ref.watch(appPreferencesProvider).allAvailableTags,
                            if (tab.selectedTag != null) tab.selectedTag!,
                          })
                            DropdownMenuItem(value: tag, child: Text(tag)),
                        ],
                        onChanged: (value) {
                          notifier.setDashboardTabSelectedTag(
                            tab.id,
                            value == '__all__' ? null : value,
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 8, 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              tab.sanitizedWidgetKeys
                                  .map((key) => DashboardWidgetKeys.labelOf(key, l10n))
                                  .join(' • '),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: scheme.onSurface.withValues(alpha: 0.65),
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: l10n.edit,
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () => _editTabWidgets(context, ref, tab),
                          ),
                          if (!tab.isPreset)
                            IconButton(
                              tooltip: l10n.delete,
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                              onPressed: () => notifier.deleteDashboardTab(tab.id),
                            ),
                          const Icon(Icons.drag_handle),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CreateDashboardTabDialog extends ConsumerStatefulWidget {
  const _CreateDashboardTabDialog();

  @override
  ConsumerState<_CreateDashboardTabDialog> createState() => _CreateDashboardTabDialogState();
}

class _CreateDashboardTabDialogState extends ConsumerState<_CreateDashboardTabDialog> {
  final _titleController = TextEditingController();
  String _iconName = 'tune_outlined';
  String? _selectedTag;
  final Set<String> _selectedWidgets = {DashboardWidgetKeys.kpiWinrate};

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.customDashboard),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: l10n.tabTitle,
                  hintText: 'z. B. Locals',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Text(l10n.icon, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final iconName in DashboardTabConfig.iconChoices)
                    IconButton.filledTonal(
                      onPressed: () => setState(() => _iconName = iconName),
                      style: IconButton.styleFrom(
                        backgroundColor: _iconName == iconName
                            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.35)
                            : null,
                      ),
                      icon: Icon(dashboardTabIcon(iconName)),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                key: ValueKey('new-tab-tag-$_selectedTag'),
                initialValue: _selectedTag ?? '__all__',
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: l10n.focusEventTagOptional,
                  border: const OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(value: '__all__', child: Text(l10n.allEvents)),
                  for (final tag in ref.watch(appPreferencesProvider).allAvailableTags)
                    DropdownMenuItem(value: tag, child: Text(tag)),
                ],
                onChanged: (value) => setState(() {
                  _selectedTag = value == '__all__' ? null : value;
                }),
              ),
              const SizedBox(height: 16),
              Text(l10n.startTiles, style: const TextStyle(fontWeight: FontWeight.w600)),
              for (final key in DashboardWidgetKeys.all)
                CheckboxListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  value: _selectedWidgets.contains(key),
                  title: Text(DashboardWidgetKeys.labelOf(key, l10n)),
                  onChanged: (checked) {
                    setState(() {
                      if (checked == true) {
                        _selectedWidgets.add(key);
                      } else if (_selectedWidgets.length > 1) {
                        _selectedWidgets.remove(key);
                      }
                    });
                  },
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
        FilledButton(
          onPressed: () {
            final title = _titleController.text.trim();
            if (title.isEmpty) return;
            Navigator.pop(
              context,
              DashboardTabConfig(
                id: 'tab_${DateTime.now().millisecondsSinceEpoch}',
                title: title,
                iconName: _iconName,
                widgetKeys: DashboardWidgetKeys.all
                    .where(_selectedWidgets.contains)
                    .toList(),
                selectedTag: _selectedTag,
              ),
            );
          },
          child: Text(l10n.create),
        ),
      ],
    );
  }
}
