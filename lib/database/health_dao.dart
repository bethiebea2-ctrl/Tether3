import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../models/health_models.dart';
import 'database_helper.dart';

/// CRUD for Health Status tables + personal medications.
class HealthDao {
  final _uuid = const Uuid();

  Future<Database> get _db => DatabaseHelper().database;

  // ── Health logs ────────────────────────────────────────────

  Future<List<HealthLogEntry>> getHealthLogs({String? type, int? limit}) async {
    final db = await _db;
    final rows = await db.query(
      'health_logs',
      where: type != null ? 'type = ?' : null,
      whereArgs: type != null ? [type] : null,
      orderBy: 'logged_at DESC',
      limit: limit,
    );
    return rows.map(HealthLogEntry.fromMap).toList();
  }

  Future<void> insertHealthLog(HealthLogEntry entry) async {
    final db = await _db;
    await db.insert('health_logs', entry.toMap());
  }

  Future<void> updateHealthLog(HealthLogEntry entry) async {
    final db = await _db;
    await db.update(
      'health_logs',
      entry.toMap(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  Future<void> deleteHealthLog(String id) async {
    final db = await _db;
    await db.delete('health_logs', where: 'id = ?', whereArgs: [id]);
  }

  // ── Allergies ──────────────────────────────────────────────

  Future<List<AllergyEntry>> getAllergies() async {
    final db = await _db;
    final rows = await db.query('allergies', orderBy: 'name ASC');
    return rows.map(AllergyEntry.fromMap).toList();
  }

  Future<void> insertAllergy(AllergyEntry entry) async {
    final db = await _db;
    await db.insert('allergies', entry.toMap());
  }

  Future<void> updateAllergy(AllergyEntry entry) async {
    final db = await _db;
    await db.update(
      'allergies',
      entry.toMap(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  Future<void> deleteAllergy(String id) async {
    final db = await _db;
    await db.delete('allergies', where: 'id = ?', whereArgs: [id]);
  }

  // ── Health documents ───────────────────────────────────────

  Future<List<HealthDocument>> getDocuments() async {
    final db = await _db;
    final rows = await db.query('health_documents', orderBy: 'created_at DESC');
    return rows.map(HealthDocument.fromMap).toList();
  }

  Future<void> insertDocument(HealthDocument doc) async {
    final db = await _db;
    await db.insert('health_documents', doc.toMap());
  }

  Future<void> updateDocument(HealthDocument doc) async {
    final db = await _db;
    await db.update(
      'health_documents',
      doc.toMap(),
      where: 'id = ?',
      whereArgs: [doc.id],
    );
  }

  Future<void> deleteDocument(String id) async {
    final db = await _db;
    await db.delete('health_documents', where: 'id = ?', whereArgs: [id]);
  }

  // ── Seizure logs ───────────────────────────────────────────

  Future<List<SeizureLogEntry>> getSeizureLogs({int? limit}) async {
    final db = await _db;
    final rows = await db.query(
      'seizure_logs',
      orderBy: 'started_at DESC',
      limit: limit,
    );
    return rows.map(SeizureLogEntry.fromMap).toList();
  }

  Future<void> insertSeizureLog(SeizureLogEntry entry) async {
    final db = await _db;
    await db.insert('seizure_logs', entry.toMap());
  }

  Future<void> updateSeizureLog(SeizureLogEntry entry) async {
    final db = await _db;
    await db.update(
      'seizure_logs',
      entry.toMap(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  Future<void> deleteSeizureLog(String id) async {
    final db = await _db;
    await db.delete('seizure_logs', where: 'id = ?', whereArgs: [id]);
  }

  // ── Personal medications ───────────────────────────────────
  // person_id NULL, '' or 'self' = personal (self).

  Future<List<PersonalMedication>> getPersonalMedications() async {
    final db = await _db;
    final rows = await db.rawQuery('''
      SELECT * FROM medications
      WHERE person_id IS NULL
         OR person_id = ''
         OR person_id = 'self'
      ORDER BY name ASC
    ''');
    return rows.map(PersonalMedication.fromMap).toList();
  }

  Future<void> insertPersonalMedication(PersonalMedication med) async {
    final db = await _db;
    final map = med.toMap();
    map['person_id'] = 'self';
    await db.insert('medications', map);
  }

  Future<void> updatePersonalMedication(PersonalMedication med) async {
    final db = await _db;
    final map = med.toMap();
    map['person_id'] = 'self';
    await db.update(
      'medications',
      map,
      where: 'id = ?',
      whereArgs: [med.id],
    );
  }

  Future<void> deletePersonalMedication(String id) async {
    final db = await _db;
    await db.delete('medication_logs', where: 'medication_id = ?', whereArgs: [id]);
    await db.delete('medications', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> logPersonalDose({
    required String medicationId,
    required double doseGiven,
    String? notes,
  }) async {
    final db = await _db;
    final now = DateTime.now();
    await db.update(
      'medications',
      {'last_given': now.toIso8601String()},
      where: 'id = ?',
      whereArgs: [medicationId],
    );
    await db.insert('medication_logs', {
      'id': _uuid.v4(),
      'medication_id': medicationId,
      'given_at': now.toIso8601String(),
      'dose_given': doseGiven,
      'notes': notes,
    });
  }

  Future<List<MedicationLogEntry>> getMedicationLogs(
    String medicationId, {
    int? limit,
  }) async {
    final db = await _db;
    final rows = await db.query(
      'medication_logs',
      where: 'medication_id = ?',
      whereArgs: [medicationId],
      orderBy: 'given_at DESC',
      limit: limit,
    );
    return rows.map(MedicationLogEntry.fromMap).toList();
  }

  Future<List<MedicationLogEntry>> getRecentPersonalMedicationLogs({
    int limit = 30,
  }) async {
    final db = await _db;
    final rows = await db.rawQuery('''
      SELECT ml.* FROM medication_logs ml
      INNER JOIN medications m ON m.id = ml.medication_id
      WHERE m.person_id IS NULL
         OR m.person_id = ''
         OR m.person_id = 'self'
      ORDER BY ml.given_at DESC
      LIMIT ?
    ''', [limit]);
    return rows.map(MedicationLogEntry.fromMap).toList();
  }
}
