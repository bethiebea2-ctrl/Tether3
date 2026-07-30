import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../database/health_dao.dart';
import '../models/health_models.dart';

class HealthProvider extends ChangeNotifier {
  final HealthDao _dao = HealthDao();
  final _uuid = const Uuid();

  List<PersonalMedication> _medications = [];
  List<HealthLogEntry> _logs = [];
  List<AllergyEntry> _allergies = [];
  List<HealthDocument> _documents = [];
  List<SeizureLogEntry> _seizures = [];
  bool _loaded = false;

  List<PersonalMedication> get medications => List.unmodifiable(_medications);
  List<HealthLogEntry> get logs => List.unmodifiable(_logs);
  List<AllergyEntry> get allergies => List.unmodifiable(_allergies);
  List<HealthDocument> get documents => List.unmodifiable(_documents);
  List<SeizureLogEntry> get seizures => List.unmodifiable(_seizures);
  bool get isLoaded => _loaded;
  bool get loaded => _loaded;

  Future<void> load() async {
    _medications = await _dao.getPersonalMedications();
    _logs = await _dao.getHealthLogs(limit: 50);
    _allergies = await _dao.getAllergies();
    _documents = await _dao.getDocuments();
    _seizures = await _dao.getSeizureLogs(limit: 30);
    _loaded = true;
    notifyListeners();
  }

  // ── Medications ────────────────────────────────────────────

  Future<void> addMedication({
    required String name,
    required double dose,
    required String doseUnit,
    required String mode,
    String? notes,
  }) async {
    final med = PersonalMedication(
      id: _uuid.v4(),
      name: name,
      dose: dose,
      doseUnit: doseUnit,
      mode: mode,
      notes: notes,
      createdAt: DateTime.now(),
      personId: 'self',
    );
    await _dao.insertPersonalMedication(med);
    _medications = [..._medications, med]
      ..sort((a, b) => a.name.compareTo(b.name));
    notifyListeners();
  }

  Future<void> updateMedication(PersonalMedication med) async {
    final updated = PersonalMedication(
      id: med.id,
      name: med.name,
      dose: med.dose,
      doseUnit: med.doseUnit,
      mode: med.mode,
      notes: med.notes,
      lastGiven: med.lastGiven,
      createdAt: med.createdAt,
      personId: 'self',
    );
    await _dao.updatePersonalMedication(updated);
    final idx = _medications.indexWhere((m) => m.id == med.id);
    if (idx != -1) {
      _medications = [..._medications]..[idx] = updated;
      notifyListeners();
    }
  }

  Future<void> deleteMedication(String id) async {
    await _dao.deletePersonalMedication(id);
    _medications = _medications.where((m) => m.id != id).toList();
    notifyListeners();
  }

  Future<void> logDose(PersonalMedication med, {String? notes}) async {
    await _dao.logPersonalDose(
      medicationId: med.id,
      doseGiven: med.dose,
      notes: notes,
    );
    final updated = PersonalMedication(
      id: med.id,
      name: med.name,
      dose: med.dose,
      doseUnit: med.doseUnit,
      mode: med.mode,
      notes: med.notes,
      lastGiven: DateTime.now(),
      createdAt: med.createdAt,
      personId: 'self',
    );
    final idx = _medications.indexWhere((m) => m.id == med.id);
    if (idx != -1) {
      _medications = [..._medications]..[idx] = updated;
      notifyListeners();
    }
  }

  // ── Health logs ────────────────────────────────────────────

  Future<void> addHealthLog({
    required String type,
    double? valueNum,
    double? valueNumSecondary,
    String? valueText,
    String? notes,
  }) async {
    final entry = HealthLogEntry(
      id: _uuid.v4(),
      type: type,
      valueNum: valueNum,
      valueNumSecondary: valueNumSecondary,
      valueText: valueText,
      notes: notes,
      loggedAt: DateTime.now(),
    );
    await _dao.insertHealthLog(entry);
    _logs = [entry, ..._logs];
    notifyListeners();
  }

  /// Alias used by some call sites.
  Future<void> addLog({
    required String type,
    double? valueNum,
    double? valueSecondary,
    String? valueText,
    String? notes,
  }) =>
      addHealthLog(
        type: type,
        valueNum: valueNum,
        valueNumSecondary: valueSecondary,
        valueText: valueText,
        notes: notes,
      );

  Future<void> deleteHealthLog(String id) async {
    await _dao.deleteHealthLog(id);
    _logs = _logs.where((e) => e.id != id).toList();
    notifyListeners();
  }

  // ── Allergies ──────────────────────────────────────────────

  Future<void> addAllergy({
    required String name,
    String? severity,
    String? notes,
  }) async {
    final entry = AllergyEntry(
      id: _uuid.v4(),
      name: name,
      severity: severity,
      notes: notes,
      createdAt: DateTime.now(),
    );
    await _dao.insertAllergy(entry);
    _allergies = [..._allergies, entry]
      ..sort((a, b) => a.name.compareTo(b.name));
    notifyListeners();
  }

  Future<void> deleteAllergy(String id) async {
    await _dao.deleteAllergy(id);
    _allergies = _allergies.where((a) => a.id != id).toList();
    notifyListeners();
  }

  // ── Documents ──────────────────────────────────────────────

  Future<void> addDocument({
    required String title,
    String? docType,
    String? notes,
    String? filePath,
  }) async {
    final doc = HealthDocument(
      id: _uuid.v4(),
      title: title,
      docType: docType,
      notes: notes,
      filePath: filePath,
      createdAt: DateTime.now(),
    );
    await _dao.insertDocument(doc);
    _documents = [doc, ..._documents];
    notifyListeners();
  }

  Future<void> deleteDocument(String id) async {
    await _dao.deleteDocument(id);
    _documents = _documents.where((d) => d.id != id).toList();
    notifyListeners();
  }

  // ── Seizures ───────────────────────────────────────────────

  Future<SeizureLogEntry> addSeizureLog({
    DateTime? startedAt,
    int? durationMinutes,
    String? notes,
    bool postSeizureModeTriggered = false,
  }) async {
    final entry = SeizureLogEntry(
      id: _uuid.v4(),
      startedAt: startedAt ?? DateTime.now(),
      durationMinutes: durationMinutes,
      notes: notes,
      postSeizureModeTriggered: postSeizureModeTriggered,
    );
    await _dao.insertSeizureLog(entry);
    _seizures = [entry, ..._seizures];
    notifyListeners();
    return entry;
  }

  Future<void> addSeizure({
    int? durationMinutes,
    String? notes,
    bool triggerRecovery = false,
  }) async {
    await addSeizureLog(
      durationMinutes: durationMinutes,
      notes: notes,
      postSeizureModeTriggered: triggerRecovery,
    );
  }

  Future<void> deleteSeizureLog(String id) async {
    await _dao.deleteSeizureLog(id);
    _seizures = _seizures.where((s) => s.id != id).toList();
    notifyListeners();
  }

  /// Plain-text summary for clipboard / share ("Discuss with Doctor").
  String discussWithDoctorExport() {
    final fmt = DateFormat('d MMM yyyy, HH:mm');
    final buf = StringBuffer();
    buf.writeln('HEALTH SUMMARY — Discuss with Doctor');
    buf.writeln('Generated: ${fmt.format(DateTime.now())}');
    buf.writeln();
    buf.writeln('This is personal tracking data only. Not medical advice.');
    buf.writeln('No AI interpretation included.');
    buf.writeln();

    buf.writeln('— Current medications —');
    if (_medications.isEmpty) {
      buf.writeln('(none recorded)');
    } else {
      for (final m in _medications) {
        buf.writeln(
          '• ${m.name}: ${m.dose} ${m.doseUnit} (${m.mode})'
          '${m.notes != null && m.notes!.isNotEmpty ? ' — ${m.notes}' : ''}'
          '${m.lastGiven != null ? ' | last given ${fmt.format(m.lastGiven!)}' : ''}',
        );
      }
    }
    buf.writeln();

    buf.writeln('— Allergies —');
    if (_allergies.isEmpty) {
      buf.writeln('(none recorded)');
    } else {
      for (final a in _allergies) {
        buf.writeln(
          '• ${a.name}'
          '${a.severity != null ? ' (${a.severity})' : ''}'
          '${a.notes != null && a.notes!.isNotEmpty ? ' — ${a.notes}' : ''}',
        );
      }
    }
    buf.writeln();

    buf.writeln('— Recent health logs (up to 30) —');
    final recent = _logs.take(30);
    if (recent.isEmpty) {
      buf.writeln('(none recorded)');
    } else {
      for (final e in recent) {
        buf.writeln(
          '• ${fmt.format(e.loggedAt)} [${e.type}] ${e.displayValue()}'
          '${e.notes != null && e.notes!.isNotEmpty ? ' — ${e.notes}' : ''}',
        );
      }
    }
    buf.writeln();

    buf.writeln('— Seizure log —');
    if (_seizures.isEmpty) {
      buf.writeln('(none recorded)');
    } else {
      for (final s in _seizures.take(10)) {
        buf.writeln(
          '• ${fmt.format(s.startedAt)}'
          '${s.durationMinutes != null ? ' · ${s.durationMinutes} min' : ''}'
          '${s.notes != null && s.notes!.isNotEmpty ? ' — ${s.notes}' : ''}',
        );
      }
    }
    buf.writeln();

    buf.writeln('— Documents on file —');
    if (_documents.isEmpty) {
      buf.writeln('(none recorded)');
    } else {
      for (final d in _documents) {
        buf.writeln(
          '• ${d.title}'
          '${d.docType != null ? ' [${d.docType}]' : ''}'
          '${d.notes != null && d.notes!.isNotEmpty ? ' — ${d.notes}' : ''}',
        );
      }
    }

    return buf.toString();
  }
}
