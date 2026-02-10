import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/screen_size/screen_size_cubit.dart';

class InfoCardWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;

  const InfoCardWidget({super.key, required this.title, required this.subTitle, required this.icon});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScreenSizeCubit, ScreenSizeState>(
      builder: (context, state) {
        bool isWeb = !state.isMobile;
        return Container(
          margin: EdgeInsets.symmetric(vertical: isWeb ? 12 : 8, horizontal: isWeb ? 24 : 16),
          padding: EdgeInsets.all(isWeb ? 24 : 16),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize:  isWeb ? 20 :18, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                  ),
                  Icon(icon, size: 16, color: Colors.blueGrey),
                ],
              ),
              SizedBox(height: 24),
              Text(
                subTitle,
                style: TextStyle(fontSize:  isWeb ? 16 :14, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        );
      },
    );
  }
}
