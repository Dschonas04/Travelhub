import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/budget_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/expense_row.dart';
import '../widgets/user_avatar.dart';

/// Pendant zu BudgetView.swift
class BudgetScreen extends StatefulWidget {
  final Trip trip;
  const BudgetScreen({super.key, required this.trip});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgetplanung', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF66BB6A), Color(0xFF81C784)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.add_circle, color: Colors.white), onPressed: () => _showAddExpense(context)),
        ],
        bottom: TabBar(
          controller: _tabCtrl,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          tabs: const [Tab(text: 'Übersicht'), Tab(text: 'Ausgaben'), Tab(text: 'Ausgleich')],
        ),
      ),
      body: Consumer<BudgetProvider>(
        builder: (context, budgetProv, _) {
          final expenses = budgetProv.expensesForTrip(widget.trip.id);
          final totalSpent = budgetProv.totalExpensesForTrip(widget.trip.id);
          final budget = widget.trip.budget;

          return TabBarView(
            controller: _tabCtrl,
            children: [
              _overviewTab(budgetProv, totalSpent, budget),
              _expensesTab(expenses, budgetProv),
              _settlementTab(budgetProv, totalSpent),
            ],
          );
        },
      ),
    );
  }

  Widget _overviewTab(BudgetProvider prov, double totalSpent, double budget) {
    final perPerson = prov.perPersonSpending(widget.trip.id);
    final categories = prov.categoryBreakdown(widget.trip.id);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Summary cards
          Row(children: [
            _budgetCard('Gesamtbudget', budget, AppColors.primary, Icons.account_balance_wallet),
            const SizedBox(width: 12),
            _budgetCard('Ausgegeben', totalSpent, Colors.orange, Icons.shopping_cart),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            _budgetCard('Verbleibend', (budget - totalSpent).clamp(0, double.infinity), totalSpent > budget ? Colors.red : Colors.green, Icons.wallet),
            const SizedBox(width: 12),
            _budgetCard('Ausgaben', prov.expensesForTrip(widget.trip.id).length.toDouble(), Colors.purple, Icons.list, isCount: true),
          ]),

          // Progress bar
          if (budget > 0) ...[
            const SizedBox(height: 16),
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Text('Budgetauslastung', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    const Spacer(),
                    Text('${(totalSpent / budget * 100).clamp(0, 999).toInt()}%',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: totalSpent > budget ? Colors.red : AppColors.primary)),
                  ]),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (totalSpent / budget).clamp(0, 1),
                      backgroundColor: Colors.grey.shade200,
                      color: totalSpent > budget ? Colors.red : AppColors.primary,
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Category breakdown
          if (categories.isNotEmpty) ...[
            const SizedBox(height: 16),
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Kategorien', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 12),
                  ...categories.entries.map((e) => _categoryBar(e.key, e.value, totalSpent)),
                ],
              ),
            ),
          ],

          // Per person
          if (perPerson.isNotEmpty) ...[
            const SizedBox(height: 16),
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Pro Person bezahlt', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 12),
                  ...perPerson.entries.map((e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(children: [
                          UserAvatar(name: e.key, size: 32),
                          const SizedBox(width: 10),
                          Text(e.key),
                          const Spacer(),
                          Text('€${e.value.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w600)),
                        ]),
                      )),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _expensesTab(List<BudgetExpense> expenses, BudgetProvider prov) {
    if (expenses.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shopping_cart, size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            const Text('Keine Ausgaben', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Füge deine erste Ausgabe hinzu', style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: expenses.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) => Dismissible(
        key: Key(expenses[i].id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 16),
          color: Colors.red,
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        onDismissed: (_) => prov.deleteExpense(expenses[i]),
        child: ExpenseRow(expense: expenses[i]),
      ),
    );
  }

  Widget _settlementTab(BudgetProvider prov, double totalSpent) {
    final settlements = prov.settlements(widget.trip.id);
    final perPerson = prov.perPersonSpending(widget.trip.id);

    if (settlements.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.verified, size: 48, color: Colors.green.withOpacity(0.5)),
            const SizedBox(height: 16),
            const Text('Alles ausgeglichen!', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Es gibt keine offenen Schulden', style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Schuldenausgleich', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text('Folgende Zahlungen sind nötig:', style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
          const SizedBox(height: 16),
          ...settlements.map((s) => _card(
                child: Row(children: [
                  UserAvatar(name: s.from, size: 40),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(s.from, style: const TextStyle(fontWeight: FontWeight.w600)),
                      Row(children: [
                        Text('zahlt an ', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                        Text(s.to, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                      ]),
                    ]),
                  ),
                  Text('€${s.amount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
                ]),
              )),
        ],
      ),
    );
  }

  // Helper widgets
  Widget _budgetCard(String title, double amount, Color color, IconData icon, {bool isCount = false}) {
    return Expanded(
      child: _card(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(title, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          ]),
          const SizedBox(height: 8),
          Text(isCount ? '${amount.toInt()}' : '€${amount.toStringAsFixed(0)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        ]),
      ),
    );
  }

  Widget _card({required Widget child}) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: child,
      );

  Widget _categoryBar(String cat, double amount, double total) {
    Color color;
    switch (cat) {
      case 'Food': color = Colors.orange;
      case 'Transport': color = Colors.red;
      case 'Accommodation': color = Colors.purple;
      case 'Activities': color = Colors.green;
      default: color = Colors.blue;
    }
    final label = {'Food': 'Essen', 'Transport': 'Transport', 'Accommodation': 'Unterkunft', 'Activities': 'Aktivitäten'}[cat] ?? 'Sonstiges';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        SizedBox(width: 80, child: Text(label, style: const TextStyle(fontSize: 12))),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(value: total > 0 ? amount / total : 0, color: color, backgroundColor: Colors.grey.shade200, minHeight: 14),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(width: 50, child: Text('€${amount.toStringAsFixed(0)}', textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),
      ]),
    );
  }

  void _showAddExpense(BuildContext context) {
    final descCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    String category = 'General';
    String paidBy = 'Max Mustermann';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(ctx).viewInsets.bottom + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Neue Ausgabe', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(controller: descCtrl, decoration: const InputDecoration(hintText: 'Beschreibung')),
            const SizedBox(height: 12),
            TextField(controller: amountCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(prefixText: '€ ', hintText: 'Betrag')),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: category,
              items: ['Food', 'Transport', 'Accommodation', 'Activities', 'General'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => category = v!,
              decoration: const InputDecoration(labelText: 'Kategorie'),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final expense = BudgetExpense(
                    tripId: widget.trip.id,
                    expenseDescription: descCtrl.text,
                    amount: double.tryParse(amountCtrl.text) ?? 0,
                    paidBy: paidBy,
                    category: category,
                  );
                  context.read<BudgetProvider>().addExpense(expense);
                  Navigator.pop(ctx);
                },
                child: const Text('Hinzufügen'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
