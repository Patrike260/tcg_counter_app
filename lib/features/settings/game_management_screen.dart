import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/supabase_constants.dart';
import '../../core/widgets/game_logo.dart';
import '../../l10n/l10n.dart';
import '../decks/deck_model.dart';
import '../decks/deck_repository.dart';

class GameManagementScreen extends ConsumerStatefulWidget {
  const GameManagementScreen({super.key});

  @override
  ConsumerState<GameManagementScreen> createState() => _GameManagementScreenState();
}

class _GameManagementScreenState extends ConsumerState<GameManagementScreen> {
  void _showAddGameDialog() {
    final controller = TextEditingController();
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.addTcgTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            labelText: l10n.gameNameLabel,
            hintText: 'z. B. Weiß Schwarz',
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
          ElevatedButton(
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                final user = supabase.auth.currentUser;
                await supabase.from('games').insert({
                  'name': name,
                  'is_custom': true,
                  'created_by': user?.id,
                });
                ref.invalidate(gamesListProvider);
                if (mounted) Navigator.pop(ctx);
              }
            },
            child: Text(l10n.add),
          ),
        ],
      ),
    );
  }

  void _showRenameDialog(Game game) {
    final controller = TextEditingController(text: game.name);
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.renameTcgTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: l10n.newName, border: const OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
          ElevatedButton(
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isNotEmpty && name != game.name) {
                await supabase.from('games').update({'name': name}).eq('id', game.id);
                ref.invalidate(gamesListProvider);
                if (mounted) Navigator.pop(ctx);
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final gamesAsync = ref.watch(gamesListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.manageTcgsScreenTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: l10n.addTcgTitle,
            onPressed: _showAddGameDialog,
          ),
        ],
      ),
      body: gamesAsync.when(
        data: (games) => ListView.separated(
          itemCount: games.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final game = games[index];
            return ListTile(
              leading: GameLogo(gameName: game.name, size: 36),
              title: Text(game.name, style: const TextStyle(fontWeight: FontWeight.w600)),
              trailing: IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20),
                onPressed: () => _showRenameDialog(game),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text(l10n.loadErrorWithDetails(err))),
      ),
    );
  }
}
