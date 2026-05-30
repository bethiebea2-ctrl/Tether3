import 'package:uuid/uuid.dart';
import '../../events/app_event.dart';
import '../../events/event_category.dart';
import '../../events/event_persistence_policy.dart';

class TaskSnoozedEvent extends AppEvent {
  final String taskId;
  final DateTime snoozedUntil;

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

  TaskSnoozedEvent({
    required this.taskId,
    required this.snoozedUntil,
    this.originModule = 'tasks',
    this.causationId,
    this.correlationId,
  })  : eventId = const Uuid().v4(),
        timestamp = DateTime.now();

  @override
  String get eventType => 'task_snoozed';

  @override
  EventCategory get category => EventCategory.task;

  @override
  EventPersistencePolicy get persistencePolicy => EventPersistencePolicy.persistent;

  @override
  bool get replayable => true;
}