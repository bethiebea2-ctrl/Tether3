import 'dart:math';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../core/household/household_context.dart';
import '../database/database_helper.dart';
import '../database/household_dao.dart';
import '../database/share_permissions_dao.dart';
import '../models/household.dart';
import '../services/activity_ledger_service.dart';

class HouseholdProvider extends ChangeNotifier {
  final HouseholdDao _dao = HouseholdDao();
  final SharePermissionsDao _shareDao = SharePermissionsDao();
  final _uuid = const Uuid();

  Household? _household;
  List<HouseholdMember> _members = [];
  bool _loaded = false;

  Household? get household => _household;
  List<HouseholdMember> get members => List.unmodifiable(_members);
  bool get isLoaded => _loaded;
  bool get hasHousehold => _household != null;

  Future<void> loadForUser(String userId) async {
    _household = await _dao.getPrimaryHouseholdForUser(userId);
    if (_household != null) {
      HouseholdContext.setHouseholdId(_household!.id);
      _members = await _dao.getMembers(_household!.id);
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
    await _dao.insertHousehold(household);
    await _dao.insertMember(member);
    await _shareDao.seedDefaults(household.id);
    await _migrateDefaultHouseholdRows(household.id);
    _household = household;
    _members = [member];
    HouseholdContext.setHouseholdId(household.id);
    _loaded = true;
    notifyListeners();
    await ActivityLedgerService.instance.log(
      action: 'Created household',
      userId: userId,
      householdId: household.id,
      detail: trimmed,
    );
    return null;
  }

  Future<String?> joinHousehold({
    required String userId,
    required String inviteCode,
    String role = 'partner',
  }) async {
    final household = await _dao.getHouseholdByInviteCode(inviteCode);
    if (household == null) return 'Invite code not found.';
    final already = await _dao.isMember(household.id, userId);
    if (already) return 'You are already in this household.';
    final member = HouseholdMember(
      id: _uuid.v4(),
      householdId: household.id,
      userId: userId,
      role: role,
      joinedAt: DateTime.now(),
    );
    await _dao.insertMember(member);
    _household = household;
    _members = await _dao.getMembers(household.id);
    HouseholdContext.setHouseholdId(household.id);
    _loaded = true;
    notifyListeners();
    await ActivityLedgerService.instance.log(
      action: 'Joined household',
      userId: userId,
      householdId: household.id,
      detail: household.name,
    );
    return null;
  }

  Future<void> refreshMembers() async {
    if (_household == null) return;
    _members = await _dao.getMembers(_household!.id);
    notifyListeners();
  }

  Future<void> _migrateDefaultHouseholdRows(String newHouseholdId) async {
    final db = await DatabaseHelper().database;
    for (final table in ['calendar_events', 'tasks']) {
      try {
        await db.rawUpdate(
          'UPDATE $table SET household_id = ? WHERE household_id IS NULL OR household_id = ?',
          [newHouseholdId, 'default'],
        );
      } catch (_) {
        // Table or column may not exist in older schemas.
      }
    }
  }
}
