import '../entities/absence.dart';
import '../entities/member.dart';

class AbsencesRepositoryResult {
  final List<Absence> absences;
  final int totalCount;
  final int unfilteredCount;
  final int pendingCount;
  final int activeTodayCount;

  AbsencesRepositoryResult({
    required this.absences,
    required this.totalCount,
    required this.unfilteredCount,
    required this.pendingCount,
    required this.activeTodayCount,
  });
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
