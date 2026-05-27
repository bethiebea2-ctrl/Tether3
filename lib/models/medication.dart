class Medication {
  final String id;
  final String childId; // or null for personal medications
  final String name;
  final double dose;
  final String doseUnit;
  final int? minimumIntervalHours;
  final int? minimumIntervalMinutes;
  final List<DateTime> scheduledTimes;
  final String? notes;
  final String mode; // 'scheduled' or 'as_needed'
  final DateTime? lastGiven;
  final DateTime createdAt;

  Medication({
    required this.id,
    required this.childId,
    required this.name,
    required this.dose,
    required this.doseUnit,
    this.minimumIntervalHours,
    this.minimumIntervalMinutes,
    this.scheduledTimes = const [],
    this.notes,
    required this.mode,
    this.lastGiven,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'child_id': childId,
    'name': name,
    'dose': dose,
    'dose_unit': doseUnit,
    'minimum_interval_hours': minimumIntervalHours,
    'minimum_interval_minutes': minimumIntervalMinutes,
    'scheduled_times': scheduledTimes.map((t) => t.toIso8601String()).join(','),
    'notes': notes,
    'mode': mode,
    'last_given': lastGiven?.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
  };

  factory Medication.fromMap(Map<String, dynamic> map) {
    final timesString = map['scheduled_times'] as String? ?? '';
    final times = timesString.isNotEmpty
        ? timesString.split(',').map((s) => DateTime.parse(s)).toList()
        : <DateTime>[];
    
    return Medication(
      id: map['id'],
      childId: map['child_id'],
      name: map['name'],
      dose: (map['dose'] as num).toDouble(),
      doseUnit: map['dose_unit'],
      minimumIntervalHours: map['minimum_interval_hours'],
      minimumIntervalMinutes: map['minimum_interval_minutes'],
      scheduledTimes: times,
      notes: map['notes'],
      mode: map['mode'],
      lastGiven: map['last_given'] != null ? DateTime.parse(map['last_given']) : null,
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  /// Calculate next available time for as-needed medications
  DateTime? get nextAvailable {
    if (lastGiven == null || mode != 'as_needed') return null;
    final totalMinutes = (minimumIntervalHours ?? 0) * 60 + (minimumIntervalMinutes ?? 0);
    return lastGiven!.add(Duration(minutes: totalMinutes));
  }

  /// Medication status colour
  String get statusColour {
    if (mode != 'as_needed' || lastGiven == null) return 'green';
    final next = nextAvailable!;
    final now = DateTime.now();
    if (now.isAfter(next) || now.isAtSameMomentAs(next)) return 'green';
    if (next.difference(now).inMinutes <= 60) return 'amber';
    return 'red';
  }
}