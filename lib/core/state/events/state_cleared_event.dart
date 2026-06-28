import 'package:uuid/uuid.dart';
import '../../events/app_event.dart';
import '../../events/event_category.dart';
import '../../events/event_persistence_policy.dart';

class StateClearedEvent extends AppEvent {
  final String stateName;

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

  StateClearedEvent({
    required this.stateName,
    this.originModule = 'state_engine',
    this.causationId,
    this.correlationId,
  })  : eventId = const Uuid().v4(),
        timestamp = DateTime.now();

  @override
  String get eventType => 'state_cleared';

  @override
  EventCategory get category => EventCategory.system;

  @override
  EventPersistencePolicy get persistencePolicy => EventPersistencePolicy.persistent;

  @override
  bool get replayable => true;
}