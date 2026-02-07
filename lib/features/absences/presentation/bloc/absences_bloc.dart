import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/absence.dart';
import '../../domain/entities/member.dart';
import '../../domain/usecases/get_absences_usecase.dart';
import '../../domain/usecases/get_members_usecase.dart';

part 'absences_event.dart';
part 'absences_state.dart';

class AbsencesBloc extends Bloc<AbsencesEvent, AbsencesState> {
  final GetAbsencesUseCase getAbsencesUseCase;
  final GetMembersUseCase getMembersUseCase;

  static const int _pageSize = 10;
  int _currentPage = 1;

  List<String>? _filterTypes;
  List<String>? _filterStatuses;
  DateTime? _filterStartDate;
  DateTime? _filterEndDate;

  List<Member> _members = [];

  AbsencesBloc({required this.getAbsencesUseCase, required this.getMembersUseCase})
    : super(AbsencesInitial()) {
    on<LoadAbsencesEvent>(_onLoadAbsences);
    on<LoadNextPageEvent>(_onLoadNextPage);
    on<ApplyFiltersEvent>(_onApplyFilters);
    on<PreviewFilterCountEvent>(_onPreviewFilterCount);
  }

  Future<void> _onLoadAbsences(LoadAbsencesEvent event, Emitter<AbsencesState> emit) async {
    try {
      emit(AbsencesLoading());
      _currentPage = 1;

      // Load members first (only once)
      if (_members.isEmpty) {
        _members = await getAbsencesUseCase.repository.getMembers();
      }

      final result = await getAbsencesUseCase.execute(
        page: _currentPage,
        pageSize: _pageSize,
        types: _filterTypes,
        statuses: _filterStatuses,
        startDate: _filterStartDate,
        endDate: _filterEndDate,
      );

      print(
        'LoadAbsences: page=$_currentPage, '
        'absencesCount=${result.absences.length}, '
        'totalCount=${result.totalCount}',
      );

      emit(
        AbsencesLoaded(
          absences: result.absences,
          totalCount: result.totalCount,
          members: _members,
          filterTypes: _filterTypes,
          filterStatuses: _filterStatuses,
          filterStartDate: _filterStartDate,
          filterEndDate: _filterEndDate,
        ),
      );
    } catch (e) {
      emit(AbsencesError(e.toString()));
    }
  }

  Future<void> _onLoadNextPage(LoadNextPageEvent event, Emitter<AbsencesState> emit) async {
    final currentState = state;
    if (currentState is! AbsencesLoaded) return;

    // Don't load if already loading or no more data
    if (currentState.isLoadingMore) return;
    if (currentState.absences.length >= currentState.totalCount) return;

    try {
      emit(currentState.copyWith(isLoadingMore: true));
      _currentPage++;

      final result = await getAbsencesUseCase.execute(
        page: _currentPage,
        pageSize: _pageSize,
        types: _filterTypes,
        statuses: _filterStatuses,
        startDate: _filterStartDate,
        endDate: _filterEndDate,
      );

      emit(
        currentState.copyWith(
          absences: [...currentState.absences, ...result.absences],
          totalCount: result.totalCount, // Ensure total count is maintained
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(currentState.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onApplyFilters(ApplyFiltersEvent event, Emitter<AbsencesState> emit) async {
    _filterTypes = event.types;
    _filterStatuses = event.statuses;
    _filterStartDate = event.startDate;
    _filterEndDate = event.endDate;
    add(const LoadAbsencesEvent(refresh: true));
  }

  Future<void> _onPreviewFilterCount(PreviewFilterCountEvent event, Emitter<AbsencesState> emit) async {
    try {
      final result = await getAbsencesUseCase.execute(
        page: 1,
        pageSize: 1, // We only care about totalCount
        types: event.types,
        statuses: event.statuses,
        startDate: event.startDate,
        endDate: event.endDate,
      );

      if (state is AbsencesLoaded) {
        emit((state as AbsencesLoaded).copyWith(filterPreviewCount: result.totalCount));
      }
    } catch (e) {
      // Ignore errors for preview
    }
  }
}
