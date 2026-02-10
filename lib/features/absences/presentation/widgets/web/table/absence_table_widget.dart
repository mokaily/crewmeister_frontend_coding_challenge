import 'package:crewmeister_frontend_coding_challenge/core/locatlizations/app_strings.dart';
import 'package:crewmeister_frontend_coding_challenge/core/utils/formates/date_formates.dart';
import 'package:crewmeister_frontend_coding_challenge/core/widgets/chips/absence_status_chip_widget.dart';
import 'package:crewmeister_frontend_coding_challenge/core/widgets/chips/absence_type_chip_widget.dart';
import 'package:crewmeister_frontend_coding_challenge/core/widgets/export_ical_button.dart';
import 'package:crewmeister_frontend_coding_challenge/core/widgets/notes_widget.dart';
import 'package:crewmeister_frontend_coding_challenge/features/absences/presentation/widgets/web/table/pagination_buttons_widget.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/widgets/member_circle_avatar.dart';
import '../../../../domain/entities/absence.dart';
import '../../../../domain/entities/member.dart';
import '../../../bloc/absences_bloc.dart';

class AbsenceTableWidget extends StatelessWidget {
  final AbsencesLoaded state;

  const AbsenceTableWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          _buildTable(context),
          PaginationButtonsWidget(state: state),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            AppStrings.absencesRecords,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A1C1E)),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          _buildTableHeader(),
          Expanded(
            child: ListView.separated(
              itemCount: state.absences.length,
              separatorBuilder: (context, index) =>
                  const Divider(height: 1, thickness: 0.5, color: Color(0xFFE2E8F0)),
              itemBuilder: (context, index) {
                final absence = state.absences[index];
                final member = state.getMemberByUserId(absence.userId);
                return Column(children: [_buildTableRow(context, absence, member), _buildNotes(absence)]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotes(Absence absence) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          if (absence.memberNote.isNotEmpty) ...[
            Flexible(child: NotesWidget(isMemberNote: true, note: absence.memberNote)),
          ],
          const SizedBox(width: 24),
          if (absence.admitterNote != null && absence.admitterNote!.isNotEmpty) ...[
            Flexible(
              child: NotesWidget(
                isMemberNote: false,
                note: absence.admitterNote!,
                isRejected: absence.status.toLowerCase() == "rejected",
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: const Color(0xFFF8FAFC),
      child: Row(
        children: [
          Expanded(flex: 3, child: _HeaderText(AppStrings.member.toUpperCase())),
          Expanded(flex: 2, child: _HeaderText(AppStrings.type.toUpperCase())),
          Expanded(flex: 3, child: _HeaderText(AppStrings.period.toUpperCase())),
          Expanded(flex: 2, child: _HeaderText(AppStrings.status.toUpperCase())),
          Expanded(flex: 1, child: _HeaderText(AppStrings.actions.toUpperCase(), textAlign: TextAlign.right)),
        ],
      ),
    );
  }

  Widget _buildTableRow(BuildContext context, Absence absence, Member? member) {
    final startDate = formatDateShort(absence.startDate);
    final endDate = formatDateShort(absence.endDate);
    final duration = differenceInDays(absence.startDate, absence.endDate) + 1;
    final dateRange = '$startDate  -  $endDate';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                MemberCircleAvatar(link: member!.image, index: member.userId),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A1C1E)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(children: [AbsenceTypeChipWidget(type: absence.type)]),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dateRange, style: const TextStyle(color: Color(0xFF1A1C1E))),
                Text("$duration days", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(children: [AbsenceStatusChipWidget(type: absence.status)]),
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: ExportICalButton(absence: absence, member: member),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderText extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  const _HeaderText(this.text, {this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Color(0xFF64748B),
        letterSpacing: 0.5,
      ),
    );
  }
}
