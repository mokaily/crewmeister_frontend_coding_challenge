import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ScreenSizeState extends Equatable {
  final bool isMobile;

  const ScreenSizeState({required this.isMobile});

  @override
  List<Object> get props => [isMobile];
}

class ScreenSizeInitial extends ScreenSizeState {
  const ScreenSizeInitial({required super.isMobile});
}

class ScreenSizeChanged extends ScreenSizeState {
  const ScreenSizeChanged({required super.isMobile});
}

class ScreenSizeCubit extends Cubit<ScreenSizeState> {
  ScreenSizeCubit() : super(const ScreenSizeInitial(isMobile: true));

  void checkScreenSize(double width) {
    bool isMobile = width <= 1000;
    if (state.isMobile != isMobile) {
      emit(ScreenSizeChanged(isMobile: isMobile));
    }
  }
}
