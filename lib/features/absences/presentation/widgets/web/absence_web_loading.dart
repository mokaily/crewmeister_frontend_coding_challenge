import 'package:crewmeister_frontend_coding_challenge/core/widgets/shimmer_widgets.dart';
import 'package:flutter/material.dart';

class AbsenceWebLoading extends StatelessWidget {
  const AbsenceWebLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerWidget.oval(width: 150, height: 25),
          SizedBox(height: 25),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ShimmerWidget.circular(width: 24, height: 24),
                            const SizedBox(width: 12),
                            ShimmerWidget.oval(width: 150, height: 12),
                          ],
                        ),

                        ShimmerWidget.oval(width: 100, height: 12),
                        ShimmerWidget.oval(width: 100, height: 12),
                        ShimmerWidget.oval(width: 100, height: 12),
                        ShimmerWidget.oval(width: 100, height: 12),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ShimmerWidget.oval(width: double.infinity, height: 50),
                    const SizedBox(height: 8),
                    Align(alignment: Alignment.centerLeft, child: ShimmerWidget.oval(width: 75, height: 12)),
                    const SizedBox(height: 8),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
