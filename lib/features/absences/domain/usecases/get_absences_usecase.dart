import '../entities/absence.dart';
import '../repositories/absence_repository.dart';

class AbsencesResultModel {
  final List<Absence> absences;
  final int totalCount;

  AbsencesResultModel(this.absences, this.totalCount);
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
  }) async {
    final result = await repository.getAbsences(
      page: page,
      pageSize: pageSize,
      types: types,
      statuses: statuses,
      startDate: startDate,
      endDate: endDate,
    );
    return AbsencesResultModel(result.absences, result.totalCount);
  }
}
