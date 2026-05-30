import 'package:uuid/uuid.dart';
import '../../events/app_event.dart';
import '../../events/event_category.dart';
import '../../events/event_persistence_policy.dart';

class TaskSuggestedFromCaptureEvent extends AppEvent {
  final String captureId;
  final String suggestedTitle;
  final String? suggestedCategory;

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

  TaskSuggestedFromCaptureEvent({
    required this.captureId,
    required this.suggestedTitle,
    this.suggestedCategory,
    this.originModule = 'capture',
    this.causationId,
    this.correlationId,
  })  : eventId = const Uuid().v4(),
        timestamp = DateTime.now();

  @override
  String get eventType => 'task_suggested_from_capture';

  @override
  EventCategory get category => EventCategory.task;

  @override
  EventPersistencePolicy get persistencePolicy => EventPersistencePolicy.persistent;

  @override
  bool get replayable => true;
}