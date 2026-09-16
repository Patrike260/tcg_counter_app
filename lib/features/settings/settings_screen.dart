import 'dart:convert';
import 'dart:typed_data'; 
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/supabase_constants.dart';
import '../auth/auth_repository.dart';
import 'backup_service.dart';

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
    // In file_picker v13+ wird pickFiles direkt auf der Klasse aufgerufen
    // und gibt eine List<PlatformFile>? zurück
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

              // Daten & Backup
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
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Konto & Info
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