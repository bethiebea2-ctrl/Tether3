import 'task_status.dart';
import 'task_priority.dart';
import 'task_energy.dart';

class TaskItem {
  final String id;
  final String title;
  final TaskStatus status;
  final TaskPriority priority;
  final TaskEnergy energy;
  final DateTime createdAt;
  final DateTime? snoozedUntil;
  final DateTime? deadline;
  final String? sourceCaptureId;
  final String? layer; // bare_minimum, personal_care, house, care, life_admin, recovery
  final String? assignedInstanceId;
  final String? notes;
  final DateTime updatedAt;

  const TaskItem({
    required this.id,
    required this.title,
    required this.status,
    required this.priority,
    required this.energy,
    required this.createdAt,
    this.snoozedUntil,
    this.deadline,
    this.sourceCaptureId,
    this.layer,
    this.assignedInstanceId,
    this.notes,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? createdAt;

  bool get isOverdue =>
      deadline != null &&
      deadline!.isBefore(DateTime.now()) &&
      status == TaskStatus.pending;

  TaskItem copyWith({
    String? id,
    String? title,
    TaskStatus? status,
    TaskPriority? priority,
    TaskEnergy? energy,
    DateTime? createdAt,
    DateTime? snoozedUntil,
    DateTime? deadline,
    String? sourceCaptureId,
    String? layer,
    String? assignedInstanceId,
    String? notes,
    DateTime? updatedAt,
    bool clearDeadline = false,
    bool clearSnooze = false,
  }) {
    return TaskItem(
      id: id ?? this.id,
      title: title ?? this.title,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      energy: energy ?? this.energy,
      createdAt: createdAt ?? this.createdAt,
      snoozedUntil: clearSnooze ? null : (snoozedUntil ?? this.snoozedUntil),
      deadline: clearDeadline ? null : (deadline ?? this.deadline),
      sourceCaptureId: sourceCaptureId ?? this.sourceCaptureId,
      layer: layer ?? this.layer,
      assignedInstanceId: assignedInstanceId ?? this.assignedInstanceId,
      notes: notes ?? this.notes,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'priority': priority.name,
        'deadline': deadline?.toIso8601String(),
        'category_id': layer,
        'notes': notes,
        'assigned_instance_id': assignedInstanceId,
        'status': status == TaskStatus.pending
            ? 'active'
            : status.name,
        'completed_at': status == TaskStatus.completed
            ? updatedAt.toIso8601String()
            : null,
        'snoozed_until': snoozedUntil?.toIso8601String(),
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'energy_level': energy.name,
        'layer': layer,
        'source_capture_id': sourceCaptureId,
      };

  factory TaskItem.fromMap(Map<String, dynamic> map) {
    final statusRaw = map['status'] as String? ?? 'active';
    final status = switch (statusRaw) {
      'completed' => TaskStatus.completed,
      'snoozed' => TaskStatus.snoozed,
      _ => TaskStatus.pending,
    };
    final priorityRaw = map['priority'] as String? ?? 'medium';
    final priority = TaskPriority.values.firstWhere(
      (p) => p.name == priorityRaw || (priorityRaw == 'urgent' && p == TaskPriority.high),
      orElse: () => TaskPriority.medium,
    );
    final energyRaw = map['energy_level'] as String? ?? 'medium';
    final energy = TaskEnergy.values.firstWhere(
      (e) => e.name == energyRaw,
      orElse: () => TaskEnergy.medium,
    );
    return TaskItem(
      id: map['id'] as String,
      title: map['title'] as String,
      status: status,
      priority: priority,
      energy: energy,
      createdAt: DateTime.parse(map['created_at'] as String),
      snoozedUntil: map['snoozed_until'] != null
          ? DateTime.tryParse(map['snoozed_until'] as String)
          : null,
      deadline: map['deadline'] != null
          ? DateTime.tryParse(map['deadline'] as String)
          : null,
      sourceCaptureId: map['source_capture_id'] as String?,
      layer: map['layer'] as String? ?? map['category_id'] as String?,
      assignedInstanceId: map['assigned_instance_id'] as String?,
      notes: map['notes'] as String?,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : DateTime.parse(map['created_at'] as String),
    );
  }
}
