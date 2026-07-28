import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'database_helper.dart';

class FamilyCareDao {
  final _uuid = const Uuid();

  Future<Database> get _db => DatabaseHelper().database;

  Future<void> logActivity({
    required String personId,
    required String logType,
    required String detail,
    String? metadata,
  }) async {
    final db = await _db;
    await db.insert('care_activity_logs', {
      'id': _uuid.v4(),
      'person_id': personId,
      'log_type': logType,
      'detail': detail,
      'logged_at': DateTime.now().toIso8601String(),
      'metadata': metadata,
    });
    if (logType == 'feed') {
      await db.insert('feeding_logs', {
        'id': _uuid.v4(),
        'child_id': personId,
        'person_id': personId,
        'timestamp': DateTime.now().toIso8601String(),
        'type': 'feed',
        'notes': detail,
      });
    }
  }

  Future<List<Map<String, dynamic>>> getRecentActivity(String personId, {int limit = 20}) async {
    final db = await _db;
    return db.query(
      'care_activity_logs',
      where: 'person_id = ?',
      whereArgs: [personId],
      orderBy: 'logged_at DESC',
      limit: limit,
    );
  }

  Future<int> feedCountLast7Days(String personId) async {
    final db = await _db;
    final since = DateTime.now().subtract(const Duration(days: 7)).toIso8601String();
    final rows = await db.rawQuery(
      '''
      SELECT COUNT(*) as c FROM care_activity_logs
      WHERE person_id = ? AND log_type = 'feed' AND logged_at >= ?
      ''',
      [personId, since],
    );
    return rows.first['c'] as int? ?? 0;
  }

  Future<List<int>> feedsPerDayLast7Days(String personId) async {
    final counts = <int>[];
    final db = await _db;
    for (var i = 6; i >= 0; i--) {
      final day = DateTime.now().subtract(Duration(days: i));
      final start = DateTime(day.year, day.month, day.day).toIso8601String();
      final end = DateTime(day.year, day.month, day.day, 23, 59, 59).toIso8601String();
      final rows = await db.rawQuery(
        '''
        SELECT COUNT(*) as c FROM care_activity_logs
        WHERE person_id = ? AND log_type = 'feed' AND logged_at >= ? AND logged_at <= ?
        ''',
        [personId, start, end],
      );
      counts.add(rows.first['c'] as int? ?? 0);
    }
    return counts;
  }

  Future<List<Map<String, dynamic>>> getMedications(String personId) async {
    final db = await _db;
    return db.query(
      'medications',
      where: 'person_id = ? OR child_id = ?',
      whereArgs: [personId, personId],
    );
  }

  Future<void> seedDefaultMedsIfEmpty(String personId) async {
    final existing = await getMedications(personId);
    if (existing.isNotEmpty) return;
    final db = await _db;
    final meds = [
      {'name': 'Paracetamol', 'dose': 2.5, 'unit': 'ml', 'hours': 4},
      {'name': 'Ibuprofen', 'dose': 2.5, 'unit': 'ml', 'hours': 6},
    ];
    for (final m in meds) {
      await db.insert('medications', {
        'id': _uuid.v4(),
        'child_id': personId,
        'person_id': personId,
        'name': m['name'],
        'dose': m['dose'],
        'dose_unit': m['unit'],
        'minimum_interval_hours': m['hours'],
        'mode': 'as_needed',
        'created_at': DateTime.now().toIso8601String(),
      });
    }
  }

  Future<void> logMedicationGiven(String medicationId) async {
    final db = await _db;
    final now = DateTime.now().toIso8601String();
    await db.update('medications', {'last_given': now}, where: 'id = ?', whereArgs: [medicationId]);
    await db.insert('medication_logs', {
      'id': _uuid.v4(),
      'medication_id': medicationId,
      'given_at': now,
      'dose_given': 0,
      'notes': 'logged',
    });
  }

  Future<Map<String, dynamic>?> getLastFeed(String personId) async {
    final db = await _db;
    final rows = await db.query(
      'care_activity_logs',
      where: 'person_id = ? AND log_type = ?',
      whereArgs: [personId, 'feed'],
      orderBy: 'logged_at DESC',
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return rows.first;
  }
}
