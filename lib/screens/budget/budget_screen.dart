import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../models/budget_entry.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final _uuid = const Uuid();
  final List<BudgetEntry> _entries = [];
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String _type = 'expense';

  void _addEntry() {
    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null) return;

    setState(() {
      _entries.insert(
        0,
        BudgetEntry(
          id: _uuid.v4(),
          type: _type,
          amount: amount,
          categoryId: 'general',
          date: DateTime.now(),
          note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
          createdAt: DateTime.now(),
        ),
      );
    });
    _amountController.clear();
    _noteController.clear();
  }

  double get _balance {
    var total = 0.0;
    for (final e in _entries) {
      total += e.type == 'income' ? e.amount : -e.amount;
    }
    return total;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Budget')),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: BethColours.surface,
            child: Column(
              children: [
                Text('Manual tracker', style: BethTypography.caption),
                Text(
                  '\$${_balance.toStringAsFixed(2)}',
                  style: BethTypography.heading?.copyWith(color: BethColours.primary),
                ),
                Text(
                  'Tim can help with insights — not financial advice.',
                  style: BethTypography.caption,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                DropdownButton<String>(
                  value: _type,
                  items: const [
                    DropdownMenuItem(value: 'expense', child: Text('Expense')),
                    DropdownMenuItem(value: 'income', child: Text('Income')),
                  ],
                  onChanged: (v) => setState(() => _type = v!),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(hintText: 'Amount'),
                  ),
                ),
                IconButton(onPressed: _addEntry, icon: const Icon(Icons.add_circle)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _entries.length,
              itemBuilder: (context, index) {
                final e = _entries[index];
                final isIncome = e.type == 'income';
                return ListTile(
                  title: Text(e.note ?? e.categoryId),
                  subtitle: Text(e.date.toString().split(' ').first),
                  trailing: Text(
                    '${isIncome ? '+' : '-'}\$${e.amount.toStringAsFixed(2)}',
                    style: TextStyle(color: isIncome ? BethColours.green : BethColours.red),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
