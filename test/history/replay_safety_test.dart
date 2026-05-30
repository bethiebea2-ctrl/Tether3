import 'package:flutter_test/flutter_test.dart';
import 'package:beth_app/core/replay/replay_engine.dart';
import 'package:beth_app/core/history/orchestration_event_record.dart';
import 'package:beth_app/core/events/event_category.dart';
import 'package:beth_app/core/events/event_persistence_policy.dart';

void main() {
  group('Replay Safety', () {
    test('replay only processes OrchestrationEventRecord, not decisions', () {
      final engine = ReplayEngine();

      final events = [
        OrchestrationEventRecord(
          eventId: 'evt_1',
          eventType: 'task_created',
          category: EventCategory.task,
          persistencePolicy: EventPersistencePolicy.persistent,
          replayable: true,
          originModule: 'tasks',
          sessionId: 'session_1',
          timestamp: DateTime.now().toIso8601String(),
          payload: {},
        ),
        OrchestrationEventRecord(
          eventId: 'evt_2',
          eventType: 'task_completed',
          category: EventCategory.task,
          persistencePolicy: EventPersistencePolicy.persistent,
          replayable: true,
          originModule: 'tasks',
          sessionId: 'session_1',
          timestamp: DateTime.now().toIso8601String(),
          payload: {},
        ),
      ];

      final result = engine.replay(events);

      expect(result.length, 2);
      expect(result[0].contains('REPLAY: task_created'), true);
      expect(result[1].contains('REPLAY: task_completed'), true);
    });

    test('non-replayable events are excluded', () {
      final engine = ReplayEngine();

      final events = [
        OrchestrationEventRecord(
          eventId: 'evt_1',
          eventType: 'task_created',
          category: EventCategory.task,
          persistencePolicy: EventPersistencePolicy.persistent,
          replayable: true,
          originModule: 'tasks',
          sessionId: 'session_1',
          timestamp: DateTime.now().toIso8601String(),
          payload: {},
        ),
        OrchestrationEventRecord(
          eventId: 'evt_2',
          eventType: 'internal_audit',
          category: EventCategory.audit,
          persistencePolicy: EventPersistencePolicy.audit,
          replayable: false,
          originModule: 'system',
          sessionId: 'session_1',
          timestamp: DateTime.now().toIso8601String(),
          payload: {},
        ),
      ];

      final result = engine.replay(events);

      expect(result.length, 1);
      expect(result[0].contains('task_created'), true);
    });

    test('events older than 90 days are excluded', () {
      final engine = ReplayEngine();

      final events = [
        OrchestrationEventRecord(
          eventId: 'evt_old',
          eventType: 'task_created',
          category: EventCategory.task,
          persistencePolicy: EventPersistencePolicy.persistent,
          replayable: true,
          originModule: 'tasks',
          sessionId: 'session_1',
          timestamp: DateTime.now().subtract(const Duration(days: 100)).toIso8601String(),
          payload: {},
        ),
      ];

      final result = engine.replay(events);

      expect(result.length, 0);
    });
  });
}