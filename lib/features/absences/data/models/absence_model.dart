import '../../domain/entities/absence.dart';

class AbsenceModel extends Absence {
  const AbsenceModel({
    required super.id,
    required super.userId,
    required super.crewId,
    required super.type,
    required super.startDate,
    required super.endDate,
    required super.memberNote,
    super.admitterNote,
    required super.createdAt,
    super.confirmedAt,
    super.rejectedAt,
  });

  factory AbsenceModel.fromJson(Map<String, dynamic> json) {
    return AbsenceModel(
      id: json['id'] as int,
      userId: json['userId'] as int,
      crewId: json['crewId'] as int,
      type: json['type'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      memberNote: json['memberNote'] as String? ?? '',
      admitterNote: json['admitterNote'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      confirmedAt: json['confirmedAt'] != null ? DateTime.parse(json['confirmedAt'] as String) : null,
      rejectedAt: json['rejectedAt'] != null ? DateTime.parse(json['rejectedAt'] as String) : null,
    );
  }
}
