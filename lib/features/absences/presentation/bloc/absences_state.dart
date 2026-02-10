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
  final int? unfilteredCount;
  final int pendingCount;
  final int activeTodayCount;
  final int currentPage;
  final bool isLoadingMore;
  final List<Member> members;

  // Filters
  final List<String>? filterTypes;
  final List<String>? filterStatuses;
  final DateTime? filterStartDate;
  final DateTime? filterEndDate;
  final String? filterMemberName;

  // Preview
  final int? filterPreviewCount;

  const AbsencesLoaded({
    required this.absences,
    required this.totalCount,
    this.unfilteredCount,
    this.pendingCount = 0,
    this.activeTodayCount = 0,
    this.currentPage = 1,
    this.isLoadingMore = false,
    required this.members,
    this.filterTypes,
    this.filterStatuses,
    this.filterStartDate,
    this.filterEndDate,
    this.filterMemberName,
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
    int? unfilteredCount,
    int? pendingCount,
    int? activeTodayCount,
    int? currentPage,
    bool? isLoadingMore,
    List<Member>? members,
    List<String>? filterTypes,
    List<String>? filterStatuses,
    DateTime? filterStartDate,
    DateTime? filterEndDate,
    String? filterMemberName,
    int? filterPreviewCount,
    bool clearPreviewCount = false,
  }) {
    return AbsencesLoaded(
      absences: absences ?? this.absences,
      totalCount: totalCount ?? this.totalCount,
      unfilteredCount: unfilteredCount ?? this.unfilteredCount,
      pendingCount: pendingCount ?? this.pendingCount,
      activeTodayCount: activeTodayCount ?? this.activeTodayCount,
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      members: members ?? this.members,
      filterTypes: filterTypes ?? this.filterTypes,
      filterStatuses: filterStatuses ?? this.filterStatuses,
      filterStartDate: filterStartDate ?? this.filterStartDate,
      filterEndDate: filterEndDate ?? this.filterEndDate,
      filterMemberName: filterMemberName ?? this.filterMemberName,
      filterPreviewCount: clearPreviewCount
          ? null
          : (filterPreviewCount ?? this.filterPreviewCount),
    );
  }

  @override
  List<Object?> get props => [
    absences,
    totalCount,
    unfilteredCount,
    pendingCount,
    activeTodayCount,
    currentPage,
    isLoadingMore,
    members,
    filterTypes,
    filterStatuses,
    filterStartDate,
    filterEndDate,
    filterMemberName,
    filterPreviewCount,
  ];
}

class AbsencesError extends AbsencesState {
  final String message;

  const AbsencesError(this.message);

  @override
  List<Object?> get props => [message];
}
