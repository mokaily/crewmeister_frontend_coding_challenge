import '../entities/absence.dart';
import '../entities/member.dart';

class AbsencesRepositoryResult {
  final List<Absence> absences;
  final int totalCount;
  final int unfilteredCount;
  final int pendingCount;
  final int activeTodayCount;

  AbsencesRepositoryResult(
    this.absences,
    this.totalCount,
    this.unfilteredCount,
    this.pendingCount,
    this.activeTodayCount,
  );
}

abstract class AbsenceRepository {
  Future<AbsencesRepositoryResult> getAbsences({
    required int page,
    required int pageSize,
    List<String>? types,
    List<String>? statuses,
    DateTime? startDate,
    DateTime? endDate,
    String? memberName,
  });

  Future<List<Member>> getMembers();
}
