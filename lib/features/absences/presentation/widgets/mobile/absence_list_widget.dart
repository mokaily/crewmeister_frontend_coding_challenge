import 'package:crewmeister_frontend_coding_challenge/features/absences/presentation/widgets/mobile/absence_list_item_widget.dart';
import 'package:flutter/material.dart';
import '../../../domain/entities/member.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/absences_bloc.dart';
import 'absence_list_item_widget.dart';

class AbsenceList extends StatelessWidget {
  final AbsencesLoaded state;
  final Member? member; // Accept member from parent

  const AbsenceList({super.key, required this.state, this.member});

  @override
  Widget build(BuildContext context) {
    final hasMore = state.absences.length < state.totalCount;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<AbsencesBloc>().add(
          const LoadAbsencesEvent(refresh: true),
        );
      },
      child: ListView.builder(
        itemCount: state.absences.length + (hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.absences.length) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: state.isLoadingMore
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: () =>
                    context.read<AbsencesBloc>().add(
                      LoadNextPageEvent(),
                    ),
                child: const Text('Load More'),
              ),
            );
          }
          final absence = state.absences[index];
          final member = state.getMemberByUserId(absence.userId);
          return AbsenceListItem(absence: absence, member: member);
        },
      ),
    );
  }
}