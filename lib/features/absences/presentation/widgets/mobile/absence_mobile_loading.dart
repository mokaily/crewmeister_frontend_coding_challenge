import 'package:crewmeister_frontend_coding_challenge/core/locatlizations/app_strings.dart';
import 'package:crewmeister_frontend_coding_challenge/core/widgets/info_card_widget.dart';
import 'package:crewmeister_frontend_coding_challenge/core/widgets/shimmer_widgets.dart';
import 'package:flutter/material.dart';

import '../header_widget.dart';

class AbsenceMobileLoading extends StatelessWidget {
  const AbsenceMobileLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HeaderWidget(),
        InfoCardWidget(
          title: AppStrings.totalAbsences,
          subTitle: "--",
          icon: Icons.bar_chart,
        ),
        Expanded(child:
        ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Color(0xFFE5E7EB),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerWidget.circular(width: 24, height: 24),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ShimmerWidget.oval(width: 150, height: 12),
                              SizedBox(height: 8),
                              ShimmerWidget.oval(width: 150, height: 12),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ShimmerWidget.oval(width: 100, height: 12),
                          SizedBox(height: 8),
                          ShimmerWidget.oval(width: 100, height: 12),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ShimmerWidget.oval(width: double.infinity, height: 50),

                  const SizedBox(height: 8),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: ShimmerWidget.oval(width: 75, height: 12)),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        )
        ),
      ],
    );  }
}
