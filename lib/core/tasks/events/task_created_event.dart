import 'package:uuid/uuid.dart';
import '../../events/app_event.dart';
import '../../events/event_category.dart';
import '../../events/event_persistence_policy.dart';
import '../task_item.dart';

class TaskCreatedEvent extends AppEvent {
  final TaskItem task;

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

  TaskCreatedEvent({
    required this.task,
    this.originModule = 'tasks',
    this.causationId,
    this.correlationId,
  })  : eventId = const Uuid().v4(),
        timestamp = DateTime.now();

  @override
  String get eventType => 'task_created';

  @override
  EventCategory get category => EventCategory.task;

  @override
  EventPersistencePolicy get persistencePolicy => EventPersistencePolicy.persistent;

  @override
  bool get replayable => true;
}