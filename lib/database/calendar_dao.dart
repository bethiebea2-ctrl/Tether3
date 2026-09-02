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
      orderBy: 'is_all_day DESC, start_time ASC, date ASC',
    );
    return maps.map(CalendarEvent.fromMap).toList();
  }

  Future<List<CalendarEvent>> getEventsForMonth(DateTime month) async {
    final db = await _dbHelper.database;
    final startStr =
        DateTime(month.year, month.month, 1).toIso8601String().split('T')[0];
    final endStr = DateTime(month.year, month.month + 1, 0)
        .toIso8601String()
        .split('T')[0];
    final maps = await db.query(
      'calendar_events',
      where: "date >= ? AND date <= ? AND (event_type IS NULL OR event_type != 'birthday')",
      whereArgs: [startStr, endStr],
      orderBy: 'date ASC, is_all_day DESC, start_time ASC',
    );
    final regular = maps.map(CalendarEvent.fromMap).toList();
    final birthdays = await _birthdayEventsForMonth(month);
    return [...regular, ...birthdays];
  }

  Future<List<CalendarEvent>> _birthdayEventsForMonth(DateTime month) async {
    final db = await _dbHelper.database;
    final monthStr = month.month.toString().padLeft(2, '0');
    final maps = await db.query(
      'calendar_events',
      where: "event_type = 'birthday' AND strftime('%m', date) = ?",
      whereArgs: [monthStr],
    );
    return maps.map((m) {
      final e = CalendarEvent.fromMap(m);
      return e.copyWith(
        startTime: DateTime(month.year, e.startTime.month, e.startTime.day),
      );
    }).toList();
  }

  /// Upcoming events from [from] forward (agenda infinite-scroll base).
  Future<List<CalendarEvent>> getUpcomingEvents({
    DateTime? from,
    int limit = 80,
  }) async {
    final db = await _dbHelper.database;
    final start = (from ?? DateTime.now()).toIso8601String().split('T')[0];
    final maps = await db.query(
      'calendar_events',
      where: "date >= ? AND (event_type IS NULL OR event_type != 'birthday')",
      whereArgs: [start],
      orderBy: 'date ASC, is_all_day DESC, start_time ASC',
      limit: limit,
    );
    final regular = maps.map(CalendarEvent.fromMap).toList();
    final birthdayMaps = await db.query(
      'calendar_events',
      where: "event_type = 'birthday'",
    );
    final now = from ?? DateTime.now();
    final upcomingBirthdays = birthdayMaps.map(CalendarEvent.fromMap).map((e) {
      var year = now.year;
      var next = DateTime(year, e.startTime.month, e.startTime.day);
      if (next.isBefore(DateTime(now.year, now.month, now.day))) {
        year += 1;
        next = DateTime(year, e.startTime.month, e.startTime.day);
      }
      return e.copyWith(startTime: next);
    }).where((e) {
      final key = e.startTime.toIso8601String().split('T')[0];
      return key.compareTo(start) >= 0;
    }).toList();
    final merged = [...regular, ...upcomingBirthdays];
    merged.sort((a, b) => a.startTime.compareTo(b.startTime));
    return merged.take(limit).toList();
  }

  Future<void> insertEvent(CalendarEvent event) async {
    final db = await _dbHelper.database;
    await db.insert(
      'calendar_events',
      _eventRow(event),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateEvent(CalendarEvent event) async {
    final db = await _dbHelper.database;
    await db.update(
      'calendar_events',
      _eventRow(event),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  /// Columns that exist on all DB versions (avoids insert failures on older schemas).
  static const _eventColumns = {
    'id',
    'title',
    'date',
    'start_time',
    'end_time',
    'is_all_day',
    'recurrence',
    'category_id',
    'emoji',
    'location',
    'notes',
    'person_id',
    'source',
    'priority',
    'event_type',
    'created_at',
    'updated_at',
  };

  Map<String, dynamic> _eventRow(CalendarEvent event) {
    final full = event.toMap();
    return Map.fromEntries(
      full.entries.where((e) => _eventColumns.contains(e.key)),
    );
  }

  Future<CalendarEvent?> getEventById(String id) async {
    final db = await _dbHelper.database;
    final maps =
        await db.query('calendar_events', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return CalendarEvent.fromMap(maps.first);
  }

  Future<CalendarEvent?> getBirthdayEventForPerson(String personId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'calendar_events',
      where: 'person_id = ? AND event_type = ?',
      whereArgs: [personId, 'birthday'],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return CalendarEvent.fromMap(maps.first);
  }

  Future<List<CalendarEvent>> getUpcomingForPerson(
    String personId, {
    int limit = 3,
  }) async {
    final db = await _dbHelper.database;
    final now = DateTime.now().toIso8601String();
    final maps = await db.query(
      'calendar_events',
      where: 'person_id = ? AND date >= ?',
      whereArgs: [personId, now],
      orderBy: 'date ASC',
      limit: limit,
    );
    return maps.map(CalendarEvent.fromMap).toList();
  }

  Future<void> deleteEvent(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'calendar_events',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Map<String, List<CalendarEvent>>> getEventsGroupedByDate(
    DateTime month,
  ) async {
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

  Future<void> linkCategoryToPerson(String categoryId, String personId) async {
    final db = await _dbHelper.database;
    await db.update(
      'event_categories',
      {'person_id': personId},
      where: 'id = ?',
      whereArgs: [categoryId],
    );
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

  Future<void> upsertCategory(Map<String, dynamic> category) async {
    final db = await _dbHelper.database;
    await db.insert(
      'event_categories',
      category,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteCategory(String id) async {
    final db = await _dbHelper.database;
    await db.delete('event_categories', where: 'id = ?', whereArgs: [id]);
  }

  // ============================================
  // CONFLICT DETECTION
  // ============================================

  /// Returns overlapping / near events. Warn window: 1 hour between edges.
  Future<List<CalendarEvent>> checkConflicts(
    DateTime date,
    DateTime? startTime,
    DateTime? endTime, {
    String? excludeId,
  }) async {
    if (startTime == null) return [];

    final effectiveEnd =
        endTime ?? startTime.add(const Duration(minutes: 30));
    final windowStart = startTime.subtract(const Duration(hours: 1));
    final windowEnd = effectiveEnd.add(const Duration(hours: 1));

    final db = await _dbHelper.database;
    final dateStr = date.toIso8601String().split('T')[0];
    final maps = await db.query(
      'calendar_events',
      where: 'date LIKE ? AND is_all_day = 0',
      whereArgs: ['$dateStr%'],
    );

    final events = maps.map(CalendarEvent.fromMap).toList();
    return events.where((e) {
      if (excludeId != null && e.id == excludeId) return false;
      if (e.isAllDay) return false;
      final eStart = e.startTime;
      final eEnd = e.endTime ?? eStart.add(const Duration(minutes: 30));
      // Overlap or within 1-hour buffer window
      return eStart.isBefore(windowEnd) && eEnd.isAfter(windowStart);
    }).toList();
  }
}
