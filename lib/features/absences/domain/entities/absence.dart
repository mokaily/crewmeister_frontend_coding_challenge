import 'package:equatable/equatable.dart';
import 'member.dart';

class Absence extends Equatable {
  final int id;
  final int userId;
  final int crewId;
  final String type;
  final DateTime startDate;
  final DateTime endDate;
  final String memberNote;
  final String? admitterNote;
  final DateTime createdAt;
  final DateTime? confirmedAt;
  final DateTime? rejectedAt;
  final Member? member; // Enriched data

  const Absence({
    required this.id,
    required this.userId,
    required this.crewId,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.memberNote,
    this.admitterNote,
    required this.createdAt,
    this.confirmedAt,
    this.rejectedAt,
    this.member,
  });

  String get status {
    if (rejectedAt != null) return 'Rejected';
    if (confirmedAt != null) return 'Confirmed';
    return 'Requested';
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    crewId,
    type,
    startDate,
    endDate,
    memberNote,
    admitterNote,
    createdAt,
    confirmedAt,
    rejectedAt,
    member,
  ];
}
