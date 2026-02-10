part of 'absences_bloc.dart';

abstract class AbsencesEvent extends Equatable {
  const AbsencesEvent();

  @override
  List<Object?> get props => [];
}

class LoadAbsencesEvent extends AbsencesEvent {
  final bool refresh;
  final int page;
  const LoadAbsencesEvent({this.refresh = false, this.page = 1});

  @override
  List<Object?> get props => [refresh, page];
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
