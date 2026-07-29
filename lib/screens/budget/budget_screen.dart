import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../database/budget_dao.dart';
import '../../providers/budget_provider.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BudgetProvider>().load();
    });
  }

  Future<void> _addEntry() async {
    final budget = context.read<BudgetProvider>();
    final amountController = TextEditingController();
    final noteController = TextEditingController();
    var type = 'expense';
    var categoryId = budget.categories.isNotEmpty ? budget.categories.first.id : 'general';

    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModal) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Add entry', style: BethTypography.subheading),
                  Row(
                    children: [
                      ChoiceChip(
                        label: const Text('Expense'),
                        selected: type == 'expense',
                        onSelected: (_) => setModal(() => type = 'expense'),
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('Income'),
                        selected: type == 'income',
                        onSelected: (_) => setModal(() => type = 'income'),
                      ),
                    ],
                  ),
                  TextField(
                    controller: amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Amount'),
                  ),
                  if (type == 'expense')
                    DropdownButtonFormField<String>(
                      value: categoryId,
                      items: budget.categories
                          .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
                          .toList(),
                      onChanged: (v) => setModal(() => categoryId = v ?? categoryId),
                      decoration: const InputDecoration(labelText: 'Category'),
                    ),
                  TextField(
                    controller: noteController,
                    decoration: const InputDecoration(labelText: 'Note (optional)'),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('Save'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (saved != true || !mounted) return;
    final amount = double.tryParse(amountController.text.trim());
    if (amount == null) return;
    await budget.addEntry(
      type: type,
      amount: amount,
      categoryId: type == 'income' ? 'general' : categoryId,
      note: noteController.text.trim().isEmpty ? null : noteController.text.trim(),
    );
  }

  Future<void> _editCategory(BudgetCategory? existing) async {
    final name = TextEditingController(text: existing?.name ?? '');
    final amount = TextEditingController(
      text: existing != null ? existing.budgetAmount.toStringAsFixed(0) : '100',
    );
    var colour = existing?.colour ?? '#66BB6A';
    final colours = ['#66BB6A', '#42A5F5', '#7EC8E3', '#F06292', '#FFA726', '#B8A9D4', '#9E9E9E'];

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => AlertDialog(
          title: Text(existing == null ? 'Add category' : 'Edit category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: name, decoration: const InputDecoration(labelText: 'Name')),
              TextField(
                controller: amount,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Budget amount'),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: colours.map((c) {
                  return GestureDetector(
                    onTap: () => setModal(() => colour = c),
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: Color(int.parse(c.replaceFirst('#', '0xFF'))),
                      child: colour == c ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save')),
          ],
        ),
      ),
    );
    if (ok != true || !mounted) return;
    final budgetAmt = double.tryParse(amount.text.trim()) ?? 0;
    await context.read<BudgetProvider>().upsertCategory(
          BudgetCategory(
            id: existing?.id ?? const Uuid().v4(),
            name: name.text.trim().isEmpty ? 'Category' : name.text.trim(),
            colour: colour,
            budgetAmount: budgetAmt,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final budget = context.watch<BudgetProvider>();

    return Scaffold(
      backgroundColor: BethColours.background,
      appBar: AppBar(
        title: const Text('Budget'),
        actions: [
          IconButton(
            tooltip: 'Manage categories',
            onPressed: () => _editCategory(null),
            icon: const Icon(Icons.category_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: budget.isLoaded ? _addEntry : null,
        child: const Icon(Icons.add),
      ),
      body: !budget.isLoaded
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: BethColours.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text('This period · overview', style: BethTypography.caption),
                      const SizedBox(height: 8),
                      _row('Income', budget.incomeTotal, BethColours.green),
                      _row('Spent', budget.expenseTotal, BethColours.red),
                      _row('Remaining', budget.remaining, BethColours.primary),
                      const SizedBox(height: 8),
                      Text(
                        'Tim can help with insights — not financial advice.',
                        style: BethTypography.caption,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text('Categories', style: BethTypography.subheading),
                const SizedBox(height: 8),
                ...budget.categories.map((cat) {
                  final spent = budget.spentInCategory(cat.id);
                  final ratio = cat.budgetAmount <= 0 ? 0.0 : (spent / cat.budgetAmount).clamp(0.0, 1.5);
                  final colour = budget.barColour(spent, cat.budgetAmount);
                  return InkWell(
                    onTap: () => _editCategory(cat),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 8,
                                backgroundColor:
                                    Color(int.parse(cat.colour.replaceFirst('#', '0xFF'))),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(cat.name, style: BethTypography.bodySmall),
                              ),
                              Text(
                                '\$${spent.toStringAsFixed(0)} of \$${cat.budgetAmount.toStringAsFixed(0)}',
                                style: BethTypography.caption,
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: ratio > 1 ? 1 : ratio,
                              minHeight: 10,
                              backgroundColor: BethColours.surfaceAlt,
                              color: colour,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 16),
                Text('Recent entries', style: BethTypography.subheading),
                const SizedBox(height: 8),
                if (budget.entries.isEmpty)
                  Text('No entries yet.', style: BethTypography.caption)
                else
                  ...budget.entries.take(30).map((e) {
                    final isIncome = e.type == 'income';
                    final cat = budget.categoryById(e.categoryId);
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(e.note ?? cat?.name ?? e.categoryId),
                      subtitle: Text(e.date.toString().split(' ').first),
                      trailing: Text(
                        '${isIncome ? '+' : '-'}\$${e.amount.toStringAsFixed(2)}',
                        style: TextStyle(color: isIncome ? BethColours.green : BethColours.red),
                      ),
                      onLongPress: () => budget.deleteEntry(e.id),
                    );
                  }),
              ],
            ),
    );
  }

  Widget _row(String label, double value, Color colour) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(label, style: BethTypography.bodySmall),
          const Spacer(),
          Text(
            '\$${value.toStringAsFixed(2)}',
            style: BethTypography.bodySmall?.copyWith(color: colour, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
