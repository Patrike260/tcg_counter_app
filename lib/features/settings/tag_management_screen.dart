import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_preferences_service.dart';

class TagManagementScreen extends ConsumerWidget {
  const TagManagementScreen({super.key});

  void _showAddTagDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Neuen Tag erstellen'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Tag-Name (z. B. Store Cup, League)',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                ref.read(appPreferencesProvider.notifier).addCustomTag(text);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Hinzufügen'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(appPreferencesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event-Tags verwalten'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Standard-Tags
          const Text(
            'STANDARD-TAGS (FEST VORGEGEBEN)',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: AppPreferencesState.defaultBaseTags
                  .map(
                    (tag) => ListTile(
                      leading: const Icon(Icons.lock_outline, size: 20, color: Colors.grey),
                      title: Text(tag),
                      subtitle: const Text('System-Tag (kann nicht gelöscht werden)'),
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
              const Text(
                'BENUTZERDEFINIERTE TAGS',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              TextButton.icon(
                onPressed: () => _showAddTagDialog(context, ref),
                icon: const Icon(Icons.add),
                label: const Text('Tag erstellen'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Card(
            child: prefs.customTags.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: Text('Noch keine eigenen Tags angelegt.'),
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