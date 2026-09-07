class AuthUser {
  final String id;
  final String email;
  final String displayName;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AuthUser({
    required this.id,
    required this.email,
    required this.displayName,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'email': email.trim().toLowerCase(),
        'display_name': displayName,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  factory AuthUser.fromMap(Map<String, dynamic> map) => AuthUser(
        id: map['id']?.toString() ?? '',
        email: map['email']?.toString() ?? '',
        displayName: map['display_name']?.toString() ?? 'User',
        createdAt: DateTime.tryParse(map['created_at']?.toString() ?? '') ?? DateTime.now(),
        updatedAt: DateTime.tryParse(map['updated_at']?.toString() ?? '') ?? DateTime.now(),
      );

  AuthUser copyWith({
    String? displayName,
    DateTime? updatedAt,
  }) =>
      AuthUser(
        id: id,
        email: email,
        displayName: displayName ?? this.displayName,
        createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}
