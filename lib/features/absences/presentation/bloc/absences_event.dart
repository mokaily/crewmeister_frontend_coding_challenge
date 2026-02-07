part of 'absences_bloc.dart';

abstract class AbsencesEvent extends Equatable {
  const AbsencesEvent();

  @override
  List<Object?> get props => [];
}

class LoadAbsencesEvent extends AbsencesEvent {
  final bool refresh;
  const LoadAbsencesEvent({this.refresh = false});
}

class LoadNextPageEvent extends AbsencesEvent {}

class ApplyFiltersEvent extends AbsencesEvent {
  final List<String>? types;
  final List<String>? statuses;
  final DateTime? startDate;
  final DateTime? endDate;

  const ApplyFiltersEvent({
    this.types,
    this.statuses,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [types, statuses, startDate, endDate];
}

class PreviewFilterCountEvent extends AbsencesEvent {
  final List<String>? types;
  final List<String>? statuses;
  final DateTime? startDate;
  final DateTime? endDate;

  const PreviewFilterCountEvent({
    this.types,
    this.statuses,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [types, statuses, startDate, endDate];
}
