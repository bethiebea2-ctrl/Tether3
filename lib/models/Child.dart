class Child {
  final String id;
  final String name;
  final DateTime dateOfBirth;
  final String ageGroup; // baby, child, teen
  final Map<String, bool> featureToggles; // e.g. {'feeding': true, 'medication': true}
  final bool teenAppInviteSent;
  final String? relationshipType; // e.g. 'partner_sync'
  final DateTime createdAt;

  Child({
    required this.id,
    required this.name,
    required this.dateOfBirth,
    required this.ageGroup,
    required this.featureToggles,
    this.teenAppInviteSent = false,
    this.relationshipType,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'date_of_birth': dateOfBirth.toIso8601String(),
    'age_group': ageGroup,
    'feature_toggles': featureToggles.toString(),
    'teen_app_invite_sent': teenAppInviteSent ? 1 : 0,
    'relationship_type': relationshipType,
    'created_at': createdAt.toIso8601String(),
  };

  factory Child.fromMap(Map<String, dynamic> map) => Child(
    id: map['id'],
    name: map['name'],
    dateOfBirth: DateTime.parse(map['date_of_birth']),
    ageGroup: map['age_group'],
    featureToggles: _parseFeatureToggles(map['feature_toggles']),
    teenAppInviteSent: map['teen_app_invite_sent'] == 1,
    relationshipType: map['relationship_type'],
    createdAt: DateTime.parse(map['created_at']),
  );

  static Map<String, bool> _parseFeatureToggles(String toggles) {
    // Simple parser for the string representation
    final map = <String, bool>{};
    final trimmed = toggles.replaceAll('{', '').replaceAll('}', '');
    if (trimmed.isEmpty) return map;
    for (final pair in trimmed.split(', ')) {
      final parts = pair.split(': ');
      if (parts.length == 2) {
        map[parts[0].trim()] = parts[1].trim() == 'true';
      }
    }
    return map;
  }

  int get age {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month || 
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }
}