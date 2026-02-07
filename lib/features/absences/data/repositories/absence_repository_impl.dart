import '../../domain/entities/absence.dart';
import '../../domain/entities/member.dart';
import '../../domain/repositories/absence_repository.dart';
import '../datasources/absences_local_file_data_source.dart';

class AbsenceRepositoryImpl implements AbsenceRepository {
  final AbsencesLocalFileDataSource dataSource;

  AbsenceRepositoryImpl({required this.dataSource});

  @override
  Future<List<Member>> getMembers() async {
    final memberModels = await dataSource.getMembers();
    return memberModels;
  }

  @override
  Future<AbsencesRepositoryResult> getAbsences({
    required int page,
    required int pageSize,
    List<String>? types,
    List<String>? statuses,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final absenceModels = await dataSource.getAbsences();

    // pagination/filter logic, to simulate the backend logic
    List<Absence> absences = absenceModels
        .map(
          (model) => Absence(
            id: model.id,
            userId: model.userId,
            crewId: model.crewId,
            type: model.type,
            startDate: model.startDate,
            endDate: model.endDate,
            memberNote: model.memberNote,
            admitterNote: model.admitterNote,
            createdAt: model.createdAt,
            confirmedAt: model.confirmedAt,
            rejectedAt: model.rejectedAt,
            member: null,
          ),
        )
        .toList();

    // Apply Filters
    if (types != null && types.isNotEmpty) {
      absences = absences
          .where(
            (a) => types.any((t) => t.toLowerCase() == a.type.toLowerCase()),
          )
          .toList();
    }

    if (statuses != null && statuses.isNotEmpty) {
      absences = absences.where((a) {
        bool matches = false;
        if (statuses.contains('requested')) {
          matches = matches || (a.confirmedAt == null && a.rejectedAt == null);
        }
        if (statuses.contains('confirmed')) {
          matches = matches || (a.confirmedAt != null);
        }
        if (statuses.contains('rejected')) {
          matches = matches || (a.rejectedAt != null);
        }
        return matches;
      }).toList();
    }

    if (startDate != null && endDate != null) {
      absences = absences.where((a) {
        // Check if absence overlaps with [startDate, endDate]
        final filterStart = DateTime(
          startDate.year,
          startDate.month,
          startDate.day,
        );
        final filterEnd = DateTime(endDate.year, endDate.month, endDate.day);

        final absenceStart = DateTime(
          a.startDate.year,
          a.startDate.month,
          a.startDate.day,
        );
        final absenceEnd = DateTime(
          a.endDate.year,
          a.endDate.month,
          a.endDate.day,
        );

        // Overlap logic: (StartA <= EndB) and (EndA >= StartB)
        return (absenceStart.compareTo(filterEnd) <= 0) &&
            (absenceEnd.compareTo(filterStart) >= 0);
      }).toList();
    }

    final totalCount = absences.length;

    // Pagination
    final startIndex = (page - 1) * pageSize;
    final paginatedAbsences = (startIndex >= absences.length)
        ? <Absence>[]
        : absences.sublist(
            startIndex,
            (startIndex + pageSize) > absences.length
                ? absences.length
                : (startIndex + pageSize),
          );

    return AbsencesRepositoryResult(paginatedAbsences, totalCount);
  }
}
