import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class Friend {
  final String id;
  String friendName;
  String friendEmail;
  String status; // "pending", "accepted", "blocked"
  DateTime addedDate;
  String profileImage;

  Friend({
    String? id,
    required this.friendName,
    required this.friendEmail,
    this.status = 'pending',
    DateTime? addedDate,
    this.profileImage = 'person.circle.fill',
  })  : id = id ?? _uuid.v4(),
        addedDate = addedDate ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'id': id,
        'friendName': friendName,
        'friendEmail': friendEmail,
        'status': status,
        'addedDate': addedDate.toIso8601String(),
        'profileImage': profileImage,
      };

  factory Friend.fromMap(Map<String, dynamic> m) => Friend(
        id: m['id'] as String,
        friendName: m['friendName'] as String,
        friendEmail: m['friendEmail'] as String,
        status: (m['status'] ?? 'pending') as String,
        addedDate: DateTime.parse(m['addedDate'] as String),
        profileImage: (m['profileImage'] ?? '') as String,
      );
}
