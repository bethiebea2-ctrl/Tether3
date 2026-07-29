/// A person in the Tether system.
class Person {
  final String id;
  final String displayName;
  final String? legalName;
  final String? preferredName;
  final String? pronouns;
  final String? genderIdentity;
  final String relationshipToUser;
  final DateTime? dateOfBirth;
  final String ageStage;
  final String profileType;
  final String? colourIcon;
  final String? calendarCategoryId;
  final String? calendarBirthdayEventId;
  final String privacyLevel;
  final String? notes;
  final bool livesWithMe;
  /// lives_with_me | shared_custody | visitation | lives_elsewhere | international
  final String livingArrangement;
  /// Free text: e.g. "UK with mum", "Dad's house Mon–Wed"
  final String? residenceLocation;
  final String featureTogglesJson;
  final String? species;
  final String? breed;
  final String teenPrivacyJson;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Person({
    required this.id,
    required this.displayName,
    this.legalName,
    this.preferredName,
    this.pronouns,
    this.genderIdentity,
    required this.relationshipToUser,
    this.dateOfBirth,
    this.ageStage = 'adult',
    this.profileType = 'household_member',
    this.colourIcon,
    this.calendarCategoryId,
    this.calendarBirthdayEventId,
    this.privacyLevel = 'standard',
    this.notes,
    this.livesWithMe = true,
    this.livingArrangement = 'lives_with_me',
    this.residenceLocation,
    this.featureTogglesJson = '{}',
    this.species,
    this.breed,
    this.teenPrivacyJson = '{}',
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isPet => profileType == 'pet' || ageStage == 'pet';
  bool get isTeen => ageStage == 'teen';

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
        'legal_name': legalName,
        'preferred_name': preferredName,
        'pronouns': pronouns,
        'gender_identity': genderIdentity,
        'relationship_to_user': relationshipToUser,
        'date_of_birth': dateOfBirth?.toIso8601String(),
        'age_stage': ageStage,
        'profile_type': profileType,
        'colour_icon': colourIcon,
        'calendar_category_id': calendarCategoryId,
        'calendar_birthday_event_id': calendarBirthdayEventId,
        'privacy_level': privacyLevel,
        'notes': notes,
        'lives_with_me': livesWithMe ? 1 : 0,
        'living_arrangement': livingArrangement,
        'residence_location': residenceLocation,
        'feature_toggles': featureTogglesJson,
        'species': species,
        'breed': breed,
        'teen_privacy_json': teenPrivacyJson,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  factory Person.fromMap(Map<String, dynamic> map) {
    final arrangement = map['living_arrangement'] as String?;
    final livesWith = _boolFrom(map['lives_with_me']);
    return Person(
      id: map['id']?.toString() ?? '',
      displayName: map['display_name']?.toString() ?? 'Unknown',
      legalName: map['legal_name'] as String?,
      preferredName: map['preferred_name'] as String?,
      pronouns: map['pronouns'] as String?,
      genderIdentity: map['gender_identity'] as String?,
      relationshipToUser: map['relationship_to_user']?.toString() ?? 'other',
      dateOfBirth: map['date_of_birth'] != null
          ? DateTime.tryParse(map['date_of_birth'].toString())
          : null,
      ageStage: map['age_stage'] as String? ?? 'adult',
      profileType: map['profile_type'] as String? ?? 'household_member',
      colourIcon: map['colour_icon'] as String?,
      calendarCategoryId: map['calendar_category_id'] as String?,
      calendarBirthdayEventId: map['calendar_birthday_event_id'] as String?,
      privacyLevel: map['privacy_level'] as String? ?? 'standard',
      notes: map['notes'] as String?,
      livesWithMe: livesWith,
      livingArrangement: arrangement ??
          (livesWith ? 'lives_with_me' : 'lives_elsewhere'),
      residenceLocation: map['residence_location'] as String?,
      featureTogglesJson: map['feature_toggles']?.toString() ?? '{}',
      species: map['species'] as String?,
      breed: map['breed'] as String?,
      teenPrivacyJson: map['teen_privacy_json']?.toString() ?? '{}',
      createdAt: _parseDateTime(map['created_at']),
      updatedAt: _parseDateTime(map['updated_at']),
    );
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    return DateTime.tryParse(value.toString()) ?? DateTime.now();
  }

  static bool _boolFrom(dynamic v) {
    if (v is bool) return v;
    if (v is int) return v == 1;
    return true;
  }

  Person copyWith({
    String? displayName,
    String? legalName,
    String? preferredName,
    String? pronouns,
    String? genderIdentity,
    String? relationshipToUser,
    DateTime? dateOfBirth,
    String? ageStage,
    String? profileType,
    String? colourIcon,
    String? calendarCategoryId,
    String? calendarBirthdayEventId,
    String? privacyLevel,
    String? notes,
    bool? livesWithMe,
    String? livingArrangement,
    String? residenceLocation,
    String? featureTogglesJson,
    String? species,
    String? breed,
    String? teenPrivacyJson,
    DateTime? updatedAt,
    bool clearResidenceLocation = false,
  }) {
    final arrangement = livingArrangement ?? this.livingArrangement;
    return Person(
      id: id,
      displayName: displayName ?? this.displayName,
      legalName: legalName ?? this.legalName,
      preferredName: preferredName ?? this.preferredName,
      pronouns: pronouns ?? this.pronouns,
      genderIdentity: genderIdentity ?? this.genderIdentity,
      relationshipToUser: relationshipToUser ?? this.relationshipToUser,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      ageStage: ageStage ?? this.ageStage,
      profileType: profileType ?? this.profileType,
      colourIcon: colourIcon ?? this.colourIcon,
      calendarCategoryId: calendarCategoryId ?? this.calendarCategoryId,
      calendarBirthdayEventId:
          calendarBirthdayEventId ?? this.calendarBirthdayEventId,
      privacyLevel: privacyLevel ?? this.privacyLevel,
      notes: notes ?? this.notes,
      livesWithMe: livesWithMe ??
          (arrangement == 'lives_with_me' || arrangement == 'shared_custody'),
      livingArrangement: arrangement,
      residenceLocation: clearResidenceLocation
          ? null
          : (residenceLocation ?? this.residenceLocation),
      featureTogglesJson: featureTogglesJson ?? this.featureTogglesJson,
      species: species ?? this.species,
      breed: breed ?? this.breed,
      teenPrivacyJson: teenPrivacyJson ?? this.teenPrivacyJson,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
