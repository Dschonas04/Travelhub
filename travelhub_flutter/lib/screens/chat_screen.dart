import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/chat_provider.dart';
import '../providers/members_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/user_avatar.dart';

/// Pendant zu ChatView.swift
class ChatScreen extends StatefulWidget {
  final Trip trip;
  const ChatScreen({super.key, required this.trip});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  ChatMessage? _replyingTo;
  static const _currentUserId = 'CurrentUserID';

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _send() {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;
    context.read<ChatProvider>().sendMessage(
          text,
          _currentUserId,
          'Max Mustermann',
          widget.trip.id,
          replyToId: _replyingTo?.id ?? '',
          replyToSender: _replyingTo?.senderName ?? '',
          replyToContent: _replyingTo?.content ?? '',
        );
    _msgCtrl.clear();
    setState(() => _replyingTo = null);
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trip.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4A90D9), Color(0xFF67B8DE)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Consumer2<ChatProvider, MembersProvider>(
        builder: (context, chatProv, membersProv, _) {
          final messages = chatProv.messagesForTrip(widget.trip.id);
          final members = membersProv.membersForTrip(widget.trip.id);

          return Column(
            children: [
              // Online members bar
              if (members.isNotEmpty)
                Container(
                  height: 72,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: members.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (_, i) => Column(
                      children: [
                        Stack(
                          children: [
                            UserAvatar(name: members[i].userName, size: 36),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(members[i].userName.split(' ').first, style: TextStyle(fontSize: 10, color: Colors.grey.shade600), overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ),

              // Messages
              Expanded(
                child: ListView.builder(
                  controller: _scrollCtrl,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: messages.length,
                  itemBuilder: (_, i) {
                    final msg = messages[i];
                    return ChatBubble(
                      message: msg,
                      isCurrentUser: msg.senderId == _currentUserId,
                      onReply: () => setState(() => _replyingTo = msg),
                      onPin: () => chatProv.togglePin(msg),
                      onDelete: () => chatProv.deleteMessage(msg),
                    );
                  },
                ),
              ),

              // Reply preview
              if (_replyingTo != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.grey.shade100,
                  child: Row(
                    children: [
                      Container(width: 3, height: 30, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_replyingTo!.senderName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                            Text(_replyingTo!.content, style: const TextStyle(fontSize: 12, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      IconButton(icon: const Icon(Icons.close, size: 18), onPressed: () => setState(() => _replyingTo = null)),
                    ],
                  ),
                ),

              // Input bar
              SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey.shade200))),
                  child: Row(
                    children: [
                      IconButton(icon: const Icon(Icons.add_circle, color: AppColors.primary, size: 26), onPressed: () {}),
                      Expanded(
                        child: TextField(
                          controller: _msgCtrl,
                          maxLines: 4,
                          minLines: 1,
                          decoration: InputDecoration(
                            hintText: 'Nachricht schreiben...',
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        icon: const Icon(Icons.send, color: AppColors.primary),
                        onPressed: _send,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
