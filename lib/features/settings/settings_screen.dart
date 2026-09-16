import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/supabase_constants.dart';
import '../../core/widgets/game_logo.dart';
import '../auth/auth_repository.dart';
import '../decks/deck_repository.dart';
import 'app_preferences_service.dart';
import 'archetype_management_screen.dart';
import 'backup_service.dart';
import 'tag_management_screen.dart';
import 'game_management_screen.dart';
import 'game_visibility_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;
    final prefs = ref.watch(appPreferencesProvider);
    final gamesAsync = ref.watch(gamesListProvider);

    return Scaffold(
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Benutzer-Info Card
              Card(
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

              // STANDARDEINSTELLUNGEN
              const Text(
                'STANDARDEINSTELLUNGEN (VORAUSWAHL)',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      // Standard-TCG
                      gamesAsync.when(
                        data: (games) {
                          final visibleGames =
                              games.where((g) => prefs.isGameVisible(g.id)).toList();
                          final selectedId = visibleGames.any((g) => g.id == prefs.resolvedDefaultGameId)
                              ? prefs.resolvedDefaultGameId
                              : null;
                          return DropdownButtonFormField<String?>(
                            value: selectedId,
                            decoration: const InputDecoration(
                              labelText: 'Standard-Kartenspiel',
                              helperText: 'Wird beim Anlegen neuer Decks vorausgewählt',
                            ),
                            items: [
                              const DropdownMenuItem(
                                value: null,
                                child: Text('Keines (Immer manuell wählen)'),
                              ),
                              ...visibleGames.map((g) => DropdownMenuItem(
                                    value: g.id,
                                    child: Row(
                                      children: [
                                        GameLogo(gameName: g.name, size: 20),
                                        const SizedBox(width: 8),
                                        Text(g.name),
                                      ],
                                    ),
                                  )),
                            ],
                            onChanged: (val) {
                              ref.read(appPreferencesProvider.notifier).setDefaultGameId(val);
                            },
                          );
                        },
                        loading: () => const LinearProgressIndicator(),
                        error: (_, _) => const SizedBox.shrink(),
                      ),
                      const SizedBox(height: 12),

                      // Standard-Format
                      DropdownButtonFormField<String>(
                        value: prefs.defaultFormat,
                        decoration: const InputDecoration(
                          labelText: 'Standard Match-Format',
                        ),
                        items: const [
                          DropdownMenuItem(value: 'bo1', child: Text('Best of 1 (BO1)')),
                          DropdownMenuItem(value: 'bo3', child: Text('Best of 3 (BO3)')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            ref.read(appPreferencesProvider.notifier).setDefaultFormat(val);
                          }
                        },
                      ),
                      const SizedBox(height: 12),

                      // Standard-Zugreihenfolge
                      DropdownButtonFormField<String>(
                        value: prefs.defaultTurnOrder,
                        decoration: const InputDecoration(
                          labelText: 'Standard Zugreihenfolge',
                        ),
                        items: const [
                          DropdownMenuItem(value: 'none', child: Text('Keine Vorgabe (Optional)')),
                          DropdownMenuItem(value: 'first', child: Text('1st (Immer Beginn)')),
                          DropdownMenuItem(value: 'second', child: Text('2nd (Immer Zweiter)')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            ref.read(appPreferencesProvider.notifier).setDefaultTurnOrder(val);
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      const Divider(),

                      // Switch: Zuletzt genutzte Tags merken
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Zuletzt gewählte Tags merken'),
                        subtitle: const Text('Setzt die Tags des letzten Matches automatisch ein'),
                        value: prefs.rememberLastTags,
                        onChanged: (val) {
                          ref.read(appPreferencesProvider.notifier).setRememberLastTags(val);
                        },
                      ),

                      // Button: Tags verwalten
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.label_outlined, color: Colors.deepPurpleAccent),
                        title: const Text('Event-Tags verwalten'),
                        subtitle: const Text('Eigene Tags für Turniere oder Cups erstellen'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const TagManagementScreen()),
                          );
                        },
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.visibility_outlined, color: Colors.tealAccent),
                        title: const Text('Sichtbare TCGs anpassen'),
                        subtitle: const Text('Unerwünschte Kartenspiele in Dropdowns ausblenden'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const GameVisibilityScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // DATEN & BACKUP
              const Text(
                'DATEN & BACKUP',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.table_chart_outlined, color: Colors.greenAccent),
                      title: const Text('Matches als CSV exportieren'),
                      subtitle: const Text('Ideal für Excel oder Tabellenkalkulation'),
                      onTap: _isProcessing ? null : _exportCsv,
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.file_download_outlined, color: Colors.blueAccent),
                      title: const Text('Vollständiges Backup sichern (JSON)'),
                      subtitle: const Text('Sichert alle Decks & Match-Historien'),
                      onTap: _isProcessing ? null : _exportJson,
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.file_upload_outlined, color: Colors.orangeAccent),
                      title: const Text('Backup wiederherstellen'),
                      subtitle: const Text('JSON-Sicherungsdatei einlesen'),
                      onTap: _isProcessing ? null : _restoreJson,
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.category_outlined, color: Colors.purpleAccent),
                      title: const Text('Gegner-Archetypen verwalten'),
                      subtitle: const Text('Gespeicherte Vorschläge umbenennen oder bereinigen'),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ArchetypeManagementScreen(),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.sports_esports_outlined, color: Colors.tealAccent),
                      title: const Text('Kartenspiele (TCGs) verwalten'),
                      subtitle: const Text('Spiele hinzufügen oder umbenennen'),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const GameManagementScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // KONTO & INFO
              const Text(
                'KONTO & INFO',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    const ListTile(
                      leading: Icon(Icons.info_outline),
                      title: Text('Version'),
                      trailing: Text('1.0.0 (Web/PWA)'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.redAccent),
                      title: const Text(
                        'Abmelden',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                      onTap: () => ref.read(authRepositoryProvider).signOut(),
                    ),
                  ],
                ),
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