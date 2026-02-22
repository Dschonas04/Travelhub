import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/database_service.dart';

class ChatProvider extends ChangeNotifier {
  List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;

  Future<void> loadMessages() async {
    _messages = await DatabaseService.getMessages();
    notifyListeners();
  }

  List<ChatMessage> messagesForTrip(String tripId) =>
      _messages.where((m) => m.tripId == tripId).toList()
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

  Future<void> sendMessage(String content, String senderId, String senderName, String tripId,
      {String messageType = 'text', String replyToId = '', String replyToSender = '', String replyToContent = ''}) async {
    final msg = ChatMessage(
      senderId: senderId,
      senderName: senderName,
      tripId: tripId,
      content: content,
      messageType: messageType,
      replyToId: replyToId,
      replyToSender: replyToSender,
      replyToContent: replyToContent,
    );
    await DatabaseService.insertMessage(msg);
    _messages.add(msg);
    notifyListeners();
  }

  Future<void> togglePin(ChatMessage msg) async {
    msg.isPinned = !msg.isPinned;
    await DatabaseService.updateMessage(msg);
    notifyListeners();
  }

  Future<void> deleteMessage(ChatMessage msg) async {
    await DatabaseService.deleteMessage(msg.id);
    _messages.removeWhere((m) => m.id == msg.id);
    notifyListeners();
  }

  Future<void> addReaction(ChatMessage msg, String emoji) async {
    msg.reactions.add(emoji);
    await DatabaseService.updateMessage(msg);
    notifyListeners();
  }
}
