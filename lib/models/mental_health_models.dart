/// Models for Mental Health Toolkit (crisis plan, worry logs, trusted contacts).
class CrisisPlan {
  final String id;
  final String warningSigns;
  final String copingStrategies;
  final String peopleToContact;
  final String professionalHelp;
  final String makeEnvironmentSafe;
  final String reasonsToStay;
  final DateTime updatedAt;

  const CrisisPlan({
    required this.id,
    this.warningSigns = '',
    this.copingStrategies = '',
    this.peopleToContact = '',
    this.professionalHelp = '',
    this.makeEnvironmentSafe = '',
    this.reasonsToStay = '',
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'warning_signs': warningSigns,
        'coping_strategies': copingStrategies,
        'people_to_contact': peopleToContact,
        'professional_help': professionalHelp,
        'make_environment_safe': makeEnvironmentSafe,
        'reasons_to_stay': reasonsToStay,
      };

  factory CrisisPlan.fromJson(
    String id,
    Map<String, dynamic> json,
    DateTime updatedAt,
  ) =>
      CrisisPlan(
        id: id,
        warningSigns: json['warning_signs'] as String? ?? '',
        copingStrategies: json['coping_strategies'] as String? ?? '',
        peopleToContact: json['people_to_contact'] as String? ?? '',
        professionalHelp: json['professional_help'] as String? ?? '',
        makeEnvironmentSafe: json['make_environment_safe'] as String? ?? '',
        reasonsToStay: json['reasons_to_stay'] as String? ?? '',
        updatedAt: updatedAt,
      );

  CrisisPlan copyWith({
    String? warningSigns,
    String? copingStrategies,
    String? peopleToContact,
    String? professionalHelp,
    String? makeEnvironmentSafe,
    String? reasonsToStay,
    DateTime? updatedAt,
  }) =>
      CrisisPlan(
        id: id,
        warningSigns: warningSigns ?? this.warningSigns,
        copingStrategies: copingStrategies ?? this.copingStrategies,
        peopleToContact: peopleToContact ?? this.peopleToContact,
        professionalHelp: professionalHelp ?? this.professionalHelp,
        makeEnvironmentSafe: makeEnvironmentSafe ?? this.makeEnvironmentSafe,
        reasonsToStay: reasonsToStay ?? this.reasonsToStay,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}

class WorryLog {
  final String id;
  final String content;
  final DateTime createdAt;

  const WorryLog({
    required this.id,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'content': content,
        'created_at': createdAt.toIso8601String(),
      };

  factory WorryLog.fromMap(Map<String, dynamic> map) => WorryLog(
        id: map['id'] as String,
        content: map['content'] as String,
        createdAt: DateTime.parse(map['created_at'] as String),
      );
}

class TrustedContact {
  final String id;
  final String name;
  final String? phone;
  final String? notes;

  const TrustedContact({
    required this.id,
    required this.name,
    this.phone,
    this.notes,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'phone': phone,
        'notes': notes,
      };

  factory TrustedContact.fromMap(Map<String, dynamic> map) => TrustedContact(
        id: map['id'] as String,
        name: map['name'] as String,
        phone: map['phone'] as String?,
        notes: map['notes'] as String?,
      );
}
