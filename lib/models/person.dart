/// A person in the Tether system.
///
/// Not every person has a user account. Children, partners without the app,
/// pets, and carers are all person_profiles. A person becomes a user when
/// they connect their own account.
class Person {
  final String id;
  final String displayName;
  final String relationshipToUser; // self, partner, child, pet, carer, family
  final DateTime? dateOfBirth;
  final String ageStage; // baby, toddler, child, teen, adult, pet
  final String profileType; // user, partner, child, pet, carer
  final String? colourIcon; // emoji or colour for calendar/UI
  final String privacyLevel; // standard, elevated, maximum
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Person({
    required this.id,
    required this.displayName,
    required this.relationshipToUser,
    this.dateOfBirth,
    this.ageStage = 'adult',
    this.profileType = 'user',
    this.colourIcon,
    this.privacyLevel = 'standard',
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  int get age {
    if (dateOfBirth == null) return 0;
    final now = DateTime.now();
    int age = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      age--;
    }
    return age;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'display_name': displayName,
        'relationship_to_user': relationshipToUser,
        'date_of_birth': dateOfBirth?.toIso8601String(),
        'age_stage': ageStage,
        'profile_type': profileType,
        'colour_icon': colourIcon,
        'privacy_level': privacyLevel,
        'notes': notes,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  factory Person.fromMap(Map<String, dynamic> map) => Person(
        id: map['id'],
        displayName: map['display_name'],
        relationshipToUser: map['relationship_to_user'],
        dateOfBirth: map['date_of_birth'] != null
            ? DateTime.parse(map['date_of_birth'])
            : null,
        ageStage: map['age_stage'] ?? 'adult',
        profileType: map['profile_type'] ?? 'user',
        colourIcon: map['colour_icon'],
        privacyLevel: map['privacy_level'] ?? 'standard',
        notes: map['notes'],
        createdAt: DateTime.parse(map['created_at']),
        updatedAt: DateTime.parse(map['updated_at']),
      );
}