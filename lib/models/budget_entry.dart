class BudgetEntry {
  final String id;
  final String type; // income, expense
  final double amount;
  final String categoryId;
  final DateTime date;
  final String? note;
  final DateTime createdAt;

  const BudgetEntry({
    required this.id,
    required this.type,
    required this.amount,
    required this.categoryId,
    required this.date,
    this.note,
    required this.createdAt,
  });
}
