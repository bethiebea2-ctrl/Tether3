import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';

class ActivityLedgerEntry {
  final String id;
  final String? userId;
  final String? householdId;
  final String actorLabel;
  final String action;
  final String? detail;
  final String? dataUsed;
  final String? sharedWith;
  final DateTime createdAt;

  const ActivityLedgerEntry({
    required this.id,
    this.userId,
    this.householdId,
    required this.actorLabel,
    required this.action,
    this.detail,
    this.dataUsed,
    this.sharedWith,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'household_id': householdId,
        'actor_label': actorLabel,
        'action': action,
        'detail': detail,
        'data_used': dataUsed,
        'shared_with': sharedWith,
        'created_at': createdAt.toIso8601String(),
      };

  factory ActivityLedgerEntry.fromMap(Map<String, dynamic> map) => ActivityLedgerEntry(
        id: map['id']?.toString() ?? '',
        userId: map['user_id'] as String?,
        householdId: map['household_id'] as String?,
        actorLabel: map['actor_label']?.toString() ?? 'App',
        action: map['action']?.toString() ?? '',
        detail: map['detail'] as String?,
        dataUsed: map['data_used'] as String?,
        sharedWith: map['shared_with'] as String?,
        createdAt: DateTime.tryParse(map['created_at']?.toString() ?? '') ?? DateTime.now(),
      );
}

class ActivityLedgerDao {
  Future<Database> get _db => DatabaseHelper().database;

  Future<void> insert(ActivityLedgerEntry entry) async {
    final db = await _db;
    await db.insert('activity_ledger_entries', entry.toMap());
  }

  Future<List<ActivityLedgerEntry>> recent({int limit = 80}) async {
    final db = await _db;
    final rows = await db.query(
      'activity_ledger_entries',
      orderBy: 'created_at DESC',
      limit: limit,
    );
    return rows.map(ActivityLedgerEntry.fromMap).toList();
  }
}
