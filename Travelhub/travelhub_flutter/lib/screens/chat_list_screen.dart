import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../providers/trips_provider.dart';
import '../theme/app_theme.dart';
import 'chat_screen.dart';

/// Pendant zu ChatListView.swift (Tab 3)
class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chats', style: TextStyle(fontWeight: FontWeight.bold))),
      body: Consumer2<TripsProvider, ChatProvider>(
        builder: (context, tripsProv, chatProv, _) {
          final trips = tripsProv.trips;

          if (trips.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.chat_bubble_outline, size: 56, color: AppColors.primary.withOpacity(0.3)),
                  const SizedBox(height: 16),
                  const Text('Noch keine Chats', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text('Erstelle oder tritt einer Reise bei,\num den Gruppenchat zu starten',
                      textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade500)),
                ],
              ),
            );
          }

          // Build chat list entries sorted by last message
          final chatEntries = trips.map((trip) {
            final msgs = chatProv.messagesForTrip(trip.id);
            final lastMsg = msgs.isNotEmpty ? msgs.last : null;
            final unread = msgs.where((m) => !m.isRead && m.senderId != 'CurrentUserID').length;
            return (trip: trip, lastMsg: lastMsg, unread: unread);
          }).toList()
            ..sort((a, b) {
              final aTime = a.lastMsg?.timestamp ?? a.trip.startDate;
              final bTime = b.lastMsg?.timestamp ?? b.trip.startDate;
              return bTime.compareTo(aTime);
            });

          return ListView.separated(
            itemCount: chatEntries.length,
            separatorBuilder: (_, __) => const Divider(height: 1, indent: 76),
            itemBuilder: (_, i) {
              final e = chatEntries[i];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                leading: Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(shape: BoxShape.circle, gradient: AppColors.primaryGradient),
                  child: const Icon(Icons.flight, color: Colors.white, size: 22),
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(e.trip.title,
                          style: TextStyle(fontWeight: e.unread > 0 ? FontWeight.bold : FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                    if (e.lastMsg != null)
                      Text(_timeLabel(e.lastMsg!.timestamp),
                          style: TextStyle(fontSize: 11, color: e.unread > 0 ? AppColors.primary : Colors.grey)),
                  ],
                ),
                subtitle: Row(
                  children: [
                    Expanded(
                      child: Text(
                        e.lastMsg != null
                            ? (e.lastMsg!.senderId == 'CurrentUserID' ? 'Du: ${e.lastMsg!.content}' : '${e.lastMsg!.senderName}: ${e.lastMsg!.content}')
                            : 'Noch keine Nachrichten',
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontStyle: e.lastMsg == null ? FontStyle.italic : FontStyle.normal),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (e.unread > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(11)),
                        child: Text('${e.unread}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                  ],
                ),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(trip: e.trip))),
              );
            },
          );
        },
      ),
    );
  }

  String _timeLabel(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
    final yesterday = now.subtract(const Duration(days: 1));
    if (date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day) {
      return 'Gestern';
    }
    return '${date.day}.${date.month}.${date.year}';
  }
}
