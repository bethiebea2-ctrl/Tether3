import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../core/auth/password_hash.dart';
import '../database/auth_repository.dart';
import '../models/auth_user.dart';
import '../services/activity_ledger_service.dart';

class AuthProvider extends ChangeNotifier {
  static const _sessionKey = 'auth_session_user_id';

  final AuthRepository _authRepo = AuthRepository();
  final _uuid = const Uuid();

  AuthUser? _user;
  bool _initialized = false;
  bool _onboardingCompleted = false;
  String? _onboardingTier;

  AuthUser? get user => _user;
  bool get isInitialized => _initialized;
  bool get isSignedIn => _user != null;
  bool get onboardingCompleted => _onboardingCompleted;
  String? get onboardingTier => _onboardingTier;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(_sessionKey);
    if (userId != null) {
      _user = await _authRepo.getUserById(userId);
      if (_user != null) {
        await _loadOnboardingState();
      } else {
        await prefs.remove(_sessionKey);
      }
    }
    _initialized = true;
    notifyListeners();
  }

  Future<void> _loadOnboardingState() async {
    if (_user == null) return;
    final row = await _authRepo.getOnboardingState(_user!.id);
    _onboardingCompleted = (row?['completed'] as int? ?? 0) == 1;
    _onboardingTier = row?['tier'] as String?;
  }

  Future<String?> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final normalized = email.trim().toLowerCase();
      if (normalized.isEmpty || password.length < 6) {
        return 'Use a valid email and password (6+ characters).';
      }
      final existing = await _authRepo.getUserRowByEmail(normalized);
      if (existing != null) {
        return 'An account with this email already exists.';
      }
      final now = DateTime.now();
      final user = AuthUser(
        id: _uuid.v4(),
        email: normalized,
        displayName: displayName.trim().isEmpty ? normalized.split('@').first : displayName.trim(),
        createdAt: now,
        updatedAt: now,
      );
      await _authRepo.insertUser(user, hashPassword(normalized, password));
      await _authRepo.upsertOnboardingState(userId: user.id, completed: false);
      await _setSession(user);
      unawaited(ActivityLedgerService.instance.log(
        action: 'Created your Tether account',
        userId: user.id,
        actorLabel: user.displayName,
        detail: normalized,
      ));
      return null;
    } catch (e) {
      // ignore: avoid_print
      print('signUp failed: $e');
      if (e.toString().contains('duplicate_email')) {
        return 'An account with this email already exists.';
      }
      return 'Could not create account ($e).';
    }
  }

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final normalized = email.trim().toLowerCase();
      final row = await _authRepo.getUserRowByEmail(normalized);
      if (row == null) {
        return 'No account found for that email.';
      }
      final stored = row['password_hash'] as String? ?? '';
      if (!verifyPassword(normalized, password, stored)) {
        return 'Incorrect password.';
      }
      final user = AuthUser.fromMap(row);
      await _setSession(user);
      unawaited(ActivityLedgerService.instance.log(
        action: 'Signed in',
        userId: user.id,
        actorLabel: user.displayName,
      ));
      return null;
    } catch (e) {
      // ignore: avoid_print
      print('signIn failed: $e');
      return 'Could not sign in. Try again or clear Chrome site data for localhost.';
    }
  }

  Future<void> signOut() async {
    final name = _user?.displayName;
    final id = _user?.id;
    if (id != null) {
      await ActivityLedgerService.instance.log(
        action: 'Signed out',
        userId: id,
        actorLabel: name ?? 'You',
      );
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
    _user = null;
    _onboardingCompleted = false;
    _onboardingTier = null;
    notifyListeners();
  }

  Future<String?> updateProfile({required String displayName}) async {
    if (_user == null) return 'Not signed in.';
    final trimmed = displayName.trim();
    if (trimmed.isEmpty) return 'Display name cannot be empty.';
    final updated = _user!.copyWith(displayName: trimmed, updatedAt: DateTime.now());
    await _authRepo.updateUser(updated);
    _user = updated;
    notifyListeners();
    await ActivityLedgerService.instance.log(
      action: 'Updated profile name',
      userId: updated.id,
      actorLabel: updated.displayName,
      detail: trimmed,
    );
    return null;
  }

  Future<void> completeOnboarding(String tier) async {
    if (_user == null) return;
    await _authRepo.upsertOnboardingState(
      userId: _user!.id,
      completed: true,
      tier: tier,
    );
    _onboardingCompleted = true;
    _onboardingTier = tier;
    notifyListeners();
    await ActivityLedgerService.instance.log(
      action: 'Completed onboarding',
      userId: _user!.id,
      actorLabel: _user!.displayName,
      detail: tier,
    );
  }

  Future<void> refreshOnboardingState() async {
    await _loadOnboardingState();
    notifyListeners();
  }

  Future<void> _setSession(AuthUser user) async {
    _user = user;
    await _loadOnboardingState();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, user.id);
    notifyListeners();
  }
}
