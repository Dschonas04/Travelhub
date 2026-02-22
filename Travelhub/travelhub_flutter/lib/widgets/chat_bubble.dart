import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'user_avatar.dart';

/// Chat-Blase (Pendant zu ChatBubbleView.swift)
class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isCurrentUser;
  final VoidCallback? onReply;
  final VoidCallback? onPin;
  final VoidCallback? onDelete;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    this.onReply,
    this.onPin,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (message.messageType == 'system') return _systemBubble();
    return _messageBubble(context);
  }

  Widget _systemBubble() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(12)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.info_outline, size: 14, color: Colors.grey.shade600),
              const SizedBox(width: 6),
              Text(message.content, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _messageBubble(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isCurrentUser)
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  UserAvatar(name: message.senderName, size: 20),
                  const SizedBox(width: 6),
                  Text(message.senderName, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade600)),
                ],
              ),
            ),
          Row(
            mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (isCurrentUser) const Spacer(),
              Flexible(
                child: GestureDetector(
                  onLongPress: () => _showOptions(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: isCurrentUser ? AppColors.primaryGradient : null,
                      color: isCurrentUser ? null : Colors.grey.shade200,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(isCurrentUser ? 16 : 4),
                        bottomRight: Radius.circular(isCurrentUser ? 4 : 16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        if (message.replyToId.isNotEmpty) _replyPreview(),
                        Text(message.content, style: TextStyle(color: isCurrentUser ? Colors.white : Colors.black87, fontSize: 15)),
                      ],
                    ),
                  ),
                ),
              ),
              if (!isCurrentUser) const Spacer(),
            ],
          ),
          // Timestamp
          Padding(
            padding: const EdgeInsets.only(top: 2, left: 4, right: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                ),
                if (isCurrentUser) ...[
                  const SizedBox(width: 4),
                  Icon(message.isRead ? Icons.done_all : Icons.done, size: 12, color: message.isRead ? AppColors.primary : Colors.grey),
                ],
                if (message.isPinned) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.push_pin, size: 12, color: Colors.orange),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _replyPreview() {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: isCurrentUser ? Colors.white54 : AppColors.primary, width: 2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message.replyToSender,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isCurrentUser ? Colors.white70 : AppColors.primary)),
          Text(message.replyToContent,
              style: TextStyle(fontSize: 10, color: isCurrentUser ? Colors.white54 : Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onReply != null) ListTile(leading: const Icon(Icons.reply), title: const Text('Antworten'), onTap: () { Navigator.pop(context); onReply!(); }),
            if (onPin != null)
              ListTile(
                leading: Icon(message.isPinned ? Icons.push_pin_outlined : Icons.push_pin),
                title: Text(message.isPinned ? 'Lösen' : 'Anheften'),
                onTap: () { Navigator.pop(context); onPin!(); },
              ),
            if (isCurrentUser && onDelete != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Löschen', style: TextStyle(color: Colors.red)),
                onTap: () { Navigator.pop(context); onDelete!(); },
              ),
          ],
        ),
      ),
    );
  }
}
