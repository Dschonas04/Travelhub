import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class Agreement {
  final String id;
  String tripId;
  String title;
  String descriptionText;
  String createdBy;
  List<String> assignedTo;
  String status; // "offen", "inAbstimmung", "beschlossen", "erledigt"
  String category; // "Sonstiges", "Unterkunft", "Transport", "Aktivitäten", "Essen", "Budget"
  DateTime dueDate;
  bool hasDueDate;
  DateTime createdDate;
  String priority; // "niedrig", "mittel", "hoch"
  int votesYes;
  int votesNo;
  bool isResolved;

  Agreement({
    String? id,
    required this.tripId,
    required this.title,
    this.descriptionText = '',
    required this.createdBy,
    List<String>? assignedTo,
    this.status = 'offen',
    this.category = 'Sonstiges',
    DateTime? dueDate,
    this.hasDueDate = false,
    DateTime? createdDate,
    this.priority = 'mittel',
    this.votesYes = 0,
    this.votesNo = 0,
    this.isResolved = false,
  })  : id = id ?? _uuid.v4(),
        assignedTo = assignedTo ?? [],
        dueDate = dueDate ?? DateTime(2100),
        createdDate = createdDate ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'id': id,
        'tripId': tripId,
        'title': title,
        'descriptionText': descriptionText,
        'createdBy': createdBy,
        'assignedTo': assignedTo.join(','),
        'status': status,
        'category': category,
        'dueDate': dueDate.toIso8601String(),
        'hasDueDate': hasDueDate ? 1 : 0,
        'createdDate': createdDate.toIso8601String(),
        'priority': priority,
        'votesYes': votesYes,
        'votesNo': votesNo,
        'isResolved': isResolved ? 1 : 0,
      };

  Agreement copyWith({
    String? tripId,
    String? title,
    String? descriptionText,
    String? createdBy,
    List<String>? assignedTo,
    String? status,
    String? category,
    DateTime? dueDate,
    bool? hasDueDate,
    DateTime? createdDate,
    String? priority,
    int? votesYes,
    int? votesNo,
    bool? isResolved,
  }) =>
      Agreement(
        id: id,
        tripId: tripId ?? this.tripId,
        title: title ?? this.title,
        descriptionText: descriptionText ?? this.descriptionText,
        createdBy: createdBy ?? this.createdBy,
        assignedTo: assignedTo ?? this.assignedTo,
        status: status ?? this.status,
        category: category ?? this.category,
        dueDate: dueDate ?? this.dueDate,
        hasDueDate: hasDueDate ?? this.hasDueDate,
        createdDate: createdDate ?? this.createdDate,
        priority: priority ?? this.priority,
        votesYes: votesYes ?? this.votesYes,
        votesNo: votesNo ?? this.votesNo,
        isResolved: isResolved ?? this.isResolved,
      );

  factory Agreement.fromMap(Map<String, dynamic> m) => Agreement(
        id: m['id'] as String,
        tripId: m['tripId'] as String,
        title: m['title'] as String,
        descriptionText: (m['descriptionText'] ?? '') as String,
        createdBy: m['createdBy'] as String,
        assignedTo: (m['assignedTo'] as String?)?.split(',').where((s) => s.isNotEmpty).toList() ?? [],
        status: (m['status'] ?? 'offen') as String,
        category: (m['category'] ?? 'Sonstiges') as String,
        dueDate: DateTime.parse(m['dueDate'] as String),
        hasDueDate: (m['hasDueDate'] as int?) == 1,
        createdDate: DateTime.parse(m['createdDate'] as String),
        priority: (m['priority'] ?? 'mittel') as String,
        votesYes: (m['votesYes'] as int?) ?? 0,
        votesNo: (m['votesNo'] as int?) ?? 0,
        isResolved: (m['isResolved'] as int?) == 1,
      );
}
