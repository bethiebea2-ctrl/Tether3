import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';
import '../core/auth/auth_prefs_store.dart';
import '../models/auth_user.dart';
import 'database_helper.dart';

/// Auth persistence — dual SharedPreferences + SQLite on web (IndexedDB backup),
/// SQLite only on native.
class AuthRepository {
  AuthRepository({AuthPrefsStore? prefsStore}) : _prefs = prefsStore ?? AuthPrefsStore();

  final AuthPrefsStore _prefs;

  Future<Database> get _db => DatabaseHelper().database;

  /// Merge browser storage and IndexedDB after wasm is available.
  Future<void> syncWebAuthStores() async {
    if (!kIsWeb) return;
    try {
      final db = await _db;
      final sqliteRows = await db.query('auth_users');
      for (final row in sqliteRows) {
        await _prefs.upsertUserRow(Map<String, dynamic>.from(row));
      }
      final prefsUsers = await _prefs.listUserRows();
      for (final row in prefsUsers) {
        await _upsertUserSqlite(row);
      }
      final sqliteOnboarding = await db.query('onboarding_state');
      for (final row in sqliteOnboarding) {
        final userId = row['user_id']?.toString();
        if (userId == null) continue;
        await _prefs.upsertOnboardingState(
          userId: userId,
          completed: (row['completed'] as int? ?? 0) == 1,
          tier: row['tier'] as String?,
        );
      }
    } catch (e) {
      // ignore: avoid_print
      print('Auth syncWebAuthStores: $e');
    }
  }

  Future<int> countRegisteredAccounts() async {
    if (!kIsWeb) {
      final db = await _db;
      final rows = await db.rawQuery('SELECT COUNT(*) AS c FROM auth_users');
      return rows.first['c'] as int? ?? 0;
    }
    await syncWebAuthStores();
    return _prefs.registeredAccountCount();
  }

  Future<void> insertUser(AuthUser user, String passwordHash) async {
    if (kIsWeb) {
      await _prefs.insertUser(user, passwordHash);
      await _upsertUserSqlite({
        ...user.toMap(),
        'password_hash': passwordHash,
      });
      return;
    }
    final db = await _db;
    await db.insert('auth_users', {
      ...user.toMap(),
      'password_hash': passwordHash,
    });
  }

  Future<AuthUser?> getUserById(String id) async {
    if (kIsWeb) {
      await syncWebAuthStores();
      return _prefs.getUserById(id);
    }
    final db = await _db;
    final rows = await db.query('auth_users', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return AuthUser.fromMap(rows.first);
  }

  Future<Map<String, dynamic>?> getUserRowByEmail(String email) async {
    if (kIsWeb) {
      await syncWebAuthStores();
      var row = await _prefs.getUserRowByEmail(email);
      if (row != null) return row;
      row = await _getUserRowByEmailSqlite(email);
      if (row != null) {
        await _prefs.upsertUserRow(row);
      }
      return row;
    }
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
      final row = await _prefs.getUserRowByEmail(user.email);
      if (row != null) await _upsertUserSqlite(row);
      return;
    }
    final db = await _db;
    await db.update('auth_users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  Future<Map<String, dynamic>?> getOnboardingState(String userId) async {
    if (kIsWeb) {
      await syncWebAuthStores();
      var row = await _prefs.getOnboardingState(userId);
      if (row != null) return row;
      row = await _getOnboardingSqlite(userId);
      if (row != null) {
        await _prefs.upsertOnboardingState(
          userId: userId,
          completed: (row['completed'] as int? ?? 0) == 1,
          tier: row['tier'] as String?,
        );
      }
      return row;
    }
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
      await _upsertOnboardingSqlite(userId, completed, tier);
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

  Future<Map<String, dynamic>?> _getUserRowByEmailSqlite(String email) async {
    try {
      final db = await _db;
      final rows = await db.query(
        'auth_users',
        where: 'email = ?',
        whereArgs: [email.trim().toLowerCase()],
        limit: 1,
      );
      if (rows.isEmpty) return null;
      return rows.first;
    } catch (e) {
      // ignore: avoid_print
      print('Auth sqlite read failed: $e');
      return null;
    }
  }

  Future<void> _upsertUserSqlite(Map<String, dynamic> row) async {
    try {
      final db = await _db;
      await db.insert(
        'auth_users',
        row,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      // ignore: avoid_print
      print('Auth sqlite mirror failed: $e');
    }
  }

  Future<Map<String, dynamic>?> _getOnboardingSqlite(String userId) async {
    try {
      final db = await _db;
      final rows = await db.query(
        'onboarding_state',
        where: 'user_id = ?',
        whereArgs: [userId],
        limit: 1,
      );
      if (rows.isEmpty) return null;
      return rows.first;
    } catch (e) {
      return null;
    }
  }

  Future<void> _upsertOnboardingSqlite(
    String userId,
    bool completed,
    String? tier,
  ) async {
    try {
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
    } catch (e) {
      // ignore: avoid_print
      print('Auth onboarding sqlite mirror failed: $e');
    }
  }
}
