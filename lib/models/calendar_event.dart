/// A calendar event in the Tether system.
///
/// Events belong to a household and can be created manually, from captures,
/// or suggested by AI. Every event tracks its source for auditability.
///
/// Events support categories (person-scoped or general), recurrence,
/// priority badges, and attendee tracking.
class CalendarEvent {
  final String id;
  final String householdId;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime? endTime;
  final String timezone;
  final String? categoryId;
  final String? personId;
  final String? location;
  final String priority;
  final String? recurrenceRule;
  final String source;
  final String? createdByInstance;
  final String privacyScope;
  final String sensitivityLevel;
  final String eventType;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CalendarEvent({
    required this.id,
    required this.householdId,
    required this.title,
    this.description,
    required this.startTime,
    this.endTime,
    this.timezone = 'Australia/Brisbane',
    this.categoryId,
    this.personId,
    this.location,
    this.priority = 'normal',
    this.recurrenceRule,
    this.source = 'manual',
    this.createdByInstance,
    this.privacyScope = 'private',
    this.sensitivityLevel = 'd2',
    this.eventType = '',
    required this.createdAt,
    required this.updatedAt,
  });

  // ============================================
  // COMPATIBILITY GETTERS — for code still using old field names
  // ============================================

  /// @deprecated Use startTime instead
  DateTime get date => startTime;

  /// @deprecated Use endTime == null check instead
  bool get isAllDay => endTime == null;

  /// @deprecated Use recurrenceRule instead
  String? get recurrence => recurrenceRule;

  /// @deprecated Emoji not yet implemented in unified model
  String? get emoji => null;

  /// @deprecated Use description instead
  String? get notes => description;

  // ============================================
  // SERIALISATION
  // ============================================

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'date': startTime.toIso8601String(),
        'start_time': startTime.toIso8601String(),
        'end_time': endTime?.toIso8601String(),
        'is_all_day': endTime == null ? 1 : 0,
        'recurrence': recurrenceRule,
        'category_id': categoryId,
        'emoji': null,
        'location': location,
        'notes': description,
        'household_id': householdId,
        'description': description,
        'timezone': timezone,
        'person_id': personId,
        'priority': priority,
        'recurrence_rule': recurrenceRule,
        'source': source,
        'event_type': eventType,
        'created_by_instance': createdByInstance,
        'privacy_scope': privacyScope,
        'sensitivity_level': sensitivityLevel,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  factory CalendarEvent.fromMap(Map<String, dynamic> map) => CalendarEvent(
        id: map['id'],
        householdId: map['household_id'] ?? 'default',
        title: map['title'] ?? '',
        description: map['description'],
        startTime: map['start_time'] != null
            ? DateTime.parse(map['start_time'])
            : map['date'] != null
                ? DateTime.parse(map['date'])
                : DateTime.now(),
        endTime: map['end_time'] != null ? DateTime.parse(map['end_time']) : null,
        timezone: map['timezone'] ?? 'Australia/Brisbane',
        categoryId: map['category_id'],
        personId: map['person_id'],
        location: map['location'],
        priority: map['priority'] ?? 'normal',
        recurrenceRule: map['recurrence_rule'],
        source: map['source'] ?? 'manual',
        createdByInstance: map['created_by_instance'],
        privacyScope: map['privacy_scope'] ?? 'private',
        sensitivityLevel: map['sensitivity_level'] ?? 'd2',
        eventType: map['event_type'] as String? ?? '',
        createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
        updatedAt: DateTime.parse(map['updated_at'] ?? DateTime.now().toIso8601String()),
      );

  /// Factory for JSON deserialization (used by syncFromBackend)
  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      id: json['id']?.toString() ?? '',
      householdId: json['household_id'] ?? 'default',
      title: json['title'] ?? '',
      startTime: json['start_time'] != null
          ? DateTime.parse(json['start_time'])
          : DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      endTime: json['end_time'] != null ? DateTime.parse(json['end_time']) : null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}

/// Tracks where an event came from.
class EventSource {
  final String id;
  final String eventId;
  final String sourceType;
  final String? sourceCaptureId;
  final String? sourceInstanceId;
  final DateTime createdAt;

  const EventSource({
    required this.id,
    required this.eventId,
    required this.sourceType,
    this.sourceCaptureId,
    this.sourceInstanceId,
    required this.createdAt,
  });
}

/// A person attending an event.
class EventAttendee {
  final String id;
  final String eventId;
  final String personId;
  final String responseStatus;

  const EventAttendee({
    required this.id,
    required this.eventId,
    required this.personId,
    this.responseStatus = 'pending',
  });
}