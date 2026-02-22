import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class Poll {
  final String id;
  String tripId;
  String question;
  List<String> options;
  Map<String, List<String>> votes; // option -> list of voterIDs
  DateTime deadline;
  String createdBy;
  DateTime createdDate;
  bool isClosed;

  Poll({
    String? id,
    required this.tripId,
    required this.question,
    required this.options,
    Map<String, List<String>>? votes,
    required this.createdBy,
    DateTime? deadline,
    DateTime? createdDate,
    this.isClosed = false,
  })  : id = id ?? _uuid.v4(),
        votes = votes ?? {for (var o in options) o: <String>[]},
        deadline = deadline ?? DateTime.now().add(const Duration(days: 7)),
        createdDate = createdDate ?? DateTime.now();

  void vote(String option, String voterId) {
    if (!options.contains(option)) return;
    final list = votes[option] ?? [];
    if (!list.contains(voterId)) {
      list.add(voterId);
      votes[option] = list;
    }
  }

  int totalVotesForOption(String option) => (votes[option] ?? []).length;
}
