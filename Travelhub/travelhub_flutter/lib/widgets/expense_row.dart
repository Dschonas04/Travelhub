import 'package:flutter/material.dart';
import '../models/models.dart';

/// Ausgaben-Zeile (Pendant zu ExpenseRowView.swift)
class ExpenseRow extends StatelessWidget {
  final BudgetExpense expense;
  final VoidCallback? onDelete;

  const ExpenseRow({super.key, required this.expense, this.onDelete});

  Color get _categoryColor {
    switch (expense.category) {
      case 'Food': return Colors.orange;
      case 'Transport': return Colors.red;
      case 'Accommodation': return Colors.purple;
      case 'Activities': return Colors.green;
      default: return Colors.blue;
    }
  }

  IconData get _categoryIcon {
    switch (expense.category) {
      case 'Food': return Icons.restaurant;
      case 'Transport': return Icons.directions_car;
      case 'Accommodation': return Icons.house;
      case 'Activities': return Icons.star;
      default: return Icons.credit_card;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: _categoryColor, borderRadius: BorderRadius.circular(8)),
            child: Icon(_categoryIcon, size: 16, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(expense.expenseDescription, style: const TextStyle(fontWeight: FontWeight.w500)),
                Text('Bezahlt von ${expense.paidBy}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('€${expense.amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(
                '${expense.date.day}.${expense.date.month}.${expense.date.year}',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
