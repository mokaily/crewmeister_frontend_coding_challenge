import 'dart:io';

import 'package:crewmeister_frontend_coding_challenge/features/absences/data/models/absence_model.dart';
import 'package:crewmeister_frontend_coding_challenge/features/absences/data/models/member_model.dart';
import 'package:crewmeister_frontend_coding_challenge/features/absences/domain/entities/absence.dart';
import 'package:crewmeister_frontend_coding_challenge/features/absences/domain/entities/member.dart';
import 'package:crewmeister_frontend_coding_challenge/features/absences/domain/repositories/absence_repository.dart';
import 'package:crewmeister_frontend_coding_challenge/features/absences/domain/usecases/get_absences_usecase.dart';

class TestConstants {
  static String fixture(String name) => File('test/fixtures/$name').readAsStringSync();

  // general
  static int tTotalCount = 2;
  static int tPage = 1;
  static int tPageSize = 10;
  static List<String> tTypes = ["test"];
  static List<String> tStatuses = ["test"];
  static DateTime tDateTime = DateTime.parse("2020-12-12T18:03:55.000+01:00");

  // entities
  static Member tMember = Member(id: 1, userId: 1, crewId: 1, name: 'test', image: 'test');

  static List<Member> tMemberList = [tMember, tMember];

  static AbsencesRepositoryResult tAbsencesRepositoryResult = AbsencesRepositoryResult(
    totalCount: 2,
    absences: [tAbsence, tAbsence],
    activeTodayCount: 0,
    pendingCount: 0,
    unfilteredCount: 0,
  );

  static Absence tAbsence = Absence(
    startDate: DateTime.parse("2020-12-12T18:03:55.000+01:00"),
    id: 1,
    userId: 1,
    crewId: 1,
    type: '',
    endDate: DateTime.parse("2020-12-12T18:03:55.000+01:00"),
    memberNote: '',
    createdAt: DateTime.parse("2020-12-12T18:03:55.000+01:00"),
  );
  //models
  static AbsencesResultModel tAbsencesResultModel = AbsencesResultModel(
    totalCount: 2,
    absences: [tAbsence, tAbsence],
    activeTodayCount: 0,
    pendingCount: 0,
    unfilteredCount: 0,
  );

  static MemberModel tMemberModel = const MemberModel(
    crewId: 1,
    id: 1,
    image: "test",
    name: "test",
    userId: 1,
  );

  static AbsenceModel tAbsenceModel = AbsenceModel(
    userId: 1,
    crewId: 1,
    type: "test",
    createdAt: DateTime.parse("2020-12-12T18:03:55.000+01:00"),
    endDate: DateTime.parse("2020-12-12T18:03:55.000+01:00"),
    id: 1,
    memberNote: "test",
    startDate: DateTime.parse("2020-12-12T18:03:55.000+01:00"),
    admitterNote: "test",
    confirmedAt: DateTime.parse("2020-12-12T18:03:55.000+01:00"),
    rejectedAt: DateTime.parse("2020-12-12T18:03:55.000+01:00"),
  );

  //Lists
  static List<AbsenceModel> tAbsenceModels = [tAbsenceModel, tAbsenceModel];

  static List<MemberModel> tMemberModels = [tMemberModel, tMemberModel];
}
