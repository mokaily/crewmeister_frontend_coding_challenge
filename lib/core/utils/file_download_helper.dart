import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class FileDownloadHelper {
  /// Downloads or shares a file depending on the platform
  static Future<void> downloadFile(
    String content,
    String fileName, {
    String mimeType = 'text/calendar',
  }) async {
    if (kIsWeb) {
      // Web platform - direct download
      _downloadFileWeb(content, fileName, mimeType);
    } else {
      // Mobile/Desktop - save and share
      await _saveAndShareFile(content, fileName, mimeType);
    }
  }

  /// Downloads file on web platform
  static void _downloadFileWeb(
    String content,
    String fileName,
    String mimeType,
  ) {
    final bytes = utf8.encode(content);
    final blob = html.Blob([bytes], mimeType);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', fileName)
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  /// Saves file to temporary directory and shares it on mobile/desktop
  static Future<void> _saveAndShareFile(
    String content,
    String fileName,
    String mimeType,
  ) async {
    try {
      // Get temporary directory
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/$fileName';

      // Write file
      final file = File(filePath);
      await file.writeAsString(content, encoding: utf8);

      // Share file using share_plus
      final result = await Share.shareXFiles(
        [XFile(filePath, mimeType: mimeType)],
        subject: 'Calendar Event',
        text: 'Import this event to your calendar',
      );

      // Clean up file after sharing (optional, but good practice)
      if (result.status == ShareResultStatus.success) {
        // File shared successfully
        // You can delete the file after a delay if needed
        Future.delayed(const Duration(seconds: 5), () {
          if (file.existsSync()) {
            file.delete();
          }
        });
      }
    } catch (e) {
      throw Exception('Failed to save and share file: $e');
    }
  }
}
