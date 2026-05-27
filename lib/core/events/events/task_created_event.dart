import '../app_event.dart';

/// Emitted when a new task is created.
class TaskCreatedEvent extends AppEvent {
  /// The ID of the task that was created
  final String taskId;

  /// The ID of the user who created it
  final String createdByUserId;

  const TaskCreatedEvent({
    required this.taskId,
    required this.createdByUserId,
    required super.timestamp,
  });
}