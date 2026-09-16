import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/supabase_constants.dart';
import '../../core/theme/app_theme_presets.dart';
import '../auth/auth_repository.dart';
import '../decks/deck_repository.dart';
import 'app_preferences_service.dart';
import 'archetype_management_screen.dart';
import 'backup_service.dart';
import 'game_management_screen.dart';
import 'game_visibility_screen.dart';
import 'match_preferences_screen.dart';
import 'tag_management_screen.dart';
import 'theme_selection_screen.dart';
import 'tool_presets_screen.dart';
import '../tournaments/tournament_list_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isProcessing = false;

  Future<void> _exportCsv() async {
    setState(() => _isProcessing = true);
    try {
      await ref.read(backupServiceProvider).exportMatchesAsCsv();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Matches als CSV exportiert!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim CSV-Export: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _exportJson() async {
    setState(() => _isProcessing = true);
    try {
      await ref.read(backupServiceProvider).exportFullBackup();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('JSON-Backup erfolgreich generiert!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Backup-Export: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _restoreJson() async {
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (files == null || files.isEmpty) return;

    final Uint8List bytes;
    try {
      bytes = await files.first.readAsBytes();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Datei konnte nicht gelesen werden.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Backup einspielen?'),
        content: const Text(
          'Vorhandene Decks und Matches werden zusammengeführt bzw. aktualisiert.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Wiederherstellen'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isProcessing = true);
    try {
      final jsonString = utf8.decode(bytes);
      final count = await ref.read(backupServiceProvider).restoreBackupFromJson(jsonString);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$count Matches erfolgreich wiederhergestellt!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Wiederherstellung fehlgeschlagen: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _open(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;
    final prefs = ref.watch(appPreferencesProvider);
    final gamesAsync = ref.watch(gamesListProvider);

    final gameName = gamesAsync.maybeWhen(
      data: (games) {
        for (final game in games) {
          if (game.id == prefs.resolvedDefaultGameId) return game.name;
        }
        return null;
      },
      orElse: () => null,
    );
    final summary = [
      gameName ?? 'Kein TCG',
      prefs.defaultFormatLabel,
      prefs.defaultTurnOrderLabel,
    ].join(' • ');

    return Scaffold(
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(user?.email ?? 'Kein Nutzer eingeloggt'),
                  subtitle: Text(
                    user != null && user.id.length >= 8
                        ? 'ID: ${user.id.substring(0, 8)}...'
                        : '',
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'ERSCHEINUNGSBILD',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              _SettingsGroup(
                children: [
                  _SettingsNavTile(
                    icon: Icons.palette_outlined,
                    iconColor: Theme.of(context).colorScheme.primary,
                    title: 'Farbschema & Design-Presets',
                    subtitle: getThemeTitle(prefs.themePreset),
                    onTap: () => _open(const ThemeSelectionScreen()),
                    showDivider: false,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'EINSTELLUNGEN',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              _SettingsGroup(
                children: [
                  _SettingsNavTile(
                    icon: Icons.tune_outlined,
                    iconColor: Colors.deepPurpleAccent,
                    title: 'Match- & Standardeinstellungen',
                    subtitle: summary,
                    onTap: () => _open(const MatchPreferencesScreen()),
                  ),
                  _SettingsNavTile(
                    icon: Icons.visibility_outlined,
                    iconColor: Colors.tealAccent,
                    title: 'Sichtbare TCGs anpassen',
                    subtitle: 'Unerwünschte Kartenspiele in Dropdowns ausblenden',
                    onTap: () => _open(const GameVisibilityScreen()),
                  ),
                  _SettingsNavTile(
                    icon: Icons.sports_esports_outlined,
                    iconColor: Colors.lightBlueAccent,
                    title: 'Kartenspiele (TCGs) verwalten',
                    subtitle: 'Spiele hinzufügen oder umbenennen',
                    onTap: () => _open(const GameManagementScreen()),
                  ),
                  _SettingsNavTile(
                    icon: Icons.calculate_outlined,
                    iconColor: Colors.amber,
                    title: 'Tool-Presets verwalten',
                    subtitle: 'Life Counter, Spieleranzahl und Timer anpassen',
                    onTap: () => _open(const ToolPresetsScreen()),
                    showDivider: false,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'VERWALTUNG & INHALTE',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              _SettingsGroup(
                children: [
                  _SettingsNavTile(
                    icon: Icons.emoji_events_outlined,
                    iconColor: Colors.amber,
                    title: 'Turniere & Events',
                    subtitle: 'Platzierungen und gespielte Decks festhalten',
                    onTap: () => _open(const TournamentListScreen()),
                  ),
                  _SettingsNavTile(
                    icon: Icons.category_outlined,
                    iconColor: Colors.purpleAccent,
                    title: 'Gegner-Archetypen verwalten',
                    subtitle: 'Gespeicherte Vorschläge umbenennen oder bereinigen',
                    onTap: () => _open(const ArchetypeManagementScreen()),
                  ),
                  _SettingsNavTile(
                    icon: Icons.label_outlined,
                    iconColor: const Color(0xFFCE93D8),
                    title: 'Event-Tags verwalten',
                    subtitle: 'Eigene Tags für Turniere oder Cups erstellen',
                    onTap: () => _open(const TagManagementScreen()),
                    showDivider: false,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'DATEN & BACKUP',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              _SettingsGroup(
                children: [
                  _SettingsNavTile(
                    icon: Icons.table_chart_outlined,
                    iconColor: Colors.greenAccent,
                    title: 'Matches als CSV exportieren',
                    subtitle: 'Ideal für Excel oder Tabellenkalkulation',
                    onTap: _isProcessing ? null : _exportCsv,
                  ),
                  _SettingsNavTile(
                    icon: Icons.file_download_outlined,
                    iconColor: Colors.blueAccent,
                    title: 'Vollständiges Backup sichern (JSON)',
                    subtitle: 'Sichert alle Decks & Match-Historien',
                    onTap: _isProcessing ? null : _exportJson,
                  ),
                  _SettingsNavTile(
                    icon: Icons.file_upload_outlined,
                    iconColor: Colors.orangeAccent,
                    title: 'Backup wiederherstellen',
                    subtitle: 'JSON-Sicherungsdatei einlesen',
                    onTap: _isProcessing ? null : _restoreJson,
                    showDivider: false,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'KONTO & INFO',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              _SettingsGroup(
                children: [
                  const _SettingsNavTile(
                    icon: Icons.info_outline,
                    iconColor: Colors.white70,
                    title: 'Version',
                    subtitle: 'Web / PWA',
                    trailing: Text('1.0.0'),
                    showDivider: true,
                  ),
                  _SettingsNavTile(
                    icon: Icons.logout,
                    iconColor: Colors.redAccent,
                    title: 'Abmelden',
                    subtitle: 'Sitzung beenden',
                    titleColor: Colors.redAccent,
                    showChevron: false,
                    showDivider: false,
                    onTap: () => ref.read(authRepositoryProvider).signOut(),
                  ),
                ],
              ),
            ],
          ),
          if (_isProcessing)
            Container(
              color: Colors.black45,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;

  const _SettingsGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(children: children),
    );
  }
}

class _SettingsNavTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? titleColor;
  final bool showChevron;
  final bool showDivider;

  const _SettingsNavTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.trailing,
    this.titleColor,
    this.showChevron = true,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor),
          ),
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w600, color: titleColor),
          ),
          subtitle: Text(subtitle),
          trailing: trailing ??
              (showChevron ? const Icon(Icons.chevron_right) : null),
        ),
        if (showDivider) const Divider(height: 1, indent: 72),
      ],
    );
  }
}
