import 'package:sqflite/sqflite.dart';
import '../models/household.dart';
import 'database_helper.dart';

class HouseholdDao {
  Future<Database> get _db => DatabaseHelper().database;

  Future<void> insertHousehold(Household household) async {
    final db = await _db;
    await db.insert('households', household.toMap());
  }

  Future<void> insertMember(HouseholdMember member) async {
    final db = await _db;
    await db.insert('household_members', member.toMap());
  }

  Future<Household?> getHouseholdById(String id) async {
    final db = await _db;
    final rows = await db.query('households', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return Household.fromMap(rows.first);
  }

  Future<Household?> getHouseholdByInviteCode(String code) async {
    final db = await _db;
    final rows = await db.query(
      'households',
      where: 'invite_code = ?',
      whereArgs: [code.trim().toUpperCase()],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Household.fromMap(rows.first);
  }

  Future<Household?> getPrimaryHouseholdForUser(String userId) async {
    final db = await _db;
    final memberRows = await db.query(
      'household_members',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'joined_at ASC',
      limit: 1,
    );
    if (memberRows.isEmpty) return null;
    return getHouseholdById(memberRows.first['household_id'] as String);
  }

  Future<List<HouseholdMember>> getMembers(String householdId) async {
    final db = await _db;
    final rows = await db.query(
      'household_members',
      where: 'household_id = ?',
      whereArgs: [householdId],
      orderBy: 'joined_at ASC',
    );
    return rows.map(HouseholdMember.fromMap).toList();
  }

  Future<bool> isMember(String householdId, String userId) async {
    final db = await _db;
    final rows = await db.query(
      'household_members',
      where: 'household_id = ? AND user_id = ?',
      whereArgs: [householdId, userId],
      limit: 1,
    );
    return rows.isNotEmpty;
  }
}
