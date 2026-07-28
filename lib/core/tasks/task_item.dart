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
  final String? sourceCaptureId;
  final String? layer; // bare_minimum, personal, house, etc.

  const TaskItem({
    required this.id,
    required this.title,
    required this.status,
    required this.priority,
    required this.energy,
    required this.createdAt,
    this.snoozedUntil,
    this.sourceCaptureId,
    this.layer,
  });

  TaskItem copyWith({
    String? id,
    String? title,
    TaskStatus? status,
    TaskPriority? priority,
    TaskEnergy? energy,
    DateTime? createdAt,
    DateTime? snoozedUntil,
    String? sourceCaptureId,
    String? layer,
  }) {
    return TaskItem(
      id: id ?? this.id,
      title: title ?? this.title,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      energy: energy ?? this.energy,
      createdAt: createdAt ?? this.createdAt,
      snoozedUntil: snoozedUntil ?? this.snoozedUntil,
      sourceCaptureId: sourceCaptureId ?? this.sourceCaptureId,
      layer: layer ?? this.layer,
    );
  }
}