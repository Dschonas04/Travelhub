import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class TripMember {
  final String id;
  String tripId;
  String userId;
  String userName;
  String userEmail;
  String role; // "Teilnehmer", "Organisator", "Finanzer", "Navigator", "Fotograf", "Koch"
  DateTime joinedDate;
  bool isActive;

  TripMember({
    String? id,
    required this.tripId,
    String? userId,
    required this.userName,
    this.userEmail = '',
    this.role = 'Teilnehmer',
    DateTime? joinedDate,
    this.isActive = true,
  })  : id = id ?? _uuid.v4(),
        userId = userId ?? _uuid.v4(),
        joinedDate = joinedDate ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'id': id,
        'tripId': tripId,
        'userId': userId,
        'userName': userName,
        'userEmail': userEmail,
        'role': role,
        'joinedDate': joinedDate.toIso8601String(),
        'isActive': isActive ? 1 : 0,
      };

  factory TripMember.fromMap(Map<String, dynamic> m) => TripMember(
        id: m['id'] as String,
        tripId: m['tripId'] as String,
        userId: m['userId'] as String,
        userName: m['userName'] as String,
        userEmail: (m['userEmail'] ?? '') as String,
        role: (m['role'] ?? 'Teilnehmer') as String,
        joinedDate: DateTime.parse(m['joinedDate'] as String),
        isActive: (m['isActive'] as int?) == 1,
      );
}
