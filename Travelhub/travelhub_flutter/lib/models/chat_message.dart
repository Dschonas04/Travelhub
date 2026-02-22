import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class ChatMessage {
  final String id;
  String senderId;
  String senderName;
  String tripId;
  String content;
  DateTime timestamp;
  bool isRead;
  String messageType; // "text", "image", "voice", "location", "system"
  String replyToId;
  String replyToSender;
  String replyToContent;
  List<String> reactions;
  bool isPinned;

  ChatMessage({
    String? id,
    required this.senderId,
    required this.senderName,
    required this.tripId,
    required this.content,
    DateTime? timestamp,
    this.isRead = false,
    this.messageType = 'text',
    this.replyToId = '',
    this.replyToSender = '',
    this.replyToContent = '',
    List<String>? reactions,
    this.isPinned = false,
  })  : id = id ?? _uuid.v4(),
        timestamp = timestamp ?? DateTime.now(),
        reactions = reactions ?? [];

  Map<String, dynamic> toMap() => {
        'id': id,
        'senderId': senderId,
        'senderName': senderName,
        'tripId': tripId,
        'content': content,
        'timestamp': timestamp.toIso8601String(),
        'isRead': isRead ? 1 : 0,
        'messageType': messageType,
        'replyToId': replyToId,
        'replyToSender': replyToSender,
        'replyToContent': replyToContent,
        'reactions': reactions.join(','),
        'isPinned': isPinned ? 1 : 0,
      };

  factory ChatMessage.fromMap(Map<String, dynamic> m) => ChatMessage(
        id: m['id'] as String,
        senderId: m['senderId'] as String,
        senderName: m['senderName'] as String,
        tripId: m['tripId'] as String,
        content: m['content'] as String,
        timestamp: DateTime.parse(m['timestamp'] as String),
        isRead: (m['isRead'] as int?) == 1,
        messageType: (m['messageType'] ?? 'text') as String,
        replyToId: (m['replyToId'] ?? '') as String,
        replyToSender: (m['replyToSender'] ?? '') as String,
        replyToContent: (m['replyToContent'] ?? '') as String,
        reactions: (m['reactions'] as String?)?.split(',').where((s) => s.isNotEmpty).toList() ?? [],
        isPinned: (m['isPinned'] as int?) == 1,
      );
}
