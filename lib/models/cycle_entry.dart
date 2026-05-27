class CycleEntry {
  final String id;
  final DateTime periodStartDate;
  final DateTime? periodEndDate;
  final String? flowIntensity; // light, medium, heavy
  final List<String> symptoms;
  final int? energyLevel; // 1-10
  final String? notes;
  final bool sharedWithRhen;
  final DateTime createdAt;

  CycleEntry({
    required this.id,
    required this.periodStartDate,
    this.periodEndDate,
    this.flowIntensity,
    this.symptoms = const [],
    this.energyLevel,
    this.notes,
    this.sharedWithRhen = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'period_start_date': periodStartDate.toIso8601String(),
    'period_end_date': periodEndDate?.toIso8601String(),
    'flow_intensity': flowIntensity,
    'symptoms': symptoms.join(','),
    'energy_level': energyLevel,
    'notes': notes,
    'shared_with_rhen': sharedWithRhen ? 1 : 0,
    'created_at': createdAt.toIso8601String(),
  };

  factory CycleEntry.fromMap(Map<String, dynamic> map) => CycleEntry(
    id: map['id'],
    periodStartDate: DateTime.parse(map['period_start_date']),
    periodEndDate: map['period_end_date'] != null ? DateTime.parse(map['period_end_date']) : null,
    flowIntensity: map['flow_intensity'],
    symptoms: (map['symptoms'] as String? ?? '').split(',').where((s) => s.isNotEmpty).toList(),
    energyLevel: map['energy_level'],
    notes: map['notes'],
    sharedWithRhen: map['shared_with_rhen'] == 1,
    createdAt: DateTime.parse(map['created_at']),
  );

  int get cycleDay => DateTime.now().difference(periodStartDate).inDays + 1;
  
  String get currentPhase {
    if (cycleDay <= 5) return 'menstrual';
    if (cycleDay <= 13) return 'follicular';
    if (cycleDay <= 16) return 'ovulation';
    return 'luteal';
  }
}