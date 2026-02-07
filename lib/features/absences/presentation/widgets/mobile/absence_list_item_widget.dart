import 'package:crewmeister_frontend_coding_challenge/core/utils/formates/date_formates.dart';
import 'package:crewmeister_frontend_coding_challenge/core/widgets/chips/abcense_status_chip_widget.dart';
import 'package:crewmeister_frontend_coding_challenge/core/widgets/chips/abcense_type_chip_widget.dart';
import 'package:crewmeister_frontend_coding_challenge/core/widgets/member_circle_avatar.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/absence.dart';
import '../../../domain/entities/member.dart';
import '../../../../../core/widgets/notes_widget.dart';

class AbsenceListItem extends StatelessWidget {
  final Absence absence;
  final Member? member;

  const AbsenceListItem({super.key, required this.absence, this.member});

  @override
  Widget build(BuildContext context) {
    final startDate = formatDateShort(absence.startDate);
    final endDate = formatDateShort(absence.endDate);
    final duration = differenceInDays(absence.startDate, absence.endDate) + 1;
    final dateRange = '$startDate - $endDate   ($duration days)';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? Color(0xFF1e2936) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark ? Color(0xFF374151) : Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Avatar + Name + Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  MemberCircleAvatar(link: member!.image, index: member!.userId),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(member!.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(height: 8),
                      Text(dateRange, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AbsenceTypeChipWidget(type: absence.type),
                  SizedBox(height: 8),
                  AbsenceStatusChipWidget(type: absence.status),
                ],
              )
            ],
          ),
          const SizedBox(height: 12),
          // Member note
          if (absence.memberNote.isNotEmpty) ...[NotesWidget(isMemberNote: true, note: absence.memberNote)],
          if (absence.admitterNote != null && absence.admitterNote!.isNotEmpty) ...[
            NotesWidget(
              isMemberNote: false,
              note: absence.admitterNote!,
              isRejected: absence.status.toLowerCase() == "rejected",
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}
