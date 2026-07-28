import 'package:sqflite/sqflite.dart';
import '../models/note_history_entry.dart';
import 'database_helper.dart';

class CaptureDao {
  Future<Database> get _db => DatabaseHelper().database;

  Future<void> insert(NoteHistoryEntry entry) async {
    final db = await _db;
    await db.insert('capture_entries', entry.toMap());
  }

  Future<void> update(NoteHistoryEntry entry) async {
    final db = await _db;
    await db.update(
      'capture_entries',
      entry.toMap(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  Future<List<NoteHistoryEntry>> getAllOrderedByNewest() async {
    final db = await _db;
    final rows = await db.query(
      'capture_entries',
      orderBy: 'created_at ASC',
    );
    return rows.map(NoteHistoryEntry.fromMap).toList();
  }
}
