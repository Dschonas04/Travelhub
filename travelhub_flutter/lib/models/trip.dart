import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class Trip {
  final String id;
  String title;
  String tripDescription;
  DateTime startDate;
  DateTime endDate;
  double budget;
  List<String> members;
  String organizer;
  String destination;
  String imageURL;
  bool isActive;

  Trip({
    String? id,
    required this.title,
    this.tripDescription = '',
    DateTime? startDate,
    DateTime? endDate,
    this.budget = 0,
    List<String>? members,
    this.organizer = '',
    this.destination = '',
    this.imageURL = 'mountain.2',
    this.isActive = true,
  })  : id = id ?? _uuid.v4(),
        startDate = startDate ?? DateTime(2000),
        endDate = endDate ?? DateTime(2100),
        members = members ?? [];

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'tripDescription': tripDescription,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'budget': budget,
        'members': members.join(','),
        'organizer': organizer,
        'destination': destination,
        'imageURL': imageURL,
        'isActive': isActive ? 1 : 0,
      };

  factory Trip.fromMap(Map<String, dynamic> m) => Trip(
        id: m['id'] as String,
        title: m['title'] as String,
        tripDescription: (m['tripDescription'] ?? '') as String,
        startDate: DateTime.parse(m['startDate'] as String),
        endDate: DateTime.parse(m['endDate'] as String),
        budget: (m['budget'] as num).toDouble(),
        members: (m['members'] as String?)?.split(',').where((s) => s.isNotEmpty).toList() ?? [],
        organizer: (m['organizer'] ?? '') as String,
        destination: (m['destination'] ?? '') as String,
        imageURL: (m['imageURL'] ?? 'mountain.2') as String,
        isActive: (m['isActive'] as int?) == 1,
      );
}
