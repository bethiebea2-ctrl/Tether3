import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';
import '../core/household/household_prefs_store.dart';
import '../models/household.dart';
import 'database_helper.dart';
import 'household_dao.dart';
import 'share_permissions_dao.dart';

/// Household persistence — SharedPreferences on web, SQLite elsewhere.
class HouseholdRepository {
  HouseholdRepository({
    HouseholdDao? dao,
    HouseholdPrefsStore? prefs,
    SharePermissionsDao? shareDao,
  })  : _dao = dao ?? HouseholdDao(),
        _prefs = prefs ?? HouseholdPrefsStore(),
        _shareDao = shareDao ?? SharePermissionsDao();

  final HouseholdDao _dao;
  final HouseholdPrefsStore _prefs;
  final SharePermissionsDao _shareDao;

  Future<void> insertHousehold(Household household) async {
    if (kIsWeb) {
      await _prefs.insertHousehold(household);
      return;
    }
    await _dao.insertHousehold(household);
  }

  Future<void> insertMember(HouseholdMember member) async {
    if (kIsWeb) {
      await _prefs.insertMember(member);
      return;
    }
    await _dao.insertMember(member);
  }

  Future<Household?> getHouseholdById(String id) async {
    if (kIsWeb) return _prefs.getHouseholdById(id);
    return _dao.getHouseholdById(id);
  }

  Future<Household?> getHouseholdByInviteCode(String code) async {
    if (kIsWeb) return _prefs.getHouseholdByInviteCode(code);
    return _dao.getHouseholdByInviteCode(code);
  }

  Future<Household?> getPrimaryHouseholdForUser(String userId) async {
    if (kIsWeb) return _prefs.getPrimaryHouseholdForUser(userId);
    return _dao.getPrimaryHouseholdForUser(userId);
  }

  Future<List<HouseholdMember>> getMembers(String householdId) async {
    if (kIsWeb) return _prefs.getMembers(householdId);
    return _dao.getMembers(householdId);
  }

  Future<bool> isMember(String householdId, String userId) async {
    if (kIsWeb) return _prefs.isMember(householdId, userId);
    return _dao.isMember(householdId, userId);
  }

  Future<void> seedShareDefaults(String householdId) async {
    if (kIsWeb) {
      await _prefs.seedShareDefaults(householdId);
      return;
    }
    await _shareDao.seedDefaults(householdId);
  }

  Future<List<SharePermission>> sharePermissionsForHousehold(String householdId) async {
    if (kIsWeb) return _prefs.sharePermissionsForHousehold(householdId);
    return _shareDao.forHousehold(householdId);
  }

  Future<void> setShareEnabled({
    required String householdId,
    required String viewerRole,
    required String sensitivity,
    required bool enabled,
  }) async {
    if (kIsWeb) {
      await _prefs.setShareEnabled(
        householdId: householdId,
        viewerRole: viewerRole,
        sensitivity: sensitivity,
        enabled: enabled,
      );
      return;
    }
    await _shareDao.setEnabled(
      householdId: householdId,
      viewerRole: viewerRole,
      sensitivity: sensitivity,
      enabled: enabled,
    );
  }

  Future<void> setShareRoleMaster({
    required String householdId,
    required String viewerRole,
    required bool enabled,
  }) async {
    if (kIsWeb) {
      await _prefs.setShareRoleMaster(
        householdId: householdId,
        viewerRole: viewerRole,
        enabled: enabled,
      );
      return;
    }
    await _shareDao.setRoleMaster(
      householdId: householdId,
      viewerRole: viewerRole,
      enabled: enabled,
    );
  }

  bool roleMasterEnabled(List<SharePermission> all, String role) {
    if (kIsWeb) {
      final roleRows = all.where((p) => p.viewerRole == role && p.sensitivity != 'D4');
      if (roleRows.isEmpty) return false;
      return roleRows.every((p) => p.enabled);
    }
    return _shareDao.roleMasterEnabled(all, role);
  }

  Future<void> migrateDefaultHouseholdRows(String newHouseholdId) async {
    if (kIsWeb) return;
    final db = await DatabaseHelper().database;
    for (final table in ['calendar_events', 'tasks']) {
      try {
        await db.rawUpdate(
          'UPDATE $table SET household_id = ? WHERE household_id IS NULL OR household_id = ?',
          [newHouseholdId, 'default'],
        );
      } catch (_) {}
    }
  }
}
