import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class User {
  final String id;
  String name;
  String email;
  String profileImage;
  String bio;
  DateTime lastActive;

  User({
    String? id,
    required this.name,
    required this.email,
    this.profileImage = 'person.circle.fill',
    this.bio = '',
    DateTime? lastActive,
  })  : id = id ?? _uuid.v4(),
        lastActive = lastActive ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'profileImage': profileImage,
        'bio': bio,
        'lastActive': lastActive.toIso8601String(),
      };

  factory User.fromMap(Map<String, dynamic> m) => User(
        id: m['id'] as String,
        name: m['name'] as String,
        email: m['email'] as String,
        profileImage: (m['profileImage'] ?? '') as String,
        bio: (m['bio'] ?? '') as String,
        lastActive: DateTime.parse(m['lastActive'] as String),
      );
}
