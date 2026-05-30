import 'event_category.dart';
import 'event_persistence_policy.dart';

abstract class AppEvent {
  String get eventId;
  String get eventType;
  EventCategory get category;
  EventPersistencePolicy get persistencePolicy;
  bool get replayable;
  String get originModule;
  DateTime get timestamp;
  String? get causationId;
  String? get correlationId;
}