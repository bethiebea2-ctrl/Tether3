import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../database/database_helper.dart';
import 'budget_provider.dart';

extension Budget1d on BudgetProvider {
  // Marker for 1D features living on BudgetExtrasProvider
}

class BudgetExtrasProvider extends ChangeNotifier {
  final _uuid = const Uuid();
  List<Map<String, dynamic>> sinkingFunds = [];
  List<Map<String, dynamic>> bills = [];
  List<Map<String, dynamic>> savingsGoals = [];
  List<Map<String, dynamic>> subscriptions = [];
  bool loaded = false;

  Future<Database> get _db => DatabaseHelper().database;

  Future<void> load() async {
    final db = await _db;
    sinkingFunds = await db.query('sinking_funds', orderBy: 'name ASC');
    bills = await db.query('bills', orderBy: 'due_date ASC');
    savingsGoals = await db.query('savings_goals', orderBy: 'name ASC');
    subscriptions = await db.query('subscriptions', orderBy: 'name ASC');
    loaded = true;
    notifyListeners();
  }

  Future<void> addSinkingFund(String name, double target) async {
    final db = await _db;
    await db.insert('sinking_funds', {
      'id': _uuid.v4(),
      'name': name,
      'target_amount': target,
      'current_amount': 0,
      'notes': null,
      'created_at': DateTime.now().toIso8601String(),
    });
    await load();
  }

  Future<void> addBill(String name, double amount, DateTime due) async {
    final db = await _db;
    await db.insert('bills', {
      'id': _uuid.v4(),
      'name': name,
      'amount': amount,
      'due_date': due.toIso8601String(),
      'recurrence': 'monthly',
      'paid': 0,
      'notes': null,
    });
    await load();
  }

  Future<void> addSavingsGoal(String name, double target) async {
    final db = await _db;
    await db.insert('savings_goals', {
      'id': _uuid.v4(),
      'name': name,
      'target_amount': target,
      'current_amount': 0,
      'notes': null,
      'created_at': DateTime.now().toIso8601String(),
    });
    await load();
  }

  Future<void> addSubscription(String name, double amount) async {
    final db = await _db;
    await db.insert('subscriptions', {
      'id': _uuid.v4(),
      'name': name,
      'amount': amount,
      'period': 'monthly',
      'next_due': DateTime.now().add(const Duration(days: 30)).toIso8601String(),
      'active': 1,
      'notes': null,
    });
    await load();
  }

  Future<void> toggleBillPaid(String id, bool paid) async {
    final db = await _db;
    await db.update('bills', {'paid': paid ? 1 : 0}, where: 'id = ?', whereArgs: [id]);
    await load();
  }
}
