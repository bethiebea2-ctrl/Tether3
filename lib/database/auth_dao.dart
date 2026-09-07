import 'package:sqflite/sqflite.dart';
import '../models/auth_user.dart';
import 'database_helper.dart';

class AuthDao {
  Future<Database> get _db => DatabaseHelper().database;

  Future<void> insertUser(AuthUser user, String passwordHash) async {
    final db = await _db;
    await db.insert('auth_users', {
      ...user.toMap(),
      'password_hash': passwordHash,
    });
  }

  Future<AuthUser?> getUserById(String id) async {
    final db = await _db;
    final rows = await db.query('auth_users', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return AuthUser.fromMap(rows.first);
  }

  Future<Map<String, dynamic>?> getUserRowByEmail(String email) async {
    final db = await _db;
    final rows = await db.query(
      'auth_users',
      where: 'email = ?',
      whereArgs: [email.trim().toLowerCase()],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return rows.first;
  }

  Future<void> updateUser(AuthUser user) async {
    final db = await _db;
    await db.update('auth_users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  Future<Map<String, dynamic>?> getOnboardingState(String userId) async {
    final db = await _db;
    final rows = await db.query(
      'onboarding_state',
      where: 'user_id = ?',
      whereArgs: [userId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return rows.first;
  }

  Future<void> upsertOnboardingState({
    required String userId,
    required bool completed,
    String? tier,
  }) async {
    final db = await _db;
    await db.insert(
      'onboarding_state',
      {
        'user_id': userId,
        'completed': completed ? 1 : 0,
        'tier': tier,
        'completed_at': completed ? DateTime.now().toIso8601String() : null,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
