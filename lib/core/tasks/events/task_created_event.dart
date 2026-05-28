import '../../events/app_event.dart';
import '../task_item.dart';

class TaskCreatedEvent extends AppEvent {
  final TaskItem task;

  const TaskCreatedEvent({
    required this.task,
    required super.timestamp,
  });
}