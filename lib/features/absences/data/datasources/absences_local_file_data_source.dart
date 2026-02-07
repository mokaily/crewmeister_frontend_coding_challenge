import 'package:crewmeister_frontend_coding_challenge/api/api.dart' as api;
import '../models/absence_model.dart';
import '../models/member_model.dart';

abstract class AbsencesLocalFileDataSource {
  Future<List<AbsenceModel>> getAbsences();
  Future<List<MemberModel>> getMembers();
}

class AbsencesLocalFileDataSourceImpl implements AbsencesLocalFileDataSource {
  @override
  Future<List<AbsenceModel>> getAbsences() async {
    final data = await api.absences();
    return data.map((e) => AbsenceModel.fromJson(e)).toList();
  }

  @override
  Future<List<MemberModel>> getMembers() async {
    final data = await api.members();
    return data.map((e) => MemberModel.fromJson(e)).toList();
  }
}
