import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class AppNotification {
  final String id;
  String userId;
  String type; // "friend_request", "trip_invite", "message", "poll", "expense"
  String relatedTripId;
  String relatedUserId;
  String title;
  String body;
  bool isRead;
  DateTime timestamp;

  AppNotification({
    String? id,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    this.relatedTripId = '',
    this.relatedUserId = '',
    this.isRead = false,
    DateTime? timestamp,
  })  : id = id ?? _uuid.v4(),
        timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'type': type,
        'relatedTripId': relatedTripId,
        'relatedUserId': relatedUserId,
        'title': title,
        'body': body,
        'isRead': isRead ? 1 : 0,
        'timestamp': timestamp.toIso8601String(),
      };

  factory AppNotification.fromMap(Map<String, dynamic> m) => AppNotification(
        id: m['id'] as String,
        userId: m['userId'] as String,
        type: m['type'] as String,
        title: m['title'] as String,
        body: m['body'] as String,
        relatedTripId: (m['relatedTripId'] ?? '') as String,
        relatedUserId: (m['relatedUserId'] ?? '') as String,
        isRead: (m['isRead'] as int?) == 1,
        timestamp: DateTime.parse(m['timestamp'] as String),
      );
}
