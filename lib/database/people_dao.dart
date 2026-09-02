import 'package:sqflite/sqflite.dart';
import '../models/person.dart';
import 'database_helper.dart';

class PeopleDao {
  Future<Database> get _db => DatabaseHelper().database;

  Future<void> insert(Person person) async {
    final db = await _db;
    await db.insert('people', person.toMap());
  }

  Future<void> update(Person person) async {
    final db = await _db;
    await db.update('people', person.toMap(), where: 'id = ?', whereArgs: [person.id]);
  }

  Future<Person?> getById(String id) async {
    final db = await _db;
    final rows = await db.query('people', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return Person.fromMap(rows.first);
  }

  Future<List<Person>> getAll() async {
    final db = await _db;
    final rows = await db.query('people', orderBy: 'display_name ASC');
    return rows.map(Person.fromMap).toList();
  }

  Future<void> delete(String id) async {
    final db = await _db;
    await db.delete('people', where: 'id = ?', whereArgs: [id]);
  }
}
