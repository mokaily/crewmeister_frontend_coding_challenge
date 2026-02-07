part of 'absences_bloc.dart';

abstract class AbsencesState extends Equatable {
  const AbsencesState();

  @override
  List<Object?> get props => [];
}

class AbsencesInitial extends AbsencesState {}

class AbsencesLoading extends AbsencesState {}

class AbsencesLoaded extends AbsencesState {
  final List<Absence> absences;
  final int totalCount;
  final bool isLoadingMore;
  final List<Member> members;

  // Filters
  final List<String>? filterTypes;
  final List<String>? filterStatuses;
  final DateTime? filterStartDate;
  final DateTime? filterEndDate;

  // Preview
  final int? filterPreviewCount;

  const AbsencesLoaded({
    required this.absences,
    required this.totalCount,
    this.isLoadingMore = false,
    required this.members,
    this.filterTypes,
    this.filterStatuses,
    this.filterStartDate,
    this.filterEndDate,
    this.filterPreviewCount,
  });

  // Helper method to get member by userId
  Member? getMemberByUserId(int userId) {
    try {
      return members.firstWhere((m) => m.userId == userId);
    } catch (e) {
      return null;
    }
  }

  AbsencesLoaded copyWith({
    List<Absence>? absences,
    int? totalCount,
    bool? isLoadingMore,
    List<Member>? members,
    List<String>? filterTypes,
    List<String>? filterStatuses,
    DateTime? filterStartDate,
    DateTime? filterEndDate,
    int? filterPreviewCount,
    bool clearPreviewCount = false,
  }) {
    return AbsencesLoaded(
      absences: absences ?? this.absences,
      totalCount: totalCount ?? this.totalCount,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      members: members ?? this.members,
      filterTypes: filterTypes ?? this.filterTypes,
      filterStatuses: filterStatuses ?? this.filterStatuses,
      filterStartDate: filterStartDate ?? this.filterStartDate,
      filterEndDate: filterEndDate ?? this.filterEndDate,
      filterPreviewCount: clearPreviewCount
          ? null
          : (filterPreviewCount ?? this.filterPreviewCount),
    );
  }

  @override
  List<Object?> get props => [
    absences,
    totalCount,
    isLoadingMore,
    members,
    filterTypes,
    filterStatuses,
    filterStartDate,
    filterEndDate,
    filterPreviewCount,
  ];
}

class AbsencesError extends AbsencesState {
  final String message;

  const AbsencesError(this.message);

  @override
  List<Object?> get props => [message];
}
