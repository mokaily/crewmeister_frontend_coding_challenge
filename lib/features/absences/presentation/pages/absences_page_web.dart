import 'package:crewmeister_frontend_coding_challenge/core/locatlizations/app_strings.dart';
import 'package:crewmeister_frontend_coding_challenge/features/absences/presentation/widgets/web/absence_web_loading.dart';
import 'package:crewmeister_frontend_coding_challenge/features/absences/presentation/widgets/web_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/info_card_widget.dart';
import '../bloc/absences_bloc.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../widgets/web/table/absence_table_widget.dart';
import '../widgets/web/filter_web_widget.dart';

class AbsencesPageWeb extends StatelessWidget {
  const AbsencesPageWeb({super.key});
  static String totalCount = "--";
  static String pendingCount = "--";
  static String activeTodayCount = "--";

  @override
  Widget build(BuildContext context) {
    Widget tableChild = const AbsenceWebLoading();
    return Scaffold(
      backgroundColor: const Color(0xffF6F7F8),
      appBar: AppBar(
        title: Center(
          child: SizedBox(
            width: 1900,
            child: Row(
              children: [
                Image.asset("assets/cats/cat_pow.png", color: Colors.yellow, cacheHeight: 26),
                SizedBox(width: 24),
                Text(AppStrings.absencesTitle),
              ],
            ),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Container(
              alignment: Alignment.topCenter,
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: Container(
                  width: 1900,
                  alignment: Alignment.topCenter,
                  child: BlocBuilder<AbsencesBloc, AbsencesState>(
                    builder: (BuildContext context, AbsencesState state) {
                      if (state is AbsencesLoading) {
                        tableChild = const AbsenceWebLoading();
                      }
                      if (state is AbsencesError) {
                        tableChild = const ErrorStateWidget(
                          imageAsset: "assets/cats/cat_tangled.png",
                          title: AppStrings.absencesError,
                          message: AppStrings.absencesErrorDesc,
                        );
                      }

                      if (state is AbsencesLoaded) {
                        totalCount = state.unfilteredCount.toString();
                        pendingCount = state.pendingCount.toString();
                        activeTodayCount = state.activeTodayCount.toString();
                        if (state.absences.isEmpty) {
                          tableChild = const ErrorStateWidget(
                            imageAsset: "assets/cats/cat_in_box.png",
                            title: AppStrings.noAbsencesFound,
                            message: AppStrings.noAbsencesFoundDesc,
                          );
                        } else {
                          tableChild = AbsenceTableWidget(state: state);
                        }
                      }

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const WebHeaderWidget(),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: InfoCardWidget(
                                  title: AppStrings.totalAbsences,
                                  subTitle: totalCount,
                                  icon: Icons.bar_chart,
                                ),
                              ),
                              Expanded(
                                child: InfoCardWidget(
                                  title: "Pending Approval",
                                  subTitle: pendingCount,
                                  icon: Icons.access_time_filled_sharp,
                                ),
                              ),
                              Expanded(
                                child: InfoCardWidget(
                                  title: "Active Today",
                                  subTitle: activeTodayCount,
                                  icon: Icons.check_box_outlined,
                                ),
                              ),
                            ],
                          ),
                          // Give the table and filter a fixed height on small screens or a fraction of the height
                          // To ensure it's scrollable as a whole, we can't use Expanded(child: Row(children: [Expanded(...)]))
                          // easily inside a SingleChildScrollView without a fixed height.
                          // However, we can use a fixed height for the content area to ensure it doesn't try to be infinite.
                          SizedBox(
                            height: 800, // Fixed height for the dashboard content to allow scrolling the page
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: tableChild),
                                const SingleChildScrollView(child: FilterWebWidget()),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
