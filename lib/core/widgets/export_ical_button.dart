import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/absences/domain/entities/absence.dart';
import '../../features/absences/domain/entities/member.dart';
import '../bloc/screen_size/screen_size_cubit.dart';
import '../utils/ical_exporter.dart';
import '../utils/file_download_helper.dart';

class ExportICalButton extends StatelessWidget {
  final Absence absence;
  final Member? member;

  const ExportICalButton({super.key, required this.absence, required this.member});

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
    return BlocBuilder<ScreenSizeCubit, ScreenSizeState>(
      builder: (context, state) {
        if (!state.isMobile) {
          return IconButton(
            onPressed: () {
              _exportToICal(context);
            },
            icon: Icon(Icons.download, color: Colors.grey),
          );
        } else {
          return TextButton.icon(
            onPressed: () => _exportToICal(context),
            icon: const Icon(Icons.calendar_month, size: 14, color: Colors.blue),
            label: const Text('ADD TO CALENDER', style: TextStyle(color: Colors.blue, fontSize: 12)),
            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
          );
        }
      },
    );
  }
}
