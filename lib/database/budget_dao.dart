import 'package:sqflite/sqflite.dart';
import '../models/budget_entry.dart';
import 'database_helper.dart';

class BudgetCategory {
  final String id;
  final String name;
  final String colour;
  final double budgetAmount;
  final String period;

  const BudgetCategory({
    required this.id,
    required this.name,
    required this.colour,
    this.budgetAmount = 0,
    this.period = 'fortnightly',
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'colour': colour,
        'budget_amount': budgetAmount,
        'period': period,
        'shared_with_ant': 0,
      };

  factory BudgetCategory.fromMap(Map<String, dynamic> map) => BudgetCategory(
        id: map['id'] as String,
        name: map['name'] as String,
        colour: map['colour'] as String,
        budgetAmount: (map['budget_amount'] as num?)?.toDouble() ?? 0,
        period: map['period'] as String? ?? 'fortnightly',
      );
}

class BudgetDao {
  Future<Database> get _db => DatabaseHelper().database;

  Future<List<BudgetCategory>> getCategories() async {
    final db = await _db;
    final rows = await db.query('budget_categories', orderBy: 'name ASC');
    return rows.map(BudgetCategory.fromMap).toList();
  }

  Future<void> upsertCategory(BudgetCategory category) async {
    final db = await _db;
    await db.insert(
      'budget_categories',
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteCategory(String id) async {
    final db = await _db;
    await db.delete('budget_categories', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<BudgetEntry>> getEntries() async {
    final db = await _db;
    final rows = await db.query('budget_entries', orderBy: 'date DESC');
    return rows.map((m) {
      return BudgetEntry(
        id: m['id'] as String,
        type: m['type'] as String,
        amount: (m['amount'] as num).toDouble(),
        categoryId: m['category_id'] as String,
        date: DateTime.parse(m['date'] as String),
        note: m['note'] as String?,
        createdAt: DateTime.parse(m['created_at'] as String),
      );
    }).toList();
  }

  Future<void> insertEntry(BudgetEntry entry) async {
    final db = await _db;
    await db.insert('budget_entries', {
      'id': entry.id,
      'type': entry.type,
      'amount': entry.amount,
      'category_id': entry.categoryId,
      'date': entry.date.toIso8601String(),
      'note': entry.note,
      'is_recurring': 0,
      'source': null,
      'shared_with_ant': 0,
      'created_at': entry.createdAt.toIso8601String(),
    });
  }

  Future<void> deleteEntry(String id) async {
    final db = await _db;
    await db.delete('budget_entries', where: 'id = ?', whereArgs: [id]);
  }
}
