import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/database_service.dart';

class BudgetProvider extends ChangeNotifier {
  List<BudgetExpense> _expenses = [];
  List<BudgetExpense> get expenses => _expenses;

  Future<void> loadExpenses() async {
    _expenses = await DatabaseService.getExpenses();
    notifyListeners();
  }

  List<BudgetExpense> expensesForTrip(String tripId) =>
      _expenses.where((e) => e.tripId == tripId).toList()
        ..sort((a, b) => b.date.compareTo(a.date));

  double totalExpensesForTrip(String tripId) =>
      expensesForTrip(tripId).fold(0, (sum, e) => sum + e.amount);

  Future<void> addExpense(BudgetExpense expense) async {
    await DatabaseService.insertExpense(expense);
    _expenses.add(expense);
    notifyListeners();
  }

  Future<void> deleteExpense(BudgetExpense expense) async {
    await DatabaseService.deleteExpense(expense.id);
    _expenses.removeWhere((e) => e.id == expense.id);
    notifyListeners();
  }

  double calculateSplitAmount(BudgetExpense expense) {
    if (expense.splitWith.isEmpty) return 0;
    return expense.amount / (expense.splitWith.length + 1);
  }

  /// Per-person spending map for a trip
  Map<String, double> perPersonSpending(String tripId) {
    final map = <String, double>{};
    for (final e in expensesForTrip(tripId)) {
      map[e.paidBy] = (map[e.paidBy] ?? 0) + e.amount;
    }
    return map;
  }

  /// Category breakdown for a trip
  Map<String, double> categoryBreakdown(String tripId) {
    final map = <String, double>{};
    for (final e in expensesForTrip(tripId)) {
      map[e.category] = (map[e.category] ?? 0) + e.amount;
    }
    return map;
  }

  /// Debt settlement for a trip
  List<({String from, String to, double amount})> settlements(String tripId) {
    final tripExpenses = expensesForTrip(tripId);
    final balances = <String, double>{};

    for (final expense in tripExpenses) {
      final people = expense.splitWith.isEmpty ? [expense.paidBy] : expense.splitWith;
      final share = expense.amount / people.length.clamp(1, 999);
      balances[expense.paidBy] = (balances[expense.paidBy] ?? 0) + expense.amount;
      for (final person in people) {
        balances[person] = (balances[person] ?? 0) - share;
      }
    }

    final debtors = balances.entries
        .where((e) => e.value < -0.01)
        .map((e) => (name: e.key, amount: -e.value))
        .toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));

    final creditors = balances.entries
        .where((e) => e.value > 0.01)
        .map((e) => (name: e.key, amount: e.value))
        .toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));

    final result = <({String from, String to, double amount})>[];
    var i = 0, j = 0;
    final dList = debtors.map((d) => [d.name, d.amount]).toList();
    final cList = creditors.map((c) => [c.name, c.amount]).toList();

    while (i < dList.length && j < cList.length) {
      final amount = (dList[i][1] as double) < (cList[j][1] as double)
          ? dList[i][1] as double
          : cList[j][1] as double;
      if (amount > 0.01) {
        result.add((from: dList[i][0] as String, to: cList[j][0] as String, amount: amount));
      }
      dList[i][1] = (dList[i][1] as double) - amount;
      cList[j][1] = (cList[j][1] as double) - amount;
      if ((dList[i][1] as double) < 0.01) i++;
      if ((cList[j][1] as double) < 0.01) j++;
    }
    return result;
  }
}
