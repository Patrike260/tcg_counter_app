import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../matches/deck_detail_screen.dart';
import 'add_deck_dialog.dart';
import 'deck_repository.dart';

class DeckListScreen extends ConsumerWidget {
  const DeckListScreen({super.key});

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
                  trailing: const Icon(Icons.chevron_right),
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