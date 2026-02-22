import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/database_service.dart';

class FriendsProvider extends ChangeNotifier {
  List<Friend> _friends = [];
  List<Friend> get friends => _friends;

  List<Friend> get acceptedFriends =>
      _friends.where((f) => f.status == 'accepted').toList()
        ..sort((a, b) => a.friendName.compareTo(b.friendName));

  List<Friend> get pendingRequests =>
      _friends.where((f) => f.status == 'pending').toList();

  Future<void> loadFriends() async {
    _friends = await DatabaseService.getFriends();
    notifyListeners();
  }

  Future<void> addFriend(String name, String email) async {
    final f = Friend(friendName: name, friendEmail: email, status: 'pending');
    await DatabaseService.insertFriend(f);
    _friends.add(f);
    notifyListeners();
  }

  Future<void> acceptFriend(Friend friend) async {
    friend.status = 'accepted';
    await DatabaseService.updateFriend(friend);
    notifyListeners();
  }

  Future<void> removeFriend(Friend friend) async {
    await DatabaseService.deleteFriend(friend.id);
    _friends.removeWhere((f) => f.id == friend.id);
    notifyListeners();
  }
}
