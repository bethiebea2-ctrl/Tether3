import 'package:sqflite/sqflite.dart';
import '../models/person.dart';
import 'database_helper.dart';

class PeopleDao {
  Future<Database> get _db => DatabaseHelper().database;

  Future<void> insert(Person person) async {
    final db = await _db;
    final row = Map<String, dynamic>.from(person.toMap());
    row['pet_profile_json'] ??= '{}';
    row['feature_toggles'] ??= '{}';
    row['teen_privacy_json'] ??= '{}';
    await db.insert('people', row);
  }

  Future<void> update(Person person) async {
    final db = await _db;
    final row = Map<String, dynamic>.from(person.toMap());
    row['pet_profile_json'] ??= '{}';
    await db.update('people', row, where: 'id = ?', whereArgs: [person.id]);
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
