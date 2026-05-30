import 'package:flutter_test/flutter_test.dart';
import 'package:beth_app/core/events/event_validator.dart';
import 'package:beth_app/core/events/event_category.dart';
import 'package:beth_app/core/events/event_persistence_policy.dart';

void main() {
  group('EventValidator', () {
    test('valid event passes validation', () {
      final result = EventValidator.validate(
        'evt-123',
        'task_created',
        EventCategory.task,
        EventPersistencePolicy.persistent,
        true,
        'tasks',
      );

      expect(result.isValid, true);
      expect(result.errors, isEmpty);
    });

    test('missing eventId fails validation', () {
      final result = EventValidator.validate(
        '',
        'task_created',
        EventCategory.task,
        EventPersistencePolicy.persistent,
        true,
        'tasks',
      );

      expect(result.isValid, false);
      expect(result.errors.any((e) => e.contains('eventId')), true);
    });

    test('missing eventType fails validation', () {
      final result = EventValidator.validate(
        'evt-123',
        '',
        EventCategory.task,
        EventPersistencePolicy.persistent,
        true,
        'tasks',
      );

      expect(result.isValid, false);
      expect(result.errors.any((e) => e.contains('eventType')), true);
    });

    test('missing originModule fails validation', () {
      final result = EventValidator.validate(
        'evt-123',
        'task_created',
        EventCategory.task,
        EventPersistencePolicy.persistent,
        true,
        '',
      );

      expect(result.isValid, false);
      expect(result.errors.any((e) => e.contains('originModule')), true);
    });

    test('all invalid fields reported together', () {
      final result = EventValidator.validate(
        '',
        '',
        EventCategory.task,
        EventPersistencePolicy.persistent,
        true,
        '',
      );

      expect(result.isValid, false);
      expect(result.errors.length, 3);
    });
  });
}