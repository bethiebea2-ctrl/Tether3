import 'package:uuid/uuid.dart';
import '../../events/app_event.dart';
import '../../events/event_category.dart';
import '../../events/event_persistence_policy.dart';

class TaskCompletedEvent extends AppEvent {
  final String taskId;

  @override
  final String eventId;

  @override
  final DateTime timestamp;

  @override
  final String originModule;

  @override
  final String? causationId;

  @override
  final String? correlationId;

  TaskCompletedEvent({
    required this.taskId,
    this.originModule = 'tasks',
    this.causationId,
    this.correlationId,
  })  : eventId = const Uuid().v4(),
        timestamp = DateTime.now();

  @override
  String get eventType => 'task_completed';

  @override
  EventCategory get category => EventCategory.task;

  @override
  EventPersistencePolicy get persistencePolicy => EventPersistencePolicy.persistent;

  @override
  bool get replayable => true;
}