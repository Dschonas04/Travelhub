/// Voting‐Activity Modell (lokal, nicht persistiert)
class VotingActivity {
  final String id;
  String name;
  String description;
  String iconName;
  Map<String, int> ratings; // userName -> 1-5

  VotingActivity({
    String? id,
    required this.name,
    this.description = '',
    this.iconName = 'star',
    Map<String, int>? ratings,
  })  : id = id ?? DateTime.now().microsecondsSinceEpoch.toString(),
        ratings = ratings ?? {};

  double get averageRating {
    if (ratings.isEmpty) return 0;
    return ratings.values.fold<int>(0, (a, b) => a + b) / ratings.length;
  }
}
