import 'package:sqflite/sqflite.dart';
import '../models/calendar_event.dart';
import 'database_helper.dart';

class CalendarDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // ============================================
  // EVENT OPERATIONS
  // ============================================

  Future<List<CalendarEvent>> getEventsForDate(DateTime date) async {
    final db = await _dbHelper.database;
    final dateStr = date.toIso8601String().split('T')[0];
    final maps = await db.query(
      'calendar_events',
      where: 'date LIKE ?',
      whereArgs: ['$dateStr%'],
      orderBy: 'date ASC',
    );
    return maps.map((map) => CalendarEvent.fromMap(map)).toList();
  }

  Future<List<CalendarEvent>> getEventsForMonth(DateTime month) async {
    final db = await _dbHelper.database;
    final startStr = DateTime(month.year, month.month, 1).toIso8601String().split('T')[0];
    final endStr = DateTime(month.year, month.month + 1, 0).toIso8601String().split('T')[0];
    final maps = await db.query(
      'calendar_events',
      where: 'date >= ? AND date <= ?',
      whereArgs: [startStr, endStr],
      orderBy: 'date ASC',
    );
    return maps.map((map) => CalendarEvent.fromMap(map)).toList();
  }

  Future<void> insertEvent(CalendarEvent event) async {
    final db = await _dbHelper.database;
    await db.insert('calendar_events', event.toMap());
  }

  Future<void> updateEvent(CalendarEvent event) async {
    final db = await _dbHelper.database;
    await db.update(
      'calendar_events',
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  Future<void> deleteEvent(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'calendar_events',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Map<String, List<CalendarEvent>>> getEventsGroupedByDate(DateTime month) async {
    final events = await getEventsForMonth(month);
    final grouped = <String, List<CalendarEvent>>{};
    for (final event in events) {
      final key = event.date.toIso8601String().split('T')[0];
      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(event);
    }
    return grouped;
  }

  // ============================================
  // CATEGORY OPERATIONS
  // ============================================

  Future<List<Map<String, dynamic>>> getCategories() async {
    final db = await _dbHelper.database;
    return db.query('event_categories', orderBy: 'sort_order ASC');
  }

  Future<Map<String, dynamic>?> getCategory(String id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'event_categories',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return maps.first;
  }

  // ============================================
  // CONFLICT DETECTION
  // ============================================

  Future<List<CalendarEvent>> checkConflicts(DateTime date, DateTime? startTime, DateTime? endTime) async {
    if (startTime == null || endTime == null) return [];
    
    final db = await _dbHelper.database;
    final dateStr = date.toIso8601String().split('T')[0];
    final maps = await db.query(
      'calendar_events',
      where: 'date LIKE ? AND is_all_day = 0',
      whereArgs: ['$dateStr%'],
    );
    
    final events = maps.map((map) => CalendarEvent.fromMap(map)).toList();
    return events.where((e) {
      if (e.startTime == null || e.endTime == null) return false;
      return startTime.isBefore(e.endTime!) && endTime.isAfter(e.startTime!);
    }).toList();
  }
}