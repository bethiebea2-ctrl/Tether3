import '../../events/app_event.dart';

class TaskSnoozedEvent extends AppEvent {
  final String taskId;
  final DateTime snoozedUntil;

  const TaskSnoozedEvent({
    required this.taskId,
    required this.snoozedUntil,
    required super.timestamp,
  });
}