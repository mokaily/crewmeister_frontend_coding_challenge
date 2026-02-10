import 'package:crewmeister_frontend_coding_challenge/core/locatlizations/app_strings.dart';
import 'package:crewmeister_frontend_coding_challenge/features/absences/presentation/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/info_card_widget.dart';
import '../bloc/absences_bloc.dart';
import '../widgets/mobile/absence_list_widget.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../widgets/mobile/absence_mobile_loading.dart';
import '../widgets/mobile/filter_bottom_sheet/filter_bottom_sheet_widget.dart';

class AbsencesPageMobile extends StatelessWidget {
  const AbsencesPageMobile({super.key});

  @override
  Widget build(BuildContext context) {
    void showFilterSheet(BuildContext context) {
      final state = context.read<AbsencesBloc>().state;
      List<String> currentTypes = [];
      List<String> currentStatuses = [];
      DateTime? startDate;
      DateTime? endDate;

      if (state is AbsencesLoaded) {
        currentTypes = state.filterTypes ?? [];
        currentStatuses = state.filterStatuses ?? [];
        startDate = state.filterStartDate;
        endDate = state.filterEndDate;
      }

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        ),
        builder: (ctx) {
          // Provide the existing BLoC to the sheet
          return BlocProvider.value(
            value: context.read<AbsencesBloc>(),
            child: SizedBox(
              height: MediaQuery.of(ctx).size.height * 0.7,
              child: FilterBottomSheetWidget(
                initialTypes: currentTypes,
                initialStatuses: currentStatuses,
                initialStartDate: startDate,
                initialEndDate: endDate,
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Color(0xffF6F7F8),
      appBar: AppBar(
        leading: Image.asset("assets/cats/cat_pow.png", color: Colors.yellow, cacheHeight: 26),
        title: Text(AppStrings.absencesTitle),
        actions: [IconButton(icon: const Icon(Icons.filter_list), onPressed: () => showFilterSheet(context))],
      ),
      body: BlocBuilder<AbsencesBloc, AbsencesState>(
        builder: (BuildContext context, AbsencesState state) {
          if (state is AbsencesLoading) {
            return AbsenceMobileLoading();
          }

          if (state is AbsencesError) {
            return ErrorStateWidget(
              imageAsset: "assets/cats/cat_tangled.png",
              title: AppStrings.absencesError,
              message: AppStrings.absencesErrorDesc,
            );
          }

          if (state is AbsencesLoaded) {
            if (state.absences.isEmpty) {
              return ErrorStateWidget(
                imageAsset: "assets/cats/cat_in_box.png",
                title: AppStrings.noAbsencesFound,
                message: AppStrings.noAbsencesFoundDesc,
              );
            }
            return Column(
              children: [
                const HeaderWidget(),
                InfoCardWidget(
                  title: AppStrings.totalAbsences,
                  subTitle: state.unfilteredCount.toString(),
                  icon: Icons.bar_chart,
                ),
                Expanded(child: AbsenceList(state: state)),
              ],
            );
          }

          return AbsenceMobileLoading();
        },
      ),
    );
  }
}
