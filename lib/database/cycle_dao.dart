import 'package:sqflite/sqflite.dart';
import '../models/cycle_entry.dart';
import 'database_helper.dart';

class CycleDao {
  Future<Database> get _db => DatabaseHelper().database;

  Future<List<CycleEntry>> getAll() async {
    final db = await _db;
    final rows = await db.query('cycle_entries', orderBy: 'period_start_date DESC');
    return rows.map(CycleEntry.fromMap).toList();
  }

  Future<void> insert(CycleEntry entry) async {
    final db = await _db;
    await db.insert('cycle_entries', entry.toMap());
  }

  Future<void> update(CycleEntry entry) async {
    final db = await _db;
    await db.update('cycle_entries', entry.toMap(), where: 'id = ?', whereArgs: [entry.id]);
  }

  Future<void> delete(String id) async {
    final db = await _db;
    await db.delete('cycle_entries', where: 'id = ?', whereArgs: [id]);
  }
}
