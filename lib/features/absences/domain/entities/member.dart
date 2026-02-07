import 'package:equatable/equatable.dart';

class Member extends Equatable {
  final int id;
  final int userId;
  final int crewId;
  final String name;
  final String image;

  const Member({
    required this.id,
    required this.userId,
    required this.crewId,
    required this.name,
    required this.image,
  });

  @override
  List<Object?> get props => [id, userId, crewId, name, image];
}
