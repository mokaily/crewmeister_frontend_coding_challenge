import 'package:crewmeister_frontend_coding_challenge/features/absences/presentation/widgets/web/table/table_pagination_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/absences_bloc.dart';

class PaginationButtonsWidget extends StatelessWidget {
  final dynamic state;
  const PaginationButtonsWidget({super.key, this.state});

  @override
  Widget build(BuildContext context) {
    final totalPages = (state.totalCount / 10).ceil();
    if (totalPages <= 1) return const SizedBox(height: 24);

    final currentPage = state.currentPage;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TablePaginationButton(
            icon: Icons.chevron_left,
            onPressed: currentPage > 1
                ? () => context.read<AbsencesBloc>().add(LoadAbsencesEvent(page: currentPage - 1))
                : null,
          ),
          const SizedBox(width: 8),
          for (int i = 1; i <= totalPages; i++) ...[
            if (i == 1 || i == totalPages || (i >= currentPage - 1 && i <= currentPage + 1))
              TablePaginationButton(
                label: i.toString(),
                isActive: i == currentPage,
                onPressed: () => context.read<AbsencesBloc>().add(LoadAbsencesEvent(page: i)),
              )
            else if (i == currentPage - 2 || i == currentPage + 2)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text("...", style: TextStyle(color: Colors.grey)),
              ),
          ],
          const SizedBox(width: 8),
          TablePaginationButton(
            icon: Icons.chevron_right,
            onPressed: currentPage < totalPages
                ? () => context.read<AbsencesBloc>().add(LoadAbsencesEvent(page: currentPage + 1))
                : null,
          ),
        ],
      ),
    );
  }
}
