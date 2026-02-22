import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class BudgetExpense {
  final String id;
  String tripId;
  String expenseDescription;
  double amount;
  String paidBy;
  String category; // "Food", "Transport", "Accommodation", "Activities", "General"
  List<String> splitWith;
  DateTime date;

  BudgetExpense({
    String? id,
    required this.tripId,
    required this.expenseDescription,
    required this.amount,
    required this.paidBy,
    this.category = 'General',
    List<String>? splitWith,
    DateTime? date,
  })  : id = id ?? _uuid.v4(),
        splitWith = splitWith ?? [],
        date = date ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'id': id,
        'tripId': tripId,
        'expenseDescription': expenseDescription,
        'amount': amount,
        'paidBy': paidBy,
        'category': category,
        'splitWith': splitWith.join(','),
        'date': date.toIso8601String(),
      };

  factory BudgetExpense.fromMap(Map<String, dynamic> m) => BudgetExpense(
        id: m['id'] as String,
        tripId: m['tripId'] as String,
        expenseDescription: m['expenseDescription'] as String,
        amount: (m['amount'] as num).toDouble(),
        paidBy: m['paidBy'] as String,
        category: (m['category'] ?? 'General') as String,
        splitWith: (m['splitWith'] as String?)?.split(',').where((s) => s.isNotEmpty).toList() ?? [],
        date: DateTime.parse(m['date'] as String),
      );
}
