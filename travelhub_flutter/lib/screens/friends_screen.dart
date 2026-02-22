import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/friends_provider.dart';
import '../widgets/user_avatar.dart';

/// Pendant zu FriendsView.swift
class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  String _selectedTab = 'Friends';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add, color: Colors.blue),
            onPressed: () => _showAddFriend(context),
          ),
        ],
      ),
      body: Consumer<FriendsProvider>(
        builder: (context, prov, _) {
          final accepted = prov.acceptedFriends;
          final pending = prov.pendingRequests;

          return Column(
            children: [
              // Tab navigation
              Row(
                children: [
                  _tab('Friends', pending: 0),
                  _tab('Requests', pending: pending.length),
                ],
              ),
              const Divider(height: 1),
              Expanded(
                child: _selectedTab == 'Friends' ? _friendsList(accepted, prov) : _requestsList(pending, prov),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _tab(String label, {int pending = 0}) {
    final selected = _selectedTab == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: selected ? Colors.blue : Colors.transparent, width: 2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: selected ? Colors.blue : Colors.grey)),
              if (pending > 0) ...[
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  child: Text('$pending', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _friendsList(List<Friend> friends, FriendsProvider prov) {
    if (friends.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_outline, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            const Text('No friends yet', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Add a friend to get started', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: friends.length,
      itemBuilder: (_, i) {
        final f = friends[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              UserAvatar(name: f.friendName, size: 44),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(f.friendName, style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(f.friendEmail, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  ],
                ),
              ),
              PopupMenuButton(
                itemBuilder: (_) => [
                  const PopupMenuItem(value: 'remove', child: Text('Remove', style: TextStyle(color: Colors.red))),
                ],
                onSelected: (_) => prov.removeFriend(f),
                icon: Icon(Icons.more_horiz, color: Colors.grey.shade400),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _requestsList(List<Friend> requests, FriendsProvider prov) {
    if (requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, size: 48, color: Colors.green),
            const SizedBox(height: 12),
            const Text('All caught up!', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('You have no pending requests', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: requests.length,
      itemBuilder: (_, i) {
        final f = requests[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.blue.withOpacity(0.05), borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              UserAvatar(name: f.friendName, size: 44),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(f.friendName, style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(f.friendEmail, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  ],
                ),
              ),
              IconButton(icon: const Icon(Icons.cancel, color: Colors.grey), onPressed: () => prov.removeFriend(f)),
              IconButton(icon: const Icon(Icons.check_circle, color: Colors.green), onPressed: () => prov.acceptFriend(f)),
            ],
          ),
        );
      },
    );
  }

  void _showAddFriend(BuildContext context) {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(ctx).viewInsets.bottom + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Add Friend', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(controller: nameCtrl, decoration: const InputDecoration(hintText: 'Name')),
            const SizedBox(height: 12),
            TextField(controller: emailCtrl, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(hintText: 'Email')),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (nameCtrl.text.isNotEmpty && emailCtrl.text.isNotEmpty) {
                    context.read<FriendsProvider>().addFriend(nameCtrl.text, emailCtrl.text);
                    Navigator.pop(ctx);
                  }
                },
                child: const Text('Send Request'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
