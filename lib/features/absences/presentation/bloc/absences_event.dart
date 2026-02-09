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
  final String? memberName;

  const ApplyFiltersEvent({
    this.types,
    this.statuses,
    this.startDate,
    this.endDate,
    this.memberName,
  });

  @override
  List<Object?> get props => [types, statuses, startDate, endDate, memberName];
}

class PreviewFilterCountEvent extends AbsencesEvent {
  final List<String>? types;
  final List<String>? statuses;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? memberName;

  const PreviewFilterCountEvent({
    this.types,
    this.statuses,
    this.startDate,
    this.endDate,
    this.memberName,
  });

  @override
  List<Object?> get props => [types, statuses, startDate, endDate, memberName];
}
