import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'database_helper.dart';

const shareViewerRoles = ['partner', 'teen', 'child_profile', 'carer', 'viewer'];
const shareSensitivities = ['D1', 'D2', 'D3', 'D4'];

class SharePermission {
  final String id;
  final String householdId;
  final String viewerRole;
  final String sensitivity;
  final bool enabled;

  const SharePermission({
    required this.id,
    required this.householdId,
    required this.viewerRole,
    required this.sensitivity,
    required this.enabled,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'household_id': householdId,
        'viewer_role': viewerRole,
        'sensitivity': sensitivity,
        'enabled': enabled ? 1 : 0,
      };

  factory SharePermission.fromMap(Map<String, dynamic> map) => SharePermission(
        id: map['id']?.toString() ?? '',
        householdId: map['household_id']?.toString() ?? '',
        viewerRole: map['viewer_role']?.toString() ?? '',
        sensitivity: map['sensitivity']?.toString() ?? '',
        enabled: (map['enabled'] as int? ?? 0) == 1,
      );
}

class SharePermissionsDao {
  final _uuid = const Uuid();

  Future<Database> get _db => DatabaseHelper().database;

  Future<void> seedDefaults(String householdId) async {
    final db = await _db;
    for (final role in shareViewerRoles) {
      for (final sensitivity in shareSensitivities) {
        await db.insert(
          'share_permissions',
          SharePermission(
            id: _uuid.v4(),
            householdId: householdId,
            viewerRole: role,
            sensitivity: sensitivity,
            enabled: false,
          ).toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
    }
  }

  Future<List<SharePermission>> forHousehold(String householdId) async {
    final db = await _db;
    final rows = await db.query(
      'share_permissions',
      where: 'household_id = ?',
      whereArgs: [householdId],
      orderBy: 'viewer_role ASC, sensitivity ASC',
    );
    if (rows.isEmpty) {
      await seedDefaults(householdId);
      return forHousehold(householdId);
    }
    return rows.map(SharePermission.fromMap).toList();
  }

  Future<void> setEnabled({
    required String householdId,
    required String viewerRole,
    required String sensitivity,
    required bool enabled,
  }) async {
    final db = await _db;
    await db.update(
      'share_permissions',
      {'enabled': enabled ? 1 : 0},
      where: 'household_id = ? AND viewer_role = ? AND sensitivity = ?',
      whereArgs: [householdId, viewerRole, sensitivity],
    );
  }

  Future<void> setRoleMaster({
    required String householdId,
    required String viewerRole,
    required bool enabled,
  }) async {
    final db = await _db;
    final sensitivities = enabled ? ['D1', 'D2', 'D3'] : shareSensitivities;
    for (final sensitivity in sensitivities) {
      if (sensitivity == 'D4') continue;
      await db.update(
        'share_permissions',
        {'enabled': enabled ? 1 : 0},
        where: 'household_id = ? AND viewer_role = ? AND sensitivity = ?',
        whereArgs: [householdId, viewerRole, sensitivity],
      );
    }
  }

  bool roleMasterEnabled(List<SharePermission> all, String role) {
    final roleRows = all.where((p) => p.viewerRole == role && p.sensitivity != 'D4');
    if (roleRows.isEmpty) return false;
    return roleRows.every((p) => p.enabled);
  }
}
