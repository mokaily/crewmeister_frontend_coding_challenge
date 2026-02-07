import 'package:crewmeister_frontend_coding_challenge/features/absences/domain/entities/member.dart';
import '../repositories/absence_repository.dart';

class GetMembersUseCase {
  final AbsenceRepository repository;

  GetMembersUseCase(this.repository);

  Future<List<Member>> execute() async {
    final result = await repository.getMembers();
    return result;
  }
}
