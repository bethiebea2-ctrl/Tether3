import 'dart:convert';

import '../models/person.dart';

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

String spayNeuterLabel(String? key) {
  for (final o in petSpayNeuterOptions) {
    if (o.$1 == key) return o.$2;
  }
  return 'Unknown';
}

/// Label + value rows for expanded pet detail in Family Hub.
List<(String label, String value)> petDetailRows(Person pet) {
  final rows = <(String, String)>[];
  final identity = [
    if (pet.species != null && pet.species!.isNotEmpty) pet.species!,
    if (pet.breed != null && pet.breed!.isNotEmpty) pet.breed!,
  ].join(' · ');
  if (identity.isNotEmpty) rows.add(('Species & breed', identity));
  if (pet.legalName != null &&
      pet.legalName!.isNotEmpty &&
      pet.legalName != pet.displayName) {
    rows.add(('Registered name', pet.legalName!));
  }
  if (pet.dateOfBirth != null) {
    final d = pet.dateOfBirth!;
    rows.add((
      'Born / gotcha day',
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}',
    ));
  }
  final health = pet.petProfile;
  if (health.spayedNeutered != 'unknown') {
    rows.add(('Spayed / neutered', spayNeuterLabel(health.spayedNeutered)));
  }
  if (health.conditions != null && health.conditions!.isNotEmpty) {
    rows.add(('Conditions', health.conditions!));
  }
  if (health.medications != null && health.medications!.isNotEmpty) {
    rows.add(('Medications', health.medications!));
  }
  if (health.injuries != null && health.injuries!.isNotEmpty) {
    rows.add(('Injuries', health.injuries!));
  }
  if (health.vetContact != null && health.vetContact!.isNotEmpty) {
    rows.add(('Vet', health.vetContact!));
  }
  if (pet.notes != null && pet.notes!.isNotEmpty) {
    rows.add(('Notes', pet.notes!));
  }
  return rows;
}

/// Summary lines for Family Hub pet list tiles.
List<String> petSummaryLines(Person pet) {
  final lines = <String>[];
  final identity = [
    if (pet.species != null && pet.species!.isNotEmpty) pet.species!,
    if (pet.breed != null && pet.breed!.isNotEmpty) pet.breed!,
  ].join(' · ');
  if (identity.isNotEmpty) lines.add(identity);
  if (pet.legalName != null && pet.legalName!.isNotEmpty && pet.legalName != pet.displayName) {
    lines.add('Registered: ${pet.legalName}');
  }
  if (pet.dateOfBirth != null) {
    lines.add('Born ${pet.dateOfBirth!.day.toString().padLeft(2, '0')}/${pet.dateOfBirth!.month.toString().padLeft(2, '0')}/${pet.dateOfBirth!.year}');
  }
  final health = pet.petProfile;
  if (health.spayedNeutered != 'unknown') {
    lines.add(spayNeuterLabel(health.spayedNeutered));
  }
  if (health.conditions != null && health.conditions!.isNotEmpty) {
    lines.add('Conditions: ${health.conditions}');
  }
  if (health.medications != null && health.medications!.isNotEmpty) {
    lines.add('Meds: ${health.medications}');
  }
  if (health.injuries != null && health.injuries!.isNotEmpty) {
    lines.add('Injuries: ${health.injuries}');
  }
  if (health.vetContact != null && health.vetContact!.isNotEmpty) {
    lines.add('Vet: ${health.vetContact}');
  }
  return lines;
}
