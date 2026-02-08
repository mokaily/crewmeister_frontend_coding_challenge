import 'package:crewmeister_frontend_coding_challenge/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/utils/themes/themes.dart';
import 'features/absences/presentation/bloc/absences_bloc.dart';
import 'features/absences/presentation/pages/absences_page.dart';
import 'package:get_it/get_it.dart';

import 'features/absences/presentation/pages/absences_page_mobile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AbsencesBloc(getAbsencesUseCase: GetIt.instance.get(), getMembersUseCase: GetIt.instance.get())
            ..add(const LoadAbsencesEvent()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Crewmeister Absences',
        theme: Themes.mainTheme,
        home: const AbsencesPageMobile(),
      ),
    );
  }
}
