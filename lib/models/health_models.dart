// Phase 1D Health Status models.
// Convention: personal meds use person_id NULL, '' or 'self';
// Dependent meds use a real person_id (Family Hub).

class HealthLogEntry {
  final String id;
  /// bp | glucose | symptom | pain | sleep
  final String type;
  /// Primary numeric value (systolic, glucose, pain 1–10, sleep hours).
  final double? valueNum;
  /// Secondary numeric (e.g. diastolic for BP).
  final double? valueNumSecondary;
  /// Free-text value (symptom label, or "120/80" style).
  final String? valueText;
  final String? notes;
  final DateTime loggedAt;

  const HealthLogEntry({
    required this.id,
    required this.type,
    this.valueNum,
    this.valueNumSecondary,
    this.valueText,
    this.notes,
    required this.loggedAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type,
        'value_num': valueNum,
        'value_secondary': valueNumSecondary,
        'value_text': valueText,
        'notes': notes,
        'logged_at': loggedAt.toIso8601String(),
      };

  factory HealthLogEntry.fromMap(Map<String, dynamic> map) => HealthLogEntry(
        id: map['id'] as String,
        type: map['type'] as String,
        valueNum: (map['value_num'] as num?)?.toDouble(),
        valueNumSecondary: (map['value_secondary'] as num?)?.toDouble() ??
            (map['value_num_secondary'] as num?)?.toDouble(),
        valueText: map['value_text'] as String?,
        notes: map['notes'] as String?,
        loggedAt: DateTime.parse(map['logged_at'] as String),
      );

  String displayValue() {
    switch (type) {
      case 'bp':
        if (valueNum != null && valueNumSecondary != null) {
          return '${valueNum!.toStringAsFixed(0)}/${valueNumSecondary!.toStringAsFixed(0)}';
        }
        return valueText ?? '—';
      case 'glucose':
        return valueNum != null ? valueNum!.toStringAsFixed(1) : (valueText ?? '—');
      case 'pain':
        return valueNum != null ? '${valueNum!.toStringAsFixed(0)}/10' : (valueText ?? '—');
      case 'sleep':
        return valueNum != null ? '${valueNum!.toStringAsFixed(1)} h' : (valueText ?? '—');
      default:
        return valueText ?? '—';
    }
  }
}

class AllergyEntry {
  final String id;
  final String name;
  final String? severity;
  final String? notes;
  final DateTime createdAt;

  const AllergyEntry({
    required this.id,
    required this.name,
    this.severity,
    this.notes,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'severity': severity,
        'notes': notes,
        'created_at': createdAt.toIso8601String(),
      };

  factory AllergyEntry.fromMap(Map<String, dynamic> map) => AllergyEntry(
        id: map['id'] as String,
        name: map['name'] as String,
        severity: map['severity'] as String?,
        notes: map['notes'] as String?,
        createdAt: DateTime.parse(map['created_at'] as String),
      );
}

class HealthDocument {
  final String id;
  final String title;
  final String? docType;
  final String? notes;
  final String? filePath;
  final DateTime createdAt;

  const HealthDocument({
    required this.id,
    required this.title,
    this.docType,
    this.notes,
    this.filePath,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'doc_type': docType,
        'notes': notes,
        'file_path': filePath,
        'created_at': createdAt.toIso8601String(),
      };

  factory HealthDocument.fromMap(Map<String, dynamic> map) => HealthDocument(
        id: map['id'] as String,
        title: map['title'] as String,
        docType: map['doc_type'] as String?,
        notes: map['notes'] as String?,
        filePath: map['file_path'] as String?,
        createdAt: DateTime.parse(map['created_at'] as String),
      );
}

class SeizureLogEntry {
  final String id;
  final DateTime startedAt;
  final int? durationMinutes;
  final String? notes;
  final bool postSeizureModeTriggered;

  const SeizureLogEntry({
    required this.id,
    required this.startedAt,
    this.durationMinutes,
    this.notes,
    this.postSeizureModeTriggered = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'started_at': startedAt.toIso8601String(),
        'duration_minutes': durationMinutes,
        'notes': notes,
        'post_seizure_mode': postSeizureModeTriggered ? 1 : 0,
      };

  factory SeizureLogEntry.fromMap(Map<String, dynamic> map) => SeizureLogEntry(
        id: map['id'] as String,
        startedAt: DateTime.parse(map['started_at'] as String),
        durationMinutes: map['duration_minutes'] as int?,
        notes: map['notes'] as String?,
        postSeizureModeTriggered:
            (map['post_seizure_mode'] as int?) == 1 ||
            (map['post_seizure_mode_triggered'] as int?) == 1,
      );
}

/// Personal (self) medication row from the shared `medications` table.
class PersonalMedication {
  final String id;
  final String name;
  final double dose;
  final String doseUnit;
  /// scheduled | as_needed
  final String mode;
  final String? notes;
  final DateTime? lastGiven;
  final DateTime createdAt;
  /// Always 'self' for inserts from Health Status.
  final String personId;

  const PersonalMedication({
    required this.id,
    required this.name,
    required this.dose,
    required this.doseUnit,
    required this.mode,
    this.notes,
    this.lastGiven,
    required this.createdAt,
    this.personId = 'self',
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'child_id': null,
        'person_id': personId,
        'name': name,
        'dose': dose,
        'dose_unit': doseUnit,
        'notes': notes,
        'mode': mode,
        'last_given': lastGiven?.toIso8601String(),
        'created_at': createdAt.toIso8601String(),
        'scheduled_times': '',
      };

  factory PersonalMedication.fromMap(Map<String, dynamic> map) =>
      PersonalMedication(
        id: map['id'] as String,
        name: map['name'] as String,
        dose: (map['dose'] as num).toDouble(),
        doseUnit: map['dose_unit'] as String,
        mode: map['mode'] as String? ?? 'as_needed',
        notes: map['notes'] as String?,
        lastGiven: map['last_given'] != null
            ? DateTime.parse(map['last_given'] as String)
            : null,
        createdAt: DateTime.parse(map['created_at'] as String),
        personId: (map['person_id'] as String?)?.isNotEmpty == true
            ? map['person_id'] as String
            : 'self',
      );
}

class MedicationLogEntry {
  final String id;
  final String medicationId;
  final DateTime givenAt;
  final double doseGiven;
  final String? notes;

  const MedicationLogEntry({
    required this.id,
    required this.medicationId,
    required this.givenAt,
    required this.doseGiven,
    this.notes,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'medication_id': medicationId,
        'given_at': givenAt.toIso8601String(),
        'dose_given': doseGiven,
        'notes': notes,
      };

  factory MedicationLogEntry.fromMap(Map<String, dynamic> map) =>
      MedicationLogEntry(
        id: map['id'] as String,
        medicationId: map['medication_id'] as String,
        givenAt: DateTime.parse(map['given_at'] as String),
        doseGiven: (map['dose_given'] as num).toDouble(),
        notes: map['notes'] as String?,
      );
}
