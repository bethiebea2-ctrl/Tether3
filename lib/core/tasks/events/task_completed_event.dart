import '../../events/app_event.dart';

class TaskCompletedEvent extends AppEvent {
  final String taskId;

  const TaskCompletedEvent({
    required this.taskId,
    required super.timestamp,
  });
}