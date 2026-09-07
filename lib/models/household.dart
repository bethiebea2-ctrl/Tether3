class Household {
  final String id;
  final String name;
  final String inviteCode;
  final String ownerUserId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Household({
    required this.id,
    required this.name,
    required this.inviteCode,
    required this.ownerUserId,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'invite_code': inviteCode,
        'owner_user_id': ownerUserId,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  factory Household.fromMap(Map<String, dynamic> map) => Household(
        id: map['id']?.toString() ?? '',
        name: map['name']?.toString() ?? 'Household',
        inviteCode: map['invite_code']?.toString() ?? '',
        ownerUserId: map['owner_user_id']?.toString() ?? '',
        createdAt: DateTime.tryParse(map['created_at']?.toString() ?? '') ?? DateTime.now(),
        updatedAt: DateTime.tryParse(map['updated_at']?.toString() ?? '') ?? DateTime.now(),
      );
}

class HouseholdMember {
  final String id;
  final String householdId;
  final String userId;
  final String role;
  final String? personId;
  final DateTime joinedAt;

  const HouseholdMember({
    required this.id,
    required this.householdId,
    required this.userId,
    required this.role,
    this.personId,
    required this.joinedAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'household_id': householdId,
        'user_id': userId,
        'role': role,
        'person_id': personId,
        'joined_at': joinedAt.toIso8601String(),
      };

  factory HouseholdMember.fromMap(Map<String, dynamic> map) => HouseholdMember(
        id: map['id']?.toString() ?? '',
        householdId: map['household_id']?.toString() ?? '',
        userId: map['user_id']?.toString() ?? '',
        role: map['role']?.toString() ?? 'viewer',
        personId: map['person_id'] as String?,
        joinedAt: DateTime.tryParse(map['joined_at']?.toString() ?? '') ?? DateTime.now(),
      );
}

const householdRoles = <(String, String)>[
  ('owner', 'Owner'),
  ('partner', 'Partner / adult'),
  ('teen', 'Teen'),
  ('child_profile', 'Child profile'),
  ('carer', 'Carer'),
  ('viewer', 'Viewer'),
];

String householdRoleLabel(String role) {
  for (final o in householdRoles) {
    if (o.$1 == role) return o.$2;
  }
  return role.replaceAll('_', ' ');
}
