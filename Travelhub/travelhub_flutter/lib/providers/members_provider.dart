import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/database_service.dart';

class MembersProvider extends ChangeNotifier {
  List<TripMember> _members = [];
  List<TripMember> get members => _members;

  Future<void> loadMembers() async {
    _members = await DatabaseService.getMembers();
    notifyListeners();
  }

  List<TripMember> membersForTrip(String tripId) =>
      _members.where((m) => m.tripId == tripId && m.isActive).toList();

  Future<void> addMember(TripMember member) async {
    await DatabaseService.insertMember(member);
    _members.add(member);
    notifyListeners();
  }

  Future<void> updateRole(TripMember member, String newRole) async {
    member.role = newRole;
    await DatabaseService.updateMember(member);
    notifyListeners();
  }

  Future<void> removeMember(TripMember member) async {
    member.isActive = false;
    await DatabaseService.updateMember(member);
    notifyListeners();
  }
}
