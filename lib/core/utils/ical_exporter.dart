import 'package:intl/intl.dart';
import '../../features/absences/domain/entities/absence.dart';
import '../../features/absences/domain/entities/member.dart';

class ICalExporter {
  /// Generates iCal (.ics) file content from an Absence
  static String generateICalContent(Absence absence, Member? member) {
    final now = DateTime.now().toUtc();
    final startDate = absence.startDate.toUtc();
    final endDate = absence.endDate.toUtc();

    // Format dates for iCal (YYYYMMDD for all-day events)
    final dtStart = _formatICalDateOnly(startDate);
    final dtEnd = _formatICalDateOnly(
      endDate.add(Duration(days: 1)),
    ); // End date is exclusive
    final dtStamp = _formatICalDateTime(now);
    final uid =
        'absence-${absence.id}-${now.millisecondsSinceEpoch}@crewmeister.app';

    // Build title: "Member Name - Vacation Type - Status"
    final memberName = member?.name ?? 'Unknown Member';
    final vacationType = _capitalizeFirst(absence.type);
    final status = absence.status;
    final title = '$memberName - $vacationType - $status';

    // Build description with notes
    final description = _buildDescription(
      absence,
      memberName,
      vacationType,
      status,
    );

    // Build iCal content with proper CRLF line endings for Outlook
    final lines = <String>[
      'BEGIN:VCALENDAR',
      'VERSION:2.0',
      'PRODID:-//Crewmeister//Absence Calendar//EN',
      'CALSCALE:GREGORIAN',
      'METHOD:PUBLISH',
      'BEGIN:VEVENT',
      'UID:$uid',
      'DTSTAMP:$dtStamp',
      'DTSTART;VALUE=DATE:$dtStart',
      'DTEND;VALUE=DATE:$dtEnd',
      _wrapLine('SUMMARY:${_escapeText(title)}'),
      _wrapLine('DESCRIPTION:${_escapeText(description)}'),
      'STATUS:${_getICalStatus(absence)}',
      'TRANSP:TRANSPARENT',
      'SEQUENCE:0',
      'END:VEVENT',
      'END:VCALENDAR',
    ];

    return lines.join('\r\n') + '\r\n';
  }

  /// Generates filename for the iCal file
  static String generateFileName(Absence absence, Member? member) {
    final memberName = member?.name.replaceAll(' ', '_') ?? 'Unknown';
    final vacationType = absence.type.toLowerCase();
    final status = absence.status.toLowerCase();
    final dateStr = DateFormat('yyyy-MM-dd').format(absence.startDate);

    return '${memberName}_${vacationType}_${status}_$dateStr.ics';
  }

  /// Formats DateTime to iCal date-time format (YYYYMMDDTHHMMSSZ)
  static String _formatICalDateTime(DateTime date) {
    return DateFormat("yyyyMMdd'T'HHmmss'Z'").format(date);
  }

  /// Formats DateTime to iCal date-only format (YYYYMMDD) for all-day events
  static String _formatICalDateOnly(DateTime date) {
    return DateFormat('yyyyMMdd').format(date);
  }

  /// Wraps long lines at 75 characters as per RFC 5545
  static String _wrapLine(String line) {
    if (line.length <= 75) return line;

    final buffer = StringBuffer();
    var remaining = line;

    while (remaining.length > 75) {
      buffer.writeln(remaining.substring(0, 75));
      remaining =
          ' ${remaining.substring(75)}'; // Continuation lines start with space
    }

    buffer.write(remaining);
    return buffer.toString();
  }

  /// Escapes text for iCal format
  static String _escapeText(String text) {
    return text
        .replaceAll('\\', '\\\\')
        .replaceAll(',', '\\,')
        .replaceAll(';', '\\;')
        .replaceAll('\n', '\\n')
        .replaceAll('\r', '');
  }

  /// Builds description with all absence information
  static String _buildDescription(
    Absence absence,
    String memberName,
    String vacationType,
    String status,
  ) {
    final buffer = StringBuffer();

    buffer.writeln('$memberName - $vacationType - $status');
    buffer.writeln('');
    buffer.writeln(
      'Start Date: ${DateFormat('MMM dd, yyyy').format(absence.startDate)}',
    );
    buffer.writeln(
      'End Date: ${DateFormat('MMM dd, yyyy').format(absence.endDate)}',
    );
    buffer.writeln('');

    if (absence.memberNote.isNotEmpty) {
      buffer.writeln('Member Note: ${absence.memberNote}');
    }

    if (absence.admitterNote != null && absence.admitterNote!.isNotEmpty) {
      buffer.writeln('Admitter Note: ${absence.admitterNote}');
    }

    buffer.writeln('');
    buffer.writeln(
      'Created: ${DateFormat('MMM dd, yyyy').format(absence.createdAt)}',
    );

    if (absence.confirmedAt != null) {
      buffer.writeln(
        'Confirmed: ${DateFormat('MMM dd, yyyy').format(absence.confirmedAt!)}',
      );
    }

    if (absence.rejectedAt != null) {
      buffer.writeln(
        'Rejected: ${DateFormat('MMM dd, yyyy').format(absence.rejectedAt!)}',
      );
    }

    return buffer.toString().trim();
  }

  /// Gets iCal status based on absence status
  static String _getICalStatus(Absence absence) {
    if (absence.rejectedAt != null) return 'CANCELLED';
    if (absence.confirmedAt != null) return 'CONFIRMED';
    return 'TENTATIVE';
  }

  /// Capitalizes first letter of a string
  static String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
