import '../entities/absence.dart';
import '../entities/member.dart';

class AbsencesRepositoryResult {
  final List<Absence> absences;
  final int totalCount;

  AbsencesRepositoryResult(this.absences, this.totalCount);
}

abstract class AbsenceRepository {
  Future<AbsencesRepositoryResult> getAbsences({
    required int page,
    required int pageSize,
    List<String>? types,
    List<String>? statuses,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<List<Member>> getMembers();
}
