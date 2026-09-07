import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../database/share_permissions_dao.dart';
import '../../models/household.dart';

/// Chrome/web household storage — avoids fragile SQLite household tables in the browser.
class HouseholdPrefsStore {
  static const _householdsKey = 'phase2a_households_v1';
  static const _membersKey = 'phase2a_household_members_v1';
  static const _shareKey = 'phase2a_share_permissions_v1';

  Future<List<Map<String, dynamic>>> _households() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_householdsKey);
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw);
    if (decoded is! List) return [];
    return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  Future<void> _saveHouseholds(List<Map<String, dynamic>> rows) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_householdsKey, jsonEncode(rows));
  }

  Future<List<Map<String, dynamic>>> _members() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_membersKey);
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw);
    if (decoded is! List) return [];
    return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  Future<void> _saveMembers(List<Map<String, dynamic>> rows) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_membersKey, jsonEncode(rows));
  }

  Future<List<Map<String, dynamic>>> _shareRows() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_shareKey);
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw);
    if (decoded is! List) return [];
    return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  Future<void> _saveShareRows(List<Map<String, dynamic>> rows) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_shareKey, jsonEncode(rows));
  }

  Future<void> insertHousehold(Household household) async {
    final rows = await _households();
    rows.add(household.toMap());
    await _saveHouseholds(rows);
  }

  Future<void> insertMember(HouseholdMember member) async {
    final rows = await _members();
    rows.removeWhere(
      (r) =>
          r['household_id'] == member.householdId &&
          r['user_id'] == member.userId,
    );
    rows.add(member.toMap());
    await _saveMembers(rows);
  }

  Future<Household?> getHouseholdById(String id) async {
    for (final row in await _households()) {
      if (row['id']?.toString() == id) return Household.fromMap(row);
    }
    return null;
  }

  Future<Household?> getHouseholdByInviteCode(String code) async {
    final normalized = code.trim().toUpperCase();
    for (final row in await _households()) {
      if ((row['invite_code'] as String?)?.toUpperCase() == normalized) {
        return Household.fromMap(row);
      }
    }
    return null;
  }

  Future<Household?> getPrimaryHouseholdForUser(String userId) async {
    final memberRows = await _members();
    memberRows.sort(
      (a, b) => (a['joined_at'] as String? ?? '').compareTo(b['joined_at'] as String? ?? ''),
    );
    for (final row in memberRows) {
      if (row['user_id']?.toString() == userId) {
        return getHouseholdById(row['household_id'] as String);
      }
    }
    return null;
  }

  Future<List<HouseholdMember>> getMembers(String householdId) async {
    final rows = await _members();
    return rows
        .where((r) => r['household_id']?.toString() == householdId)
        .map(HouseholdMember.fromMap)
        .toList()
      ..sort((a, b) => a.joinedAt.compareTo(b.joinedAt));
  }

  Future<bool> isMember(String householdId, String userId) async {
    final rows = await _members();
    return rows.any(
      (r) => r['household_id']?.toString() == householdId && r['user_id']?.toString() == userId,
    );
  }

  Future<void> seedShareDefaults(String householdId) async {
    final rows = await _shareRows();
    var seeded = false;
    for (final role in shareViewerRoles) {
      for (final sensitivity in shareSensitivities) {
        final exists = rows.any(
          (r) =>
              r['household_id'] == householdId &&
              r['viewer_role'] == role &&
              r['sensitivity'] == sensitivity,
        );
        if (exists) continue;
        rows.add({
          'id': '$householdId-$role-$sensitivity',
          'household_id': householdId,
          'viewer_role': role,
          'sensitivity': sensitivity,
          'enabled': 0,
        });
        seeded = true;
      }
    }
    if (seeded) await _saveShareRows(rows);
  }

  Future<List<SharePermission>> sharePermissionsForHousehold(String householdId) async {
    final rows = await _shareRows();
    final filtered = rows
        .where((r) => r['household_id']?.toString() == householdId)
        .map(SharePermission.fromMap)
        .toList();
    if (filtered.isEmpty) {
      await seedShareDefaults(householdId);
      return sharePermissionsForHousehold(householdId);
    }
    return filtered;
  }

  Future<void> setShareEnabled({
    required String householdId,
    required String viewerRole,
    required String sensitivity,
    required bool enabled,
  }) async {
    final rows = await _shareRows();
    for (final row in rows) {
      if (row['household_id'] == householdId &&
          row['viewer_role'] == viewerRole &&
          row['sensitivity'] == sensitivity) {
        row['enabled'] = enabled ? 1 : 0;
      }
    }
    await _saveShareRows(rows);
  }

  Future<void> setShareRoleMaster({
    required String householdId,
    required String viewerRole,
    required bool enabled,
  }) async {
    final sensitivities = enabled ? ['D1', 'D2', 'D3'] : shareSensitivities;
    for (final sensitivity in sensitivities) {
      if (sensitivity == 'D4') continue;
      await setShareEnabled(
        householdId: householdId,
        viewerRole: viewerRole,
        sensitivity: sensitivity,
        enabled: enabled,
      );
    }
  }
}
