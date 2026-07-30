import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import '../models/mental_health_models.dart';
import 'database_helper.dart';

class MentalHealthDao {
  Future<Database> get _db => DatabaseHelper().database;

  // ── Crisis plan (single row) ───────────────────────────────

  Future<CrisisPlan?> getCrisisPlan() async {
    final db = await _db;
    final rows = await db.query('crisis_plans', limit: 1);
    if (rows.isEmpty) return null;
    final row = rows.first;
    final json = jsonDecode(row['content_json'] as String) as Map<String, dynamic>;
    return CrisisPlan.fromJson(
      row['id'] as String,
      json,
      DateTime.parse(row['updated_at'] as String),
    );
  }

  Future<void> upsertCrisisPlan(CrisisPlan plan) async {
    final db = await _db;
    await db.insert(
      'crisis_plans',
      {
        'id': plan.id,
        'content_json': jsonEncode(plan.toJson()),
        'updated_at': plan.updatedAt.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ── Worry logs ─────────────────────────────────────────────

  Future<List<WorryLog>> getWorryLogs() async {
    final db = await _db;
    final rows = await db.query('worry_logs', orderBy: 'created_at DESC');
    return rows.map(WorryLog.fromMap).toList();
  }

  Future<void> insertWorryLog(WorryLog log) async {
    final db = await _db;
    await db.insert('worry_logs', log.toMap());
  }

  Future<void> deleteWorryLog(String id) async {
    final db = await _db;
    await db.delete('worry_logs', where: 'id = ?', whereArgs: [id]);
  }

  // ── Trusted contacts ───────────────────────────────────────

  Future<List<TrustedContact>> getTrustedContacts() async {
    final db = await _db;
    final rows = await db.query('trusted_contacts', orderBy: 'name ASC');
    return rows.map(TrustedContact.fromMap).toList();
  }

  Future<void> upsertTrustedContact(TrustedContact contact) async {
    final db = await _db;
    await db.insert(
      'trusted_contacts',
      contact.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteTrustedContact(String id) async {
    final db = await _db;
    await db.delete('trusted_contacts', where: 'id = ?', whereArgs: [id]);
  }

  // ── Panic episode logs ─────────────────────────────────────

  Future<List<PanicEpisodeLog>> getPanicEpisodes({int limit = 50}) async {
    final db = await _db;
    final rows = await db.query(
      'panic_episode_logs',
      orderBy: 'logged_at DESC',
      limit: limit,
    );
    return rows.map(PanicEpisodeLog.fromMap).toList();
  }

  Future<void> insertPanicEpisode(PanicEpisodeLog log) async {
    final db = await _db;
    await db.insert('panic_episode_logs', log.toMap());
  }
}
