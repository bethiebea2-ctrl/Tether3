import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../core/household/household_context.dart';
import '../database/household_repository.dart';
import '../models/household.dart';
import '../services/activity_ledger_service.dart';

class HouseholdProvider extends ChangeNotifier {
  final HouseholdRepository _repo = HouseholdRepository();
  final _uuid = const Uuid();

  Household? _household;
  List<HouseholdMember> _members = [];
  bool _loaded = false;

  Household? get household => _household;
  List<HouseholdMember> get members => List.unmodifiable(_members);
  bool get isLoaded => _loaded;
  bool get hasHousehold => _household != null;

  Future<void> loadForUser(String userId) async {
    _household = await _repo.getPrimaryHouseholdForUser(userId);
    if (_household != null) {
      HouseholdContext.setHouseholdId(_household!.id);
      _members = await _repo.getMembers(_household!.id);
    } else {
      HouseholdContext.reset();
      _members = [];
    }
    _loaded = true;
    notifyListeners();
  }

  Future<void> reset() async {
    _household = null;
    _members = [];
    _loaded = false;
    HouseholdContext.reset();
    notifyListeners();
  }

  String _generateInviteCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = Random();
    return List.generate(6, (_) => chars[random.nextInt(chars.length)]).join();
  }

  Future<String?> createHousehold({
    required String userId,
    required String name,
    String role = 'owner',
  }) async {
    try {
      final trimmed = name.trim();
      if (trimmed.isEmpty) return 'Household name is required.';
      final now = DateTime.now();
      final household = Household(
        id: _uuid.v4(),
        name: trimmed,
        inviteCode: _generateInviteCode(),
        ownerUserId: userId,
        createdAt: now,
        updatedAt: now,
      );
      final member = HouseholdMember(
        id: _uuid.v4(),
        householdId: household.id,
        userId: userId,
        role: role,
        joinedAt: now,
      );
      await _repo.insertHousehold(household);
      await _repo.insertMember(member);
      await _repo.seedShareDefaults(household.id);
      await _repo.migrateDefaultHouseholdRows(household.id);
      _household = household;
      _members = [member];
      HouseholdContext.setHouseholdId(household.id);
      _loaded = true;
      notifyListeners();
      unawaited(ActivityLedgerService.instance.log(
        action: 'Created household',
        userId: userId,
        householdId: household.id,
        detail: trimmed,
      ));
      return null;
    } catch (e) {
      // ignore: avoid_print
      print('createHousehold failed: $e');
      return 'Could not create household ($e).';
    }
  }

  Future<String?> joinHousehold({
    required String userId,
    required String inviteCode,
    String role = 'partner',
  }) async {
    try {
      final household = await _repo.getHouseholdByInviteCode(inviteCode);
      if (household == null) return 'Invite code not found.';
      final already = await _repo.isMember(household.id, userId);
      if (already) return 'You are already in this household.';
      final member = HouseholdMember(
        id: _uuid.v4(),
        householdId: household.id,
        userId: userId,
        role: role,
        joinedAt: DateTime.now(),
      );
      await _repo.insertMember(member);
      _household = household;
      _members = await _repo.getMembers(household.id);
      HouseholdContext.setHouseholdId(household.id);
      _loaded = true;
      notifyListeners();
      unawaited(ActivityLedgerService.instance.log(
        action: 'Joined household',
        userId: userId,
        householdId: household.id,
        detail: household.name,
      ));
      return null;
    } catch (e) {
      // ignore: avoid_print
      print('joinHousehold failed: $e');
      return 'Could not join household ($e).';
    }
  }

  Future<void> refreshMembers() async {
    if (_household == null) return;
    _members = await _repo.getMembers(_household!.id);
    notifyListeners();
  }
}
