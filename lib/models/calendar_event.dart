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
  final bool isAllDay;
  final String timezone;
  final String? categoryId;
  final String? personId;
  final String? location;
  final String? emoji;
  /// `urgent` | `important` | `routine` (legacy: `normal` → important)
  final String priority;
  /// `none` | `daily` | `weekly` | `biweekly` | `monthly` | `custom`
  final String? recurrenceRule;
  /// `manual` | `capture` | `pipeline` | `family_hub` | …
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
    this.isAllDay = false,
    this.timezone = 'Australia/Brisbane',
    this.categoryId,
    this.personId,
    this.location,
    this.emoji,
    this.priority = 'important',
    this.recurrenceRule,
    this.source = 'manual',
    this.createdByInstance,
    this.privacyScope = 'private',
    this.sensitivityLevel = 'd2',
    this.eventType = '',
    required this.createdAt,
    required this.updatedAt,
  });

  /// @deprecated Use startTime instead
  DateTime get date => startTime;

  /// @deprecated Use recurrenceRule instead
  String? get recurrence => recurrenceRule;

  /// @deprecated Use description instead
  String? get notes => description;

  bool get isPipeline =>
      source == 'capture' || source == 'pipeline' || source == 'backend';

  bool get isManual => source == 'manual';

  bool get isRecurring =>
      recurrenceRule != null &&
      recurrenceRule!.isNotEmpty &&
      recurrenceRule != 'none';

  String get normalisedPriority {
    switch (priority) {
      case 'urgent':
        return 'urgent';
      case 'routine':
      case 'low':
        return 'routine';
      case 'important':
      case 'normal':
      case 'medium':
      default:
        return 'important';
    }
  }

  String get priorityLabel {
    switch (normalisedPriority) {
      case 'urgent':
        return '⚠ Urgent';
      case 'routine':
        return 'Routine';
      default:
        return '📋 Important';
    }
  }

  String sourceLabel({DateTime? now}) {
    final n = now ?? DateTime.now();
    if (isPipeline) {
      return 'Pipeline · ${_relativeStamp(createdAt, n)}';
    }
    if (source == 'family_hub') {
      return 'Family Hub · Added ${_shortDate(createdAt)}';
    }
    return 'Manual · Added ${_shortDate(createdAt)}';
  }

  String? get recurrenceLabel {
    if (!isRecurring) return null;
    switch (recurrenceRule) {
      case 'daily':
        return 'Recurring · Daily';
      case 'weekly':
        return 'Recurring · Weekly';
      case 'biweekly':
        return 'Recurring · Biweekly';
      case 'monthly':
        return 'Recurring · Monthly';
      case 'yearly':
        return 'Recurring · Yearly';
      case 'weekdays':
        return 'Recurring · Weekdays';
      default:
        return 'Recurring · Custom';
    }
  }

  static String _shortDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${d.day}${_ordinal(d.day)} ${months[d.month - 1]}';
  }

  static String _ordinal(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  static String _relativeStamp(DateTime t, DateTime now) {
    final sameDay =
        t.year == now.year && t.month == now.month && t.day == now.day;
    final yesterday = now.subtract(const Duration(days: 1));
    final isYesterday = t.year == yesterday.year &&
        t.month == yesterday.month &&
        t.day == yesterday.day;
    final h = t.hour > 12 ? t.hour - 12 : (t.hour == 0 ? 12 : t.hour);
    final m = t.minute.toString().padLeft(2, '0');
    final ampm = t.hour >= 12 ? 'pm' : 'am';
    final clock = '$h:$m$ampm';
    if (sameDay) return '$clock today';
    if (isYesterday) return '$clock yesterday';
    return _shortDate(t);
  }

  CalendarEvent copyWith({
    String? id,
    String? householdId,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    bool? isAllDay,
    String? timezone,
    String? categoryId,
    String? personId,
    String? location,
    String? emoji,
    String? priority,
    String? recurrenceRule,
    String? source,
    String? createdByInstance,
    String? privacyScope,
    String? sensitivityLevel,
    String? eventType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CalendarEvent(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isAllDay: isAllDay ?? this.isAllDay,
      timezone: timezone ?? this.timezone,
      categoryId: categoryId ?? this.categoryId,
      personId: personId ?? this.personId,
      location: location ?? this.location,
      emoji: emoji ?? this.emoji,
      priority: priority ?? this.priority,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      source: source ?? this.source,
      createdByInstance: createdByInstance ?? this.createdByInstance,
      privacyScope: privacyScope ?? this.privacyScope,
      sensitivityLevel: sensitivityLevel ?? this.sensitivityLevel,
      eventType: eventType ?? this.eventType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'date': startTime.toIso8601String(),
        'start_time': startTime.toIso8601String(),
        'end_time': endTime?.toIso8601String(),
        'is_all_day': isAllDay ? 1 : 0,
        'recurrence': recurrenceRule,
        'category_id': categoryId,
        'emoji': emoji,
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

  factory CalendarEvent.fromMap(Map<String, dynamic> map) {
    final start = map['start_time'] != null
        ? DateTime.parse(map['start_time'] as String)
        : map['date'] != null
            ? DateTime.parse(map['date'] as String)
            : DateTime.now();
    final allDayRaw = map['is_all_day'];
    final isAllDay = allDayRaw == 1 || allDayRaw == true || allDayRaw == '1';
    return CalendarEvent(
      id: map['id'] as String,
      householdId: map['household_id'] as String? ?? 'default',
      title: map['title'] as String? ?? '',
      description: (map['description'] ?? map['notes']) as String?,
      startTime: start,
      endTime: map['end_time'] != null
          ? DateTime.parse(map['end_time'] as String)
          : null,
      isAllDay: isAllDay,
      timezone: map['timezone'] as String? ?? 'Australia/Brisbane',
      categoryId: map['category_id'] as String?,
      personId: map['person_id'] as String?,
      location: map['location'] as String?,
      emoji: map['emoji'] as String?,
      priority: map['priority'] as String? ?? 'important',
      recurrenceRule:
          (map['recurrence_rule'] ?? map['recurrence']) as String?,
      source: map['source'] as String? ?? 'manual',
      createdByInstance: map['created_by_instance'] as String?,
      privacyScope: map['privacy_scope'] as String? ?? 'private',
      sensitivityLevel: map['sensitivity_level'] as String? ?? 'd2',
      eventType: map['event_type'] as String? ?? '',
      createdAt: DateTime.parse(
        map['created_at'] as String? ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        map['updated_at'] as String? ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      id: json['id']?.toString() ?? '',
      householdId: json['household_id'] as String? ?? 'default',
      title: json['title'] as String? ?? '',
      startTime: json['start_time'] != null
          ? DateTime.parse(json['start_time'] as String)
          : DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      endTime: json['end_time'] != null
          ? DateTime.parse(json['end_time'] as String)
          : null,
      isAllDay: json['is_all_day'] == true || json['is_all_day'] == 1,
      categoryId: json['category_id'] as String?,
      emoji: json['emoji'] as String?,
      priority: json['priority'] as String? ?? 'important',
      recurrenceRule: json['recurrence'] as String?,
      source: json['source'] as String? ?? 'pipeline',
      description: json['notes'] as String? ?? json['description'] as String?,
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
