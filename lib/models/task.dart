/// A task in the Tether system.
///
/// Tasks belong to a household, are owned by a user, and can be assigned
/// to a specific person. They support priority levels, energy tagging,
/// snooze, AI delegation, and full audit history.
///
/// Task categories follow the route map layers:
///   - bare_minimum: eat, drink, medication, baby fed, rest
///   - personal_care: shower, teeth, clothes, skincare
///   - house: dishes, washing, bins, floors, groceries
///   - care: baby, child, teen, partner, pet, parent, school, medication
///   - life_admin: bills, forms, calls, emails, appointments
///   - recovery: grounding, journaling, rest, step outside
class Task {
  final String id;
  final String householdId;
  final String ownerUserId;
  final String? assignedPersonId; // FK → person_profiles, nullable
  final String title;
  final String? description;
  final String category; // bare_minimum, personal_care, house, care, life_admin, recovery
  final String priority; // urgent, important, for_later
  final DateTime? deadline;
  final String energyLevel; // low, medium, high
  final String status; // pending, in_progress, completed, snoozed, deferred, cancelled
  final DateTime? snoozedUntil;
  final String? sourceCaptureId; // FK → capture_entries, nullable
  final String? createdByInstance; // which AI instance created it
  final String sensitivityLevel; // d1, d2
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? completedAt;

  const Task({
    required this.id,
    required this.householdId,
    required this.ownerUserId,
    this.assignedPersonId,
    required this.title,
    this.description,
    this.category = 'life_admin',
    this.priority = 'for_later',
    this.deadline,
    this.energyLevel = 'medium',
    this.status = 'pending',
    this.snoozedUntil,
    this.sourceCaptureId,
    this.createdByInstance,
    this.sensitivityLevel = 'd2',
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
  });

  bool get isOverdue =>
      deadline != null &&
      deadline!.isBefore(DateTime.now()) &&
      status == 'pending';

  Map<String, dynamic> toMap() => {
        'id': id,
        'household_id': householdId,
        'owner_user_id': ownerUserId,
        'assigned_person_id': assignedPersonId,
        'title': title,
        'description': description,
        'category': category,
        'priority': priority,
        'deadline': deadline?.toIso8601String(),
        'energy_level': energyLevel,
        'status': status,
        'snoozed_until': snoozedUntil?.toIso8601String(),
        'source_capture_id': sourceCaptureId,
        'created_by_instance': createdByInstance,
        'sensitivity_level': sensitivityLevel,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'completed_at': completedAt?.toIso8601String(),
      };

  factory Task.fromMap(Map<String, dynamic> map) => Task(
        id: map['id'],
        householdId: map['household_id'],
        ownerUserId: map['owner_user_id'],
        assignedPersonId: map['assigned_person_id'],
        title: map['title'],
        description: map['description'],
        category: map['category'] ?? 'life_admin',
        priority: map['priority'] ?? 'for_later',
        deadline: map['deadline'] != null ? DateTime.parse(map['deadline']) : null,
        energyLevel: map['energy_level'] ?? 'medium',
        status: map['status'] ?? 'pending',
        snoozedUntil: map['snoozed_until'] != null ? DateTime.parse(map['snoozed_until']) : null,
        sourceCaptureId: map['source_capture_id'],
        createdByInstance: map['created_by_instance'],
        sensitivityLevel: map['sensitivity_level'] ?? 'd2',
        createdAt: DateTime.parse(map['created_at']),
        updatedAt: DateTime.parse(map['updated_at']),
        completedAt: map['completed_at'] != null ? DateTime.parse(map['completed_at']) : null,
      );
}

/// A pre-built collection of tasks (editable, removable).
///
/// Task packs are how Support Presets deliver suggested tasks.
/// Users can also create their own packs.
class TaskPack {
  final String id;
  final String packKey; // adhd_support, depression_support, new_parent_survival, etc.
  final String displayName;
  final String description;
  final bool isSystem; // system packs vs user-created
  final String? createdByUserId;
  final List<TaskPackItem> items;

  const TaskPack({
    required this.id,
    required this.packKey,
    required this.displayName,
    required this.description,
    this.isSystem = true,
    this.createdByUserId,
    this.items = const [],
  });
}

/// A single task template within a task pack.
class TaskPackItem {
  final String id;
  final String title;
  final String category;
  final String priority;
  final String energyLevel;
  final int sortOrder;

  const TaskPackItem({
    required this.id,
    required this.title,
    this.category = 'life_admin',
    this.priority = 'for_later',
    this.energyLevel = 'medium',
    this.sortOrder = 0,
  });
}

/// Full audit trail for task changes.
class TaskHistory {
  final String id;
  final String taskId;
  final String action; // created, edited, snoozed, completed, deferred, deleted
  final String changedBy; // user_id or instance_id
  final Map<String, dynamic>? previousValue;
  final Map<String, dynamic>? newValue;
  final DateTime timestamp;

  const TaskHistory({
    required this.id,
    required this.taskId,
    required this.action,
    required this.changedBy,
    this.previousValue,
    this.newValue,
    required this.timestamp,
  });
}