import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class RouteLocation {
  final String id;
  String tripId;
  String name;
  double latitude;
  double longitude;
  DateTime visitDate;
  int duration; // in days
  String notes;
  int order;

  RouteLocation({
    String? id,
    required this.tripId,
    required this.name,
    required this.visitDate,
    this.latitude = 0,
    this.longitude = 0,
    this.duration = 1,
    this.notes = '',
    this.order = 0,
  }) : id = id ?? _uuid.v4();

  Map<String, dynamic> toMap() => {
        'id': id,
        'tripId': tripId,
        'name': name,
        'latitude': latitude,
        'longitude': longitude,
        'visitDate': visitDate.toIso8601String(),
        'duration': duration,
        'notes': notes,
        'orderIndex': order,
      };

  factory RouteLocation.fromMap(Map<String, dynamic> m) => RouteLocation(
        id: m['id'] as String,
        tripId: m['tripId'] as String,
        name: m['name'] as String,
        visitDate: DateTime.parse(m['visitDate'] as String),
        latitude: (m['latitude'] as num?)?.toDouble() ?? 0,
        longitude: (m['longitude'] as num?)?.toDouble() ?? 0,
        duration: (m['duration'] as int?) ?? 1,
        notes: (m['notes'] ?? '') as String,
        order: (m['orderIndex'] as int?) ?? 0,
      );
}
