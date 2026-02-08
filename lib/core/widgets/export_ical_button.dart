import 'package:flutter/material.dart';
import '../../features/absences/domain/entities/absence.dart';
import '../../features/absences/domain/entities/member.dart';
import '../utils/ical_exporter.dart';
import '../utils/file_download_helper.dart';

class ExportICalButton extends StatelessWidget {
  final Absence absence;
  final Member? member;
  final bool isIconButton;

  const ExportICalButton({
    super.key,
    required this.absence,
    required this.member,
    this.isIconButton = false,
  });

  Future<void> _exportToICal(BuildContext context) async {
    try {
      // Generate iCal content
      final icalContent = ICalExporter.generateICalContent(absence, member);
      final fileName = ICalExporter.generateFileName(absence, member);

      // Download/share file
      await FileDownloadHelper.downloadFile(icalContent, fileName);

      // Show success message with action button
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Calendar event exported: $fileName'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'OPEN',
              textColor: Colors.white,
              onPressed: () async {
                // Re-trigger download/share when user clicks OPEN
                await FileDownloadHelper.downloadFile(icalContent, fileName);
              },
            ),
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to export calendar event: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isIconButton) {
      return IconButton(
        icon: const Icon(Icons.calendar_today),
        tooltip: 'Export to Calendar',
        onPressed: () => _exportToICal(context),
      );
    }

    return OutlinedButton.icon(
      onPressed: () => _exportToICal(context),
      icon: const Icon(Icons.calendar_today, size: 18),
      label: const Text('Export to Calendar'),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}
