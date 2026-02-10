import 'package:crewmeister_frontend_coding_challenge/core/bloc/screen_size/screen_size_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScreenSizeCubit, ScreenSizeState>(
      builder: (context, state) {
        bool isMobile = state.isMobile;
        Widget banner = Container(
          height: isMobile ? 60 : 140,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage("assets/banner.jpg"),
              fit: BoxFit.cover,
              alignment: Alignment.center,
              colorFilter: ColorFilter.mode(Colors.blue.shade800.withValues(alpha: 0.45), BlendMode.hue),
            ),
          ),
          child: isMobile
              ? const SizedBox.shrink()
              : const Center(child: Text("Absence Tracker", style: TextStyle(fontSize: 35))),
        );

        return Container(
          width: double.infinity,
          color: Colors.white,
          child: isMobile
              ? banner // full width on mobile
              : Center(
                  child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 1920), child: banner),
                ),
        );
      },
    );
  }
}
