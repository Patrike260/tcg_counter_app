import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../matches/deck_detail_screen.dart';
import 'add_deck_dialog.dart';
import 'deck_model.dart';
import 'deck_repository.dart';

class DeckListScreen extends ConsumerWidget {
  const DeckListScreen({super.key});

  void _showDeleteDialog(BuildContext context, WidgetRef ref, Deck deck) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Deck wirklich löschen?'),
        content: Text('Das Deck "${deck.name}" und ALLE dazugehörigen Matches werden unwiderruflich gelöscht!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.of(ctx).pop();
              await ref.read(deckRepositoryProvider).deleteDeck(deck.id);
              ref.invalidate(userDecksProvider);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Deck "${deck.name}" gelöscht.')),
                );
              }
            },
            child: const Text('Löschen'),
          ),
        ],
      ),
    );
  }

  void _archiveDeck(BuildContext context, WidgetRef ref, Deck deck) async {
    await ref.read(deckRepositoryProvider).archiveDeck(deck.id);
    ref.invalidate(userDecksProvider);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Deck "${deck.name}" archiviert.')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decksAsync = ref.watch(userDecksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meine Decks'),
      ),
      body: decksAsync.when(
        data: (decks) {
          if (decks.isEmpty) {
            return const Center(
              child: Text(
                'Noch keine Decks angelegt.\nTippe unten rechts auf +, um dein erstes Deck zu erstellen!',
                textAlign: TextAlign.center,
              ),
            );
          }
          return ListView.builder(
            itemCount: decks.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final deck = decks[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      deck.gameName != null && deck.gameName!.isNotEmpty
                          ? deck.gameName![0]
                          : '?',
                    ),
                  ),
                  title: Text(
                    deck.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${deck.gameName ?? "Unbekannt"}${deck.notes != null ? " • ${deck.notes}" : ""}',
                  ),
                  trailing: PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          showDialog(
                            context: context,
                            builder: (_) => AddDeckDialog(deck: deck),
                          );
                          break;
                        case 'archive':
                          _archiveDeck(context, ref, deck);
                          break;
                        case 'delete':
                          _showDeleteDialog(context, ref, deck);
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text('Bearbeiten'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'archive',
                        child: Row(
                          children: [
                            Icon(Icons.archive_outlined, size: 20),
                            SizedBox(width: 8),
                            Text('Archivieren'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, size: 20, color: Colors.redAccent),
                            SizedBox(width: 8),
                            Text('Löschen', style: TextStyle(color: Colors.redAccent)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => DeckDetailScreen(deck: deck),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Fehler: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const AddDeckDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}