import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';
import '../core/auth/auth_prefs_store.dart';
import '../models/auth_user.dart';
import 'database_helper.dart';

/// Auth persistence — SharedPreferences on web, SQLite elsewhere.
class AuthRepository {
  AuthRepository({AuthPrefsStore? prefsStore}) : _prefs = prefsStore ?? AuthPrefsStore();

  final AuthPrefsStore _prefs;

  Future<Database> get _db => DatabaseHelper().database;

  Future<void> insertUser(AuthUser user, String passwordHash) async {
    if (kIsWeb) {
      await _prefs.insertUser(user, passwordHash);
      return;
    }
    final db = await _db;
    await db.insert('auth_users', {
      ...user.toMap(),
      'password_hash': passwordHash,
    });
  }

  Future<AuthUser?> getUserById(String id) async {
    if (kIsWeb) return _prefs.getUserById(id);
    final db = await _db;
    final rows = await db.query('auth_users', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return AuthUser.fromMap(rows.first);
  }

  Future<Map<String, dynamic>?> getUserRowByEmail(String email) async {
    if (kIsWeb) return _prefs.getUserRowByEmail(email);
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
    if (kIsWeb) {
      await _prefs.updateUser(user);
      return;
    }
    final db = await _db;
    await db.update('auth_users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  Future<Map<String, dynamic>?> getOnboardingState(String userId) async {
    if (kIsWeb) return _prefs.getOnboardingState(userId);
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
    if (kIsWeb) {
      await _prefs.upsertOnboardingState(
        userId: userId,
        completed: completed,
        tier: tier,
      );
      return;
    }
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
