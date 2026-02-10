import 'package:crewmeister_frontend_coding_challenge/core/bloc/screen_size/screen_size_cubit.dart';
import 'package:crewmeister_frontend_coding_challenge/features/absences/presentation/pages/absences_page_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'absences_page_mobile.dart';

class AbsencesPage extends StatelessWidget {
  const AbsencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScreenSizeCubit, ScreenSizeState>(
      listener: (context, state) {
        if (!state.isMobile) {
          // Close any open bottom sheets when switching to web
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      child: BlocBuilder<ScreenSizeCubit, ScreenSizeState>(
        builder: (context, state) {
          return state.isMobile
              ? const AbsencesPageMobile()
              : const AbsencesPageWeb();
        },
      ),
    );
  }
}
