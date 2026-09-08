import 'dart:convert';

class MealHouseholdPrefs {
  final int defaultServings;
  final String skillLevel;
  final List<String> cookingEquipment;
  final bool visualPrompts;
  final String householdNotes;

  const MealHouseholdPrefs({
    this.defaultServings = 4,
    this.skillLevel = 'comfortable',
    this.cookingEquipment = const [],
    this.visualPrompts = false,
    this.householdNotes = '',
  });

  Map<String, dynamic> toJson() => {
        'default_servings': defaultServings,
        'skill_level': skillLevel,
        'cooking_equipment': cookingEquipment,
        'visual_prompts': visualPrompts,
        'household_notes': householdNotes,
      };

  factory MealHouseholdPrefs.fromJson(Map<String, dynamic> json) =>
      MealHouseholdPrefs(
        defaultServings: json['default_servings'] as int? ?? 4,
        skillLevel: json['skill_level'] as String? ?? 'comfortable',
        cookingEquipment: (json['cooking_equipment'] as List?)
                ?.map((e) => e.toString())
                .toList() ??
            const [],
        visualPrompts: json['visual_prompts'] as bool? ?? false,
        householdNotes: json['household_notes'] as String? ?? '',
      );

  MealHouseholdPrefs copyWith({
    int? defaultServings,
    String? skillLevel,
    List<String>? cookingEquipment,
    bool? visualPrompts,
    String? householdNotes,
  }) =>
      MealHouseholdPrefs(
        defaultServings: defaultServings ?? this.defaultServings,
        skillLevel: skillLevel ?? this.skillLevel,
        cookingEquipment: cookingEquipment ?? this.cookingEquipment,
        visualPrompts: visualPrompts ?? this.visualPrompts,
        householdNotes: householdNotes ?? this.householdNotes,
      );
}

class PersonMealPrefs {
  final String personId;
  final String dietaryPattern;
  final List<String> allergies;
  final List<String> intolerances;
  final List<String> dislikes;
  final List<String> favorites;
  final String medicalNotes;

  const PersonMealPrefs({
    required this.personId,
    this.dietaryPattern = 'omnivore',
    this.allergies = const [],
    this.intolerances = const [],
    this.dislikes = const [],
    this.favorites = const [],
    this.medicalNotes = '',
  });

  Map<String, dynamic> toJson() => {
        'person_id': personId,
        'dietary_pattern': dietaryPattern,
        'allergies': allergies,
        'intolerances': intolerances,
        'dislikes': dislikes,
        'favorites': favorites,
        'medical_notes': medicalNotes,
      };

  factory PersonMealPrefs.fromJson(Map<String, dynamic> json) => PersonMealPrefs(
        personId: json['person_id']?.toString() ?? '',
        dietaryPattern: json['dietary_pattern'] as String? ?? 'omnivore',
        allergies: _stringList(json['allergies']),
        intolerances: _stringList(json['intolerances']),
        dislikes: _stringList(json['dislikes']),
        favorites: _stringList(json['favorites']),
        medicalNotes: json['medical_notes'] as String? ?? '',
      );

  PersonMealPrefs copyWith({
    String? dietaryPattern,
    List<String>? allergies,
    List<String>? intolerances,
    List<String>? dislikes,
    List<String>? favorites,
    String? medicalNotes,
  }) =>
      PersonMealPrefs(
        personId: personId,
        dietaryPattern: dietaryPattern ?? this.dietaryPattern,
        allergies: allergies ?? this.allergies,
        intolerances: intolerances ?? this.intolerances,
        dislikes: dislikes ?? this.dislikes,
        favorites: favorites ?? this.favorites,
        medicalNotes: medicalNotes ?? this.medicalNotes,
      );

  static List<String> _stringList(dynamic raw) {
    if (raw is! List) return const [];
    return raw.map((e) => e.toString()).where((s) => s.trim().isNotEmpty).toList();
  }

  static String encodeMap(Map<String, PersonMealPrefs> map) => jsonEncode(
        map.map((k, v) => MapEntry(k, v.toJson())),
      );

  static Map<String, PersonMealPrefs> decodeMap(String? raw) {
    if (raw == null || raw.isEmpty) return {};
    final decoded = jsonDecode(raw);
    if (decoded is! Map) return {};
    return decoded.map(
      (k, v) => MapEntry(
        k.toString(),
        PersonMealPrefs.fromJson(Map<String, dynamic>.from(v as Map)),
      ),
    );
  }
}
