import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';

class FileExportHelper {
  static Future<void> exportString({
    required String content,
    required String fileName,
    required String mimeType,
  }) async {
    final bytes = utf8.encode(content);

    if (kIsWeb) {
      // Im Web: Native Download-Aktion über XFile
      final xFile = XFile.fromData(
        Uint8List.fromList(bytes),
        mimeType: mimeType,
        name: fileName,
      );
      await xFile.saveTo(fileName);
    } else {
      // Auf Android/iOS: Nativer Datei-Teilen-Dialog
      final xFile = XFile.fromData(
        Uint8List.fromList(bytes),
        mimeType: mimeType,
        name: fileName,
      );
      await Share.shareXFiles([xFile], text: fileName);
    }
  }
}