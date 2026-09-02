import 'package:sqflite/sqflite.dart';
import '../core/tasks/task_item.dart';
import 'database_helper.dart';

class TaskDao {
  Future<Database> get _db => DatabaseHelper().database;

  Future<List<TaskItem>> getAll() async {
    final db = await _db;
    final rows = await db.query('tasks', orderBy: 'created_at DESC');
    return rows.map(TaskItem.fromMap).toList();
  }

  Future<void> upsert(TaskItem task) async {
    final db = await _db;
    await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete(String id) async {
    final db = await _db;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
