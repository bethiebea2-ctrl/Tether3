import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../models/calendar_event.dart';
import '../database/calendar_dao.dart';
import '../theme/colours.dart';

enum CalendarViewMode { month, week, day, agenda }

class CalendarProvider extends ChangeNotifier {
  static const String baseUrl = 'https://tether-backend-laue.onrender.com';

  final CalendarDao _dao = CalendarDao();
  final _uuid = const Uuid();

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  CalendarViewMode _viewMode = CalendarViewMode.month;
  bool _monthCollapsed = false;
  List<CalendarEvent> _events = [];
  List<CalendarEvent> _upcoming = [];
  List<Map<String, dynamic>> _categories = [];
  Map<String, List<CalendarEvent>> _groupedEvents = {};
  bool _isLoading = false;
  String? _coldStartMessage;

  DateTime get currentMonth =>
      DateTime(_focusedDay.year, _focusedDay.month, 1);
  DateTime get focusedDay => _focusedDay;
  DateTime get selectedDate => _selectedDate;
  CalendarViewMode get viewMode => _viewMode;
  bool get monthCollapsed => _monthCollapsed;
  List<CalendarEvent> get events => _events;
  List<CalendarEvent> get upcoming => _upcoming;
  List<Map<String, dynamic>> get categories => _categories;
  Map<String, List<CalendarEvent>> get groupedEvents => _groupedEvents;
  bool get isLoading => _isLoading;
  String? get coldStartMessage => _coldStartMessage;

  List<CalendarEvent> get eventsForSelectedDate {
    final key = _dateKey(_selectedDate);
    final list = List<CalendarEvent>.from(_groupedEvents[key] ?? []);
    list.sort(_compareEvents);
    return list;
  }

  CalendarProvider() {
    _loadInitialData();
  }

  static const Duration _backendTimeout = Duration(seconds: 12);

  Future<void> _loadInitialData() async {
    await _loadLocalData();
    _syncBackendInBackground();
  }

  Future<void> _loadLocalData() async {
    try {
      await loadCategories();
      await loadEvents();
      await loadUpcoming();
    } catch (_) {
      // Local DB unavailable — UI still renders.
    }
    _isLoading = false;
    _coldStartMessage = null;
    notifyListeners();
  }

  void _syncBackendInBackground() {
    syncFromBackend().then((_) => notifyListeners());
  }

  String _dateKey(DateTime d) =>
      DateTime(d.year, d.month, d.day).toIso8601String().split('T')[0];

  int _compareEvents(CalendarEvent a, CalendarEvent b) {
    if (a.isAllDay && !b.isAllDay) return -1;
    if (!a.isAllDay && b.isAllDay) return 1;
    return a.startTime.compareTo(b.startTime);
  }

  Future<void> loadEvents() async {
    _events = await _dao.getEventsForMonth(currentMonth);
    _groupedEvents = await _dao.getEventsGroupedByDate(currentMonth);
    notifyListeners();
  }

  Future<void> loadUpcoming() async {
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    _upcoming = await _dao.getUpcomingEvents(from: today, limit: 100);
    notifyListeners();
  }

  Future<void> loadCategories() async {
    _categories = await _dao.getCategories();
    notifyListeners();
  }

  void setViewMode(CalendarViewMode mode) {
    if (_viewMode == mode) return;
    _viewMode = mode;
    notifyListeners();
  }

  void toggleMonthCollapsed() {
    _monthCollapsed = !_monthCollapsed;
    notifyListeners();
  }

  void selectDate(DateTime date) {
    _selectedDate = DateTime(date.year, date.month, date.day);
    final monthChanged = date.year != _focusedDay.year ||
        date.month != _focusedDay.month;
    _focusedDay = _selectedDate;
    if (monthChanged) {
      loadEvents();
    } else {
      notifyListeners();
    }
  }

  void goToToday() {
    final now = DateTime.now();
    selectDate(now);
  }

  void goToPreviousMonth() {
    final m = currentMonth;
    _focusedDay = DateTime(m.year, m.month - 1, 1);
    loadEvents();
  }

  void goToNextMonth() {
    final m = currentMonth;
    _focusedDay = DateTime(m.year, m.month + 1, 1);
    loadEvents();
  }

  void shiftFocusedDay(int days) {
    final next = _focusedDay.add(Duration(days: days));
    selectDate(next);
  }

  void goToPreviousWeek() => shiftFocusedDay(-7);
  void goToNextWeek() => shiftFocusedDay(7);

  List<CalendarEvent> eventsForDate(DateTime date) {
    final key = _dateKey(date);
    final list = List<CalendarEvent>.from(_groupedEvents[key] ?? []);
    // Also check upcoming for dates outside loaded month
    if (list.isEmpty) {
      for (final e in _upcoming) {
        if (_dateKey(e.startTime) == key) list.add(e);
      }
    }
    list.sort(_compareEvents);
    return list;
  }

  Future<void> addEvent({
    required String title,
    required DateTime date,
    DateTime? endTime,
    bool isAllDay = false,
    String? categoryId,
    String? emoji,
    String? location,
    String? description,
    String priority = 'important',
    String? recurrenceRule,
  }) async {
    final now = DateTime.now();
    final event = CalendarEvent(
      id: _uuid.v4(),
      householdId: 'default',
      title: title,
      description: description,
      startTime: date,
      endTime: endTime,
      isAllDay: isAllDay,
      categoryId: categoryId,
      emoji: emoji,
      location: location,
      priority: priority,
      recurrenceRule: recurrenceRule == 'none' ? null : recurrenceRule,
      source: 'manual',
      createdAt: now,
      updatedAt: now,
    );

    await _dao.insertEvent(event);
    await loadEvents();
    await loadUpcoming();
  }

  Future<void> updateEvent(CalendarEvent event) async {
    final updated = event.copyWith(updatedAt: DateTime.now());
    await _dao.updateEvent(updated);
    await loadEvents();
    await loadUpcoming();
  }

  Future<void> addEventFromPipeline({
    required String title,
    required DateTime date,
    String? categoryId,
    String priority = 'important',
  }) async {
    final now = DateTime.now();
    final event = CalendarEvent(
      id: _uuid.v4(),
      householdId: 'default',
      title: title,
      startTime: date,
      categoryId: categoryId ?? 'beth',
      priority: priority,
      source: 'pipeline',
      createdAt: now,
      updatedAt: now,
    );

    await _dao.insertEvent(event);
    await loadEvents();
    await loadUpcoming();
  }

  Future<void> deleteEvent(String id) async {
    await _dao.deleteEvent(id);
    await loadEvents();
    await loadUpcoming();
  }

  Future<List<CalendarEvent>> checkConflicts({
    required DateTime date,
    DateTime? startTime,
    DateTime? endTime,
    String? excludeId,
  }) {
    return _dao.checkConflicts(
      date,
      startTime,
      endTime,
      excludeId: excludeId,
    );
  }

  Future<void> syncFromBackend() async {
    _coldStartMessage = 'Checking server…';
    notifyListeners();
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/events'))
          .timeout(_backendTimeout);
      final data = jsonDecode(res.body);
      final incoming = (data['events'] as List)
          .map((e) => CalendarEvent.fromJson(e as Map<String, dynamic>))
          .toList();

      final existingEvents = await _dao.getEventsForMonth(currentMonth);
      for (final old in existingEvents) {
        if (old.id.startsWith('backend_')) {
          await _dao.deleteEvent(old.id);
        }
      }

      for (final event in incoming) {
        try {
          await _dao.insertEvent(event);
        } catch (_) {
          // Skip if already exists
        }
      }

      await loadEvents();
      await loadUpcoming();
      _coldStartMessage = null;
    } catch (_) {
      _coldStartMessage = null;
      // Backend slow/unavailable — keep local calendar.
    }
    notifyListeners();
  }

  Color getCategoryColour(String? categoryId) {
    if (categoryId == null) return BethColours.textMuted;
    try {
      final cat = _categories.firstWhere((c) => c['id'] == categoryId);
      final hex = cat['colour'] as String;
      return BethColours.fromHex(hex);
    } catch (_) {
      return BethColours.textMuted;
    }
  }

  String getCategoryName(String? categoryId) {
    if (categoryId == null) return '';
    try {
      final cat = _categories.firstWhere((c) => c['id'] == categoryId);
      return cat['name'] as String;
    } catch (_) {
      return '';
    }
  }

  String? getCategoryIcon(String? categoryId) {
    if (categoryId == null) return null;
    try {
      final cat = _categories.firstWhere((c) => c['id'] == categoryId);
      return cat['icon'] as String?;
    } catch (_) {
      return null;
    }
  }

  /// Agenda groups: Today, Tomorrow, This Week, Next Week, Later.
  Map<String, List<CalendarEvent>> get agendaGroups {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final weekEnd = today.add(Duration(days: 7 - today.weekday + 1));
    final nextWeekEnd = weekEnd.add(const Duration(days: 7));

    final groups = <String, List<CalendarEvent>>{
      'Today': [],
      'Tomorrow': [],
      'This Week': [],
      'Next Week': [],
      'Later': [],
    };

    for (final e in _upcoming) {
      final d = DateTime(e.startTime.year, e.startTime.month, e.startTime.day);
      if (d == today) {
        groups['Today']!.add(e);
      } else if (d == tomorrow) {
        groups['Tomorrow']!.add(e);
      } else if (d.isAfter(tomorrow) && d.isBefore(weekEnd)) {
        groups['This Week']!.add(e);
      } else if (!d.isBefore(weekEnd) && d.isBefore(nextWeekEnd)) {
        groups['Next Week']!.add(e);
      } else if (d.isAfter(today) || d == today) {
        groups['Later']!.add(e);
      }
    }
    return groups;
  }
}
