import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/database_service.dart';

class TripsProvider extends ChangeNotifier {
  List<Trip> _trips = [];
  List<Trip> get trips => _trips;

  List<Trip> get activeTrips =>
      _trips.where((t) => t.isActive && t.endDate.isAfter(DateTime.now())).toList()
        ..sort((a, b) => a.startDate.compareTo(b.startDate));

  List<Trip> get pastTrips =>
      _trips.where((t) => !t.isActive || t.endDate.isBefore(DateTime.now())).toList()
        ..sort((a, b) => b.startDate.compareTo(a.startDate));

  List<Trip> get upcomingTrips =>
      _trips.where((t) => t.isActive && t.startDate.isAfter(DateTime.now())).toList()
        ..sort((a, b) => a.startDate.compareTo(b.startDate));

  Future<void> loadTrips() async {
    _trips = await DatabaseService.getTrips();
    notifyListeners();
  }

  Future<void> addTrip(Trip trip) async {
    await DatabaseService.insertTrip(trip);
    _trips.add(trip);
    notifyListeners();
  }

  Future<void> updateTrip(Trip trip) async {
    await DatabaseService.updateTrip(trip);
    final idx = _trips.indexWhere((t) => t.id == trip.id);
    if (idx != -1) _trips[idx] = trip;
    notifyListeners();
  }

  Future<void> deleteTrip(Trip trip) async {
    await DatabaseService.deleteTrip(trip.id);
    _trips.removeWhere((t) => t.id == trip.id);
    notifyListeners();
  }

  double get totalBudget =>
      _trips.where((t) => t.isActive).fold(0, (sum, t) => sum + t.budget);
}
