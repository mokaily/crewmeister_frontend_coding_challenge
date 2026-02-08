import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:open_filex/open_filex.dart';

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
      // Check if Android on non-web platforms
      if (!kIsWeb && Platform.isAndroid) {
        // Android - save to Downloads folder
        await _saveToDownloadsAndroid(content, fileName);
      } else {
        // iOS/Desktop - save and open in calendar app
        await _saveAndOpenFile(content, fileName, mimeType);
      }
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

  /// Saves file to Downloads folder on Android
  static Future<void> _saveToDownloadsAndroid(
    String content,
    String fileName,
  ) async {
    try {
      // Get the Downloads directory
      Directory? downloadsDir;

      // Try to get external storage directory (Downloads)
      final externalDir = await getExternalStorageDirectory();
      if (externalDir != null) {
        // Navigate to Downloads folder
        // External storage path is usually: /storage/emulated/0/Android/data/package/files
        // We want: /storage/emulated/0/Download
        final pathParts = externalDir.path.split('/');
        final basePath = pathParts
            .sublist(0, 4)
            .join('/'); // /storage/emulated/0
        downloadsDir = Directory('$basePath/Download');

        // Create Downloads directory if it doesn't exist
        if (!await downloadsDir.exists()) {
          downloadsDir = Directory('$basePath/Downloads');
          if (!await downloadsDir.exists()) {
            // Fallback to app's external directory
            downloadsDir = externalDir;
          }
        }
      }

      if (downloadsDir == null) {
        // Fallback to iOS method if we can't access Downloads
        await _saveAndOpenFile(content, fileName, 'text/calendar');
        return;
      }

      // Write file to Downloads
      final filePath = '${downloadsDir.path}/$fileName';
      final file = File(filePath);
      await file.writeAsString(content, encoding: utf8);

      // Open file with default calendar app (Outlook, Google Calendar, etc.)
      await OpenFilex.open(filePath, type: 'text/calendar');
    } catch (e) {
      // Fallback to iOS method if saving fails
      await _saveAndOpenFile(content, fileName, 'text/calendar');
    }
  }

  /// Saves file and opens it with default calendar app on iOS/Desktop
  static Future<void> _saveAndOpenFile(
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

      // Open file with default calendar app
      final result = await OpenFilex.open(filePath, type: mimeType);

      // If opening fails, fallback to share
      if (result.type != ResultType.done) {
        await Share.shareXFiles(
          [XFile(filePath, mimeType: mimeType)],
          subject: 'Calendar Event',
          text: 'Import this event to your calendar',
        );
      }
    } catch (e) {
      throw Exception('Failed to save and open file: $e');
    }
  }
}
