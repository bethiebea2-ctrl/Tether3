import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../database/budget_dao.dart';
import '../models/budget_entry.dart';

class BudgetProvider extends ChangeNotifier {
  final BudgetDao _dao = BudgetDao();
  final _uuid = const Uuid();

  List<BudgetEntry> _entries = [];
  List<BudgetCategory> _categories = [];
  bool _loaded = false;

  List<BudgetEntry> get entries => List.unmodifiable(_entries);
  List<BudgetCategory> get categories => List.unmodifiable(_categories);
  bool get isLoaded => _loaded;

  double get incomeTotal => _entries
      .where((e) => e.type == 'income')
      .fold(0.0, (s, e) => s + e.amount);

  double get expenseTotal => _entries
      .where((e) => e.type == 'expense')
      .fold(0.0, (s, e) => s + e.amount);

  double get remaining => incomeTotal - expenseTotal;

  double spentInCategory(String categoryId) => _entries
      .where((e) => e.type == 'expense' && e.categoryId == categoryId)
      .fold(0.0, (s, e) => s + e.amount);

  Future<void> load() async {
    _categories = await _dao.getCategories();
    if (_categories.isEmpty) {
      await _seedCategories();
      _categories = await _dao.getCategories();
    }
    _entries = await _dao.getEntries();
    _loaded = true;
    notifyListeners();
  }

  Future<void> _seedCategories() async {
    const seeds = [
      BudgetCategory(id: 'groceries', name: 'Groceries', colour: '#66BB6A', budgetAmount: 400),
      BudgetCategory(id: 'bills', name: 'Bills', colour: '#42A5F5', budgetAmount: 350),
      BudgetCategory(id: 'baby', name: 'Baby', colour: '#7EC8E3', budgetAmount: 150),
      BudgetCategory(id: 'date_night', name: 'Date Night', colour: '#F06292', budgetAmount: 80),
      BudgetCategory(id: 'transport', name: 'Transport', colour: '#FFA726', budgetAmount: 120),
      BudgetCategory(id: 'general', name: 'General', colour: '#9E9E9E', budgetAmount: 100),
    ];
    for (final c in seeds) {
      await _dao.upsertCategory(c);
    }
  }

  Future<void> addEntry({
    required String type,
    required double amount,
    required String categoryId,
    String? note,
  }) async {
    final entry = BudgetEntry(
      id: _uuid.v4(),
      type: type,
      amount: amount,
      categoryId: categoryId,
      date: DateTime.now(),
      note: note,
      createdAt: DateTime.now(),
    );
    await _dao.insertEntry(entry);
    _entries = [entry, ..._entries];
    notifyListeners();
  }

  Future<void> upsertCategory(BudgetCategory category) async {
    await _dao.upsertCategory(category);
    final idx = _categories.indexWhere((c) => c.id == category.id);
    if (idx == -1) {
      _categories = [..._categories, category];
    } else {
      _categories = [..._categories]..[idx] = category;
    }
    notifyListeners();
  }

  Future<void> deleteEntry(String id) async {
    await _dao.deleteEntry(id);
    _entries = _entries.where((e) => e.id != id).toList();
    notifyListeners();
  }

  BudgetCategory? categoryById(String id) {
    try {
      return _categories.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  /// 0–1 progress; colour band: green <0.7, amber <1, red >=1
  Color barColour(double spent, double budget) {
    if (budget <= 0) return const Color(0xFF9E9E9E);
    final ratio = spent / budget;
    if (ratio >= 1) return const Color(0xFFEF5350);
    if (ratio >= 0.7) return const Color(0xFFFFA726);
    return const Color(0xFF66BB6A);
  }
}
