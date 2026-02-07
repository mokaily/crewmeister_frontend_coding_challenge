import 'package:crewmeister_frontend_coding_challenge/features/absences/domain/entities/member.dart';

class MemberModel extends Member {
  const MemberModel({
    required super.id,
    required super.userId,
    required super.crewId,
    required super.name,
    required super.image,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['id'] as int,
      userId: json['userId'] as int,
      crewId: json['crewId'] as int,
      name: json['name'] as String,
      image: json['image'] as String,
    );
  }
}
