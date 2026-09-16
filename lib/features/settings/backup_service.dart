import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/supabase_constants.dart';
import '../../core/utils/file_export_helper.dart';
import '../decks/deck_repository.dart';
import '../stats/dashboard_repository.dart';

final backupServiceProvider = Provider<BackupService>((ref) {
  return BackupService(ref);
});

class BackupService {
  final Ref _ref;
  BackupService(this._ref);

  // 1. Matches als tabellarisches CSV exportieren
  Future<void> exportMatchesAsCsv() async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('Nicht eingeloggt');

    final response = await supabase
        .from('matches')
        .select('*, decks(name, games(name))')
        .order('created_at', ascending: false);

    final matches = response as List;
    final buffer = StringBuffer();

    // CSV Header
    buffer.writeln('Datum,Spiel,Mein Deck,Gegner Deck,Ergebnis,Format,Turn Order,Score,Tags,Notizen');

    for (final row in matches) {
      final date = row['created_at']?.toString().split('T').first ?? '';
      final game = (row['decks']?['games']?['name'] ?? '').replaceAll('"', '""');
      final deck = (row['decks']?['name'] ?? '').replaceAll('"', '""');
      final opp = (row['opponent_deck'] ?? '').replaceAll('"', '""');
      final result = row['result'] ?? '';
      final format = (row['match_format'] ?? '').toString().toUpperCase();
      final turn = row['turn_order'] ?? '';
      final score = row['score'] ?? '';
      final tags = (row['tags'] as List?)?.join(';') ?? '';
      final notes = (row['notes'] ?? '').toString().replaceAll('"', '""').replaceAll('\n', ' ');

      buffer.writeln('"$date","$game","$deck","$opp","$result","$format","$turn","$score","$tags","$notes"');
    }

    final dateStr = DateTime.now().toIso8601String().split('T').first;
    await FileExportHelper.exportString(
      content: buffer.toString(),
      fileName: 'tcg_matches_$dateStr.csv',
      mimeType: 'text/csv',
    );
  }

  // 2. Vollständiges JSON-Backup erstellen
  Future<void> exportFullBackup() async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('Nicht eingeloggt');

    final decksRes = await supabase.from('decks').select().eq('user_id', user.id);
    final matchesRes = await supabase.from('matches').select().eq('user_id', user.id);

    final backupData = {
      'version': 1,
      'exported_at': DateTime.now().toIso8601String(),
      'user_id': user.id,
      'decks': decksRes,
      'matches': matchesRes,
    };

    final jsonStr = const JsonEncoder.withIndent('  ').convert(backupData);
    final dateStr = DateTime.now().toIso8601String().split('T').first;

    await FileExportHelper.exportString(
      content: jsonStr,
      fileName: 'tcg_counter_backup_$dateStr.json',
      mimeType: 'application/json',
    );
  }

  // 3. JSON-Backup wiederherstellen (Upsert)
  Future<int> restoreBackupFromJson(String jsonContent) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('Nicht eingeloggt');

    final Map<String, dynamic> data = jsonDecode(jsonContent);
    final List decks = data['decks'] as List? ?? [];
    final List matches = data['matches'] as List? ?? [];

    // Decks wiederherstellen
    for (final raw in decks) {
      final deckMap = Map<String, dynamic>.from(raw as Map);
      deckMap['user_id'] = user.id; // An aktuellen Nutzer binden
      await supabase.from('decks').upsert(deckMap);
    }

    // Matches wiederherstellen
    for (final raw in matches) {
      final matchMap = Map<String, dynamic>.from(raw as Map);
      matchMap['user_id'] = user.id;
      await supabase.from('matches').upsert(matchMap);
    }

    // UI-Caches invalidieren
    _ref.invalidate(userDecksProvider);
    _ref.invalidate(dashboardDataProvider);

    return matches.length;
  }
}