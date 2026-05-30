import 'event_category.dart';
import 'event_persistence_policy.dart';

class EventValidationResult {
  final bool isValid;
  final List<String> errors;

  const EventValidationResult({required this.isValid, required this.errors});
}

class EventValidator {
  EventValidator._();

  static EventValidationResult validate(
    String eventId,
    String eventType,
    EventCategory category,
    EventPersistencePolicy persistencePolicy,
    bool replayable,
    String originModule,
  ) {
    final errors = <String>[];

    if (eventId.isEmpty) {
      errors.add('eventId must not be empty');
    }
    if (eventType.isEmpty) {
      errors.add('eventType must not be empty');
    }
    if (originModule.isEmpty) {
      errors.add('originModule must not be empty');
    }

    return EventValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }
}