import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/l10n.dart';
import 'app_preferences_service.dart';

class TagManagementScreen extends ConsumerWidget {
  const TagManagementScreen({super.key});

  void _showAddTagDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.createTagTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            labelText: l10n.tagNameHint,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                ref.read(appPreferencesProvider.notifier).addCustomTag(text);
              }
              Navigator.pop(ctx);
            },
            child: Text(l10n.add),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final prefs = ref.watch(appPreferencesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.manageTagsScreenTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Standard-Tags
          Text(
            l10n.standardTagsHeader,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: AppPreferencesState.defaultBaseTags
                  .map(
                    (tag) => ListTile(
                      leading: const Icon(Icons.lock_outline, size: 20, color: Colors.grey),
                      title: Text(tag),
                      subtitle: Text(l10n.systemTagSubtitle),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 24),

          // Eigene Tags
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.customTagsHeader,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              TextButton.icon(
                onPressed: () => _showAddTagDialog(context, ref),
                icon: const Icon(Icons.add),
                label: Text(l10n.createTag),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Card(
            child: prefs.customTags.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: Text(l10n.noCustomTags),
                    ),
                  )
                : Column(
                    children: prefs.customTags
                        .map(
                          (tag) => ListTile(
                            leading: const Icon(Icons.label_outline, color: Colors.deepPurpleAccent),
                            title: Text(tag),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                              onPressed: () {
                                ref.read(appPreferencesProvider.notifier).removeCustomTag(tag);
                              },
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
