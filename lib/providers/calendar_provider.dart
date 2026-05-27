import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../models/calendar_event.dart';
import '../database/calendar_dao.dart';

class CalendarProvider extends ChangeNotifier {
  static const String baseUrl = "https://tether-backend-laue.onrender.com";
  
  final CalendarDao _dao = CalendarDao();
  final _uuid = const Uuid();

  DateTime _currentMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime _selectedDate = DateTime.now();
  List<CalendarEvent> _events = [];
  List<Map<String, dynamic>> _categories = [];
  Map<String, List<CalendarEvent>> _groupedEvents = {};
  bool _isLoading = false;

  DateTime get currentMonth => _currentMonth;
  DateTime get selectedDate => _selectedDate;
  List<CalendarEvent> get events => _events;
  List<Map<String, dynamic>> get categories => _categories;
  Map<String, List<CalendarEvent>> get groupedEvents => _groupedEvents;
  bool get isLoading => _isLoading;

  List<CalendarEvent> get eventsForSelectedDate {
    final key = _selectedDate.toIso8601String().split('T')[0];
    return _groupedEvents[key] ?? [];
  }

  CalendarProvider() {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    _isLoading = true;
    notifyListeners();

    await syncFromBackend();
    await loadCategories();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadEvents() async {
    _events = await _dao.getEventsForMonth(_currentMonth);
    _groupedEvents = await _dao.getEventsGroupedByDate(_currentMonth);
    notifyListeners();
  }

  Future<void> loadCategories() async {
    _categories = await _dao.getCategories();
    notifyListeners();
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void goToPreviousMonth() {
    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    loadEvents();
  }

  void goToNextMonth() {
    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    loadEvents();
  }

  // Manual event creation — uses unified CalendarEvent model
  Future<void> addEvent({
    required String title,
    required DateTime date,
    DateTime? endTime,
    String? categoryId,
    String? emoji,
    String? location,
    String? description,
  }) async {
    final now = DateTime.now();
    final event = CalendarEvent(
      id: _uuid.v4(),
      householdId: 'default',
      title: title,
      description: description,
      startTime: date,
      endTime: endTime,
      categoryId: categoryId,
      location: location,
      source: 'manual',
      createdAt: now,
      updatedAt: now,
    );

    await _dao.insertEvent(event);
    await loadEvents();
  }

  // Pipeline-driven event creation — uses unified CalendarEvent model
  Future<void> addEventFromPipeline({
    required String title,
    required DateTime date,
    String? categoryId,
    String priority = 'normal',
  }) async {
    final now = DateTime.now();
    final event = CalendarEvent(
      id: _uuid.v4(),
      householdId: 'default',
      title: title,
      startTime: date,
      categoryId: categoryId ?? 'beth',
      priority: priority,
      source: 'capture',
      description: 'From pipeline',
      createdAt: now,
      updatedAt: now,
    );

    await _dao.insertEvent(event);
    await loadEvents();
  }

  Future<void> deleteEvent(String id) async {
    await _dao.deleteEvent(id);
    await loadEvents();
  }

  Future<void> syncFromBackend() async {
    try {
      final res = await http.get(Uri.parse("$baseUrl/events"));
      final data = jsonDecode(res.body);
      final incoming = (data["events"] as List)
          .map((e) => CalendarEvent.fromJson(e))
          .toList();

      // Clear old pipeline events before fresh sync
      final existingEvents = await _dao.getEventsForMonth(_currentMonth);
      for (var old in existingEvents) {
        if (old.id.startsWith('backend_')) {
          await _dao.deleteEvent(old.id);
        }
      }

      for (var event in incoming) {
        try {
          await _dao.insertEvent(event);
        } catch (_) {
          // Skip if already exists
        }
      }

      await loadEvents();
    } catch (e) {
      // Backend not available
    }
  }

  Color getCategoryColour(String? categoryId) {
    if (categoryId == null) return Colors.grey;
    try {
      final cat = _categories.firstWhere((c) => c['id'] == categoryId);
      final hex = cat['colour'] as String;
      return Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16));
    } catch (_) {
      return Colors.grey;
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
}