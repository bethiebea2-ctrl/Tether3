import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/auth_user.dart';

/// Chrome/web auth storage — avoids fragile SQLite auth tables in the browser.
class AuthPrefsStore {
  static const _usersKey = 'phase2a_auth_users_v1';
  static const _onboardingKey = 'phase2a_auth_onboarding_v1';
  static const _sessionUserIdKey = 'phase2a_auth_session_user_id';
  static const _legacySessionKey = 'auth_session_user_id';

  /// Fixed port used by [scripts/run_chrome.sh] — web auth is per-origin (port).
  static const webDevPort = 7357;

  Future<String?> getSessionUserId() async {
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getString(_sessionUserIdKey);
    if (id != null && id.isNotEmpty) return id;
    // Migrate session from early 2A builds.
    id = prefs.getString(_legacySessionKey);
    if (id != null && id.isNotEmpty) {
      await prefs.setString(_sessionUserIdKey, id);
      await prefs.remove(_legacySessionKey);
    }
    return id;
  }

  Future<void> setSessionUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionUserIdKey, userId);
    await prefs.remove(_legacySessionKey);
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionUserIdKey);
    await prefs.remove(_legacySessionKey);
  }

  Future<List<Map<String, dynamic>>> _loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_usersKey);
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw);
    if (decoded is! List) return [];
    return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  Future<void> _saveUsers(List<Map<String, dynamic>> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usersKey, jsonEncode(users));
  }

  Future<Map<String, Map<String, dynamic>>> _loadOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_onboardingKey);
    if (raw == null || raw.isEmpty) return {};
    final decoded = jsonDecode(raw);
    if (decoded is! Map) return {};
    return decoded.map(
      (k, v) => MapEntry(k.toString(), Map<String, dynamic>.from(v as Map)),
    );
  }

  Future<void> _saveOnboarding(Map<String, Map<String, dynamic>> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_onboardingKey, jsonEncode(data));
  }

  Future<void> insertUser(AuthUser user, String passwordHash) async {
    final users = await _loadUsers();
    final email = user.email.trim().toLowerCase();
    if (users.any((u) => (u['email'] as String?)?.toLowerCase() == email)) {
      throw StateError('duplicate_email');
    }
    users.add({
      ...user.toMap(),
      'password_hash': passwordHash,
    });
    await _saveUsers(users);
  }

  Future<AuthUser?> getUserById(String id) async {
    final users = await _loadUsers();
    for (final row in users) {
      if (row['id']?.toString() == id) {
        return AuthUser.fromMap(row);
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?> getUserRowByEmail(String email) async {
    final normalized = email.trim().toLowerCase();
    final users = await _loadUsers();
    for (final row in users) {
      if ((row['email'] as String?)?.toLowerCase() == normalized) {
        return row;
      }
    }
    return null;
  }

  Future<void> updateUser(AuthUser user) async {
    final users = await _loadUsers();
    final idx = users.indexWhere((u) => u['id']?.toString() == user.id);
    if (idx < 0) return;
    final hash = users[idx]['password_hash'];
    users[idx] = {...user.toMap(), 'password_hash': hash};
    await _saveUsers(users);
  }

  Future<Map<String, dynamic>?> getOnboardingState(String userId) async {
    final data = await _loadOnboarding();
    return data[userId];
  }

  Future<void> upsertOnboardingState({
    required String userId,
    required bool completed,
    String? tier,
  }) async {
    final data = await _loadOnboarding();
    data[userId] = {
      'user_id': userId,
      'completed': completed ? 1 : 0,
      'tier': tier,
      'completed_at': completed ? DateTime.now().toIso8601String() : null,
    };
    await _saveOnboarding(data);
  }
}
