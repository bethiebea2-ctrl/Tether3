import 'dart:convert';

class PetProfile {
  final String? vetContact;
  final String? conditions;
  final String? medications;
  final String? injuries;
  /// yes | no | unknown | na
  final String spayedNeutered;

  const PetProfile({
    this.vetContact,
    this.conditions,
    this.medications,
    this.injuries,
    this.spayedNeutered = 'unknown',
  });

  Map<String, dynamic> toMap() => {
        'vet_contact': vetContact,
        'conditions': conditions,
        'medications': medications,
        'injuries': injuries,
        'spayed_neutered': spayedNeutered,
      };

  factory PetProfile.fromMap(Map<String, dynamic> map) => PetProfile(
        vetContact: map['vet_contact'] as String?,
        conditions: map['conditions'] as String?,
        medications: map['medications'] as String?,
        injuries: map['injuries'] as String?,
        spayedNeutered: map['spayed_neutered'] as String? ?? 'unknown',
      );

  String toJson() => jsonEncode(toMap());

  static PetProfile fromJson(String? raw) {
    if (raw == null || raw.isEmpty || raw == '{}') return const PetProfile();
    try {
      final map = jsonDecode(raw);
      if (map is Map<String, dynamic>) return PetProfile.fromMap(map);
    } catch (_) {}
    return const PetProfile();
  }

  PetProfile copyWith({
    String? vetContact,
    String? conditions,
    String? medications,
    String? injuries,
    String? spayedNeutered,
  }) =>
      PetProfile(
        vetContact: vetContact ?? this.vetContact,
        conditions: conditions ?? this.conditions,
        medications: medications ?? this.medications,
        injuries: injuries ?? this.injuries,
        spayedNeutered: spayedNeutered ?? this.spayedNeutered,
      );
}

const petSpayNeuterOptions = <(String, String)>[
  ('yes', 'Yes — spayed/neutered'),
  ('no', 'No'),
  ('unknown', 'Unknown'),
  ('na', 'Not applicable'),
];
