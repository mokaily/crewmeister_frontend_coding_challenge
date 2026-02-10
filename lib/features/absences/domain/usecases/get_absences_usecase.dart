import '../entities/absence.dart';
import '../repositories/absence_repository.dart';

class AbsencesResultModel {
  final List<Absence> absences;
  final int totalCount;
  final int unfilteredCount;
  final int pendingCount;
  final int activeTodayCount;

  AbsencesResultModel({
    required this.absences,
    required this.totalCount,
    required this.unfilteredCount,
    required this.pendingCount,
    required this.activeTodayCount,
  });
}

class GetAbsencesUseCase {
  final AbsenceRepository repository;

  GetAbsencesUseCase(this.repository);

  Future<AbsencesResultModel> execute({
    int page = 1,
    int pageSize = 10,
    List<String>? types,
    List<String>? statuses,
    DateTime? startDate,
    DateTime? endDate,
    String? memberName,
  }) async {
    final result = await repository.getAbsences(
      page: page,
      pageSize: pageSize,
      types: types,
      statuses: statuses,
      startDate: startDate,
      endDate: endDate,
      memberName: memberName,
    );
    return AbsencesResultModel(
      absences: result.absences,
      totalCount: result.totalCount,
      unfilteredCount: result.unfilteredCount,
      pendingCount: result.pendingCount,
      activeTodayCount: result.activeTodayCount,
    );
  }
}
