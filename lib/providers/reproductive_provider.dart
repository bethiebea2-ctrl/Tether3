import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../database/cycle_dao.dart';
import '../database/database_helper.dart';
import '../models/cycle_entry.dart';

class ReproductiveProvider extends ChangeNotifier {
  final CycleDao _cycleDao = CycleDao();
  final _uuid = const Uuid();

  List<CycleEntry> cycles = [];
  List<Map<String, dynamic>> breastfeedingLogs = [];
  String? contraceptionMethod;
  String? contraceptionNotes;
  DateTime? pregnancyStart;
  DateTime? pregnancyDueDate;
  String? postpartumNotes;
  DateTime? sixWeekCheckDue;
  final Set<String> mensChecklistDone = {};
  bool loaded = false;

  CycleEntry? get latestCycle => cycles.isEmpty ? null : cycles.first;

  /// Average cycle length from last entries; default 28. "May be" phrasing only.
  int get averageCycleLength {
    if (cycles.length < 2) return 28;
    final starts = cycles.map((c) => c.periodStartDate).toList()
      ..sort((a, b) => b.compareTo(a));
    final gaps = <int>[];
    for (var i = 0; i < starts.length - 1 && i < 5; i++) {
      final days = starts[i].difference(starts[i + 1]).inDays.abs();
      if (days >= 21 && days <= 45) gaps.add(days);
    }
    if (gaps.isEmpty) return 28;
    return (gaps.reduce((a, b) => a + b) / gaps.length).round().clamp(21, 40);
  }

  DateTime? get mayBeNextPeriod {
    final latest = latestCycle;
    if (latest == null) return null;
    return latest.periodStartDate.add(Duration(days: averageCycleLength));
  }

  /// Phase for a given day relative to latest cycle start. Null if unknown.
  String? phaseForDate(DateTime day) {
    final latest = latestCycle;
    if (latest == null) return null;
    final start = DateTime(
      latest.periodStartDate.year,
      latest.periodStartDate.month,
      latest.periodStartDate.day,
    );
    final d = DateTime(day.year, day.month, day.day);
    var dayNum = d.difference(start).inDays;
    if (dayNum < 0) return null;
    final len = averageCycleLength;
    dayNum = dayNum % len;
    if (dayNum <= 4) return 'menstrual';
    if (dayNum <= 12) return 'follicular';
    if (dayNum <= 15) return 'ovulation';
    return 'luteal';
  }

  Future<void> load() async {
    cycles = await _cycleDao.getAll();
    final prefs = await SharedPreferences.getInstance();
    contraceptionMethod = prefs.getString('repro_contraception_method');
    contraceptionNotes = prefs.getString('repro_contraception_notes');
    final preg = prefs.getString('repro_pregnancy_start');
    pregnancyStart = preg != null ? DateTime.tryParse(preg) : null;
    final due = prefs.getString('repro_pregnancy_due');
    pregnancyDueDate = due != null ? DateTime.tryParse(due) : null;
    postpartumNotes = prefs.getString('repro_postpartum_notes');
    final six = prefs.getString('repro_six_week');
    sixWeekCheckDue = six != null ? DateTime.tryParse(six) : null;
    mensChecklistDone
      ..clear()
      ..addAll(prefs.getStringList('repro_mens_checklist') ?? const []);
    final db = await DatabaseHelper().database;
    breastfeedingLogs = await db.query(
      'breastfeeding_logs',
      orderBy: 'logged_at DESC',
      limit: 40,
    );
    loaded = true;
    notifyListeners();
  }

  Future<void> logPeriodStart({
    DateTime? start,
    DateTime? end,
    String? flow,
    List<String> symptoms = const [],
    String? notes,
  }) async {
    final entry = CycleEntry(
      id: _uuid.v4(),
      periodStartDate: start ?? DateTime.now(),
      periodEndDate: end,
      flowIntensity: flow,
      symptoms: symptoms,
      notes: notes,
      createdAt: DateTime.now(),
    );
    await _cycleDao.insert(entry);
    cycles = [entry, ...cycles]
      ..sort((a, b) => b.periodStartDate.compareTo(a.periodStartDate));
    notifyListeners();
  }

  Future<void> setContraception(String? method, String? notes) async {
    contraceptionMethod = method;
    contraceptionNotes = notes;
    final prefs = await SharedPreferences.getInstance();
    if (method == null) {
      await prefs.remove('repro_contraception_method');
    } else {
      await prefs.setString('repro_contraception_method', method);
    }
    if (notes == null) {
      await prefs.remove('repro_contraception_notes');
    } else {
      await prefs.setString('repro_contraception_notes', notes);
    }
    notifyListeners();
  }

  Future<void> setPregnancyStart(DateTime? date) async {
    pregnancyStart = date;
    final prefs = await SharedPreferences.getInstance();
    if (date == null) {
      await prefs.remove('repro_pregnancy_start');
    } else {
      await prefs.setString('repro_pregnancy_start', date.toIso8601String());
    }
    notifyListeners();
  }

  Future<void> setPregnancyDueDate(DateTime? date) async {
    pregnancyDueDate = date;
    final prefs = await SharedPreferences.getInstance();
    if (date == null) {
      await prefs.remove('repro_pregnancy_due');
    } else {
      await prefs.setString('repro_pregnancy_due', date.toIso8601String());
    }
    notifyListeners();
  }

  Future<void> setPostpartumNotes(String notes, {DateTime? sixWeek}) async {
    postpartumNotes = notes;
    sixWeekCheckDue = sixWeek;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('repro_postpartum_notes', notes);
    if (sixWeek != null) {
      await prefs.setString('repro_six_week', sixWeek.toIso8601String());
    }
    notifyListeners();
  }

  Future<void> logBreastfeed({
    String? side,
    int? minutes,
    String? notes,
  }) async {
    final db = await DatabaseHelper().database;
    await db.insert('breastfeeding_logs', {
      'id': _uuid.v4(),
      'logged_at': DateTime.now().toIso8601String(),
      'side': side,
      'duration_minutes': minutes,
      'notes': notes,
    });
    breastfeedingLogs = await db.query(
      'breastfeeding_logs',
      orderBy: 'logged_at DESC',
      limit: 40,
    );
    notifyListeners();
  }

  Future<void> toggleMensItem(String id) async {
    if (mensChecklistDone.contains(id)) {
      mensChecklistDone.remove(id);
    } else {
      mensChecklistDone.add(id);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'repro_mens_checklist',
      mensChecklistDone.toList(),
    );
    notifyListeners();
  }

  int? get gestationWeeks {
    if (pregnancyStart == null) return null;
    return DateTime.now().difference(pregnancyStart!).inDays ~/ 7;
  }
}
