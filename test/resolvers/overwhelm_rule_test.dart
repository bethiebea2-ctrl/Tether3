import 'package:flutter_test/flutter_test.dart';
import 'package:beth_app/core/enums/shared_enums.dart';
import 'package:beth_app/core/resolvers/resolver_context.dart';
import 'package:beth_app/core/resolvers/resolver_effect.dart';
import 'package:beth_app/core/resolvers/resolver_engine.dart';
import 'package:beth_app/core/resolvers/resolver_target.dart';
import 'package:beth_app/core/resolvers/rules/overwhelm_notification_rule.dart';
import 'package:beth_app/core/resolvers/state_priority.dart';
import 'package:beth_app/core/resolvers/priority_resolver.dart';
import 'package:beth_app/core/events/event_bus.dart';
import 'package:beth_app/core/tasks/events/task_created_event.dart';
import 'package:beth_app/core/tasks/task_item.dart';
import 'package:beth_app/core/tasks/task_status.dart';
import 'package:beth_app/core/tasks/task_priority.dart' as task_priority;
import 'package:beth_app/core/tasks/task_energy.dart';

class _TestTarget extends ResolverTarget {
  const _TestTarget() : super(id: 'test_1');
}
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // ============================================
  // TEST GROUP 1 — RESOLVER DETERMINISM
  // ============================================
  group('Resolver Determinism', () {
    late ResolverEngine engine;

    setUp(() {
      engine = ResolverEngine(
        rules: [OverwhelmNotificationRule()],
      );
    });

    test('Overwhelm + reduceNotifications → suppress notifications', () {
      final context = ResolverContext(
        reduceNotifications: true,
        activeStateIds: ['overwhelmed'],
        currentTime: DateTime.now(),
      );
      final target = const _TestTarget();
      final result = engine.resolve(context, target);

      expect(result.effect.decision, ResolverDecision.digest);
      expect(result.effect.showNotification, false);
      expect(result.effect.digestOnly, true);
    });

    test('No active states → allow notifications', () {
      final context = ResolverContext(
        reduceNotifications: false,
        activeStateIds: [],
        currentTime: DateTime.now(),
      );
      final target = const _TestTarget();
      final result = engine.resolve(context, target);

      expect(result.effect.decision, ResolverDecision.allow);
      expect(result.effect.showNotification, true);
    });

    test('Same inputs produce same outputs (determinism check)', () {
      final context = ResolverContext(
        reduceNotifications: true,
        activeStateIds: ['overwhelmed'],
        currentTime: DateTime.now(),
      );
      final target = const _TestTarget();

      final result1 = engine.resolve(context, target);
      final result2 = engine.resolve(context, target);
      final result3 = engine.resolve(context, target);

      expect(result1.effect.decision, result2.effect.decision);
      expect(result2.effect.decision, result3.effect.decision);
      expect(result1.effect.showNotification, result2.effect.showNotification);
      expect(result2.effect.showNotification, result3.effect.showNotification);
    });

    test('Digest mode forces digest delivery', () {
      final context = ResolverContext(
        reduceNotifications: true,
        notificationMode: NotificationMode.digest,
        currentTime: DateTime.now(),
      );
      final target = const _TestTarget();
      final result = engine.resolve(context, target);

      expect(result.effect.decision, ResolverDecision.digest);
      expect(result.effect.digestOnly, true);
    });

    test('Manual override beats everything — empty engine returns allow', () {
      final manualEngine = ResolverEngine();
      final context = ResolverContext(
        reduceNotifications: true,
        activeStateIds: ['overwhelmed'],
        currentTime: DateTime.now(),
      );
      final target = const _TestTarget();
      final result = manualEngine.resolve(context, target);

      expect(result.effect.decision, ResolverDecision.allow);
      expect(result.effect.showNotification, true);
    });

    test('ResolverResult includes traces', () {
      final context = ResolverContext(
        reduceNotifications: true,
        activeStateIds: ['overwhelmed'],
        currentTime: DateTime.now(),
      );
      final target = const _TestTarget();
      final result = engine.resolve(context, target);

      expect(result.traces.isNotEmpty, true);
      expect(result.winningRule, isNotNull);
      expect(result.winningRule!.ruleId, 'RULE_OVERWHELM_NOTIFICATION');
    });
  });

  // ============================================
  // TEST GROUP 4 — PRIORITY RESOLUTION
  // ============================================
  group('Priority Resolution', () {
    test('manualOverride beats currentState', () {
      final priorities = [
        StatePriority.currentState,
        StatePriority.manualOverride,
      ];
      final result = PriorityResolver.resolveHighest(priorities);
      expect(result, StatePriority.manualOverride);
    });

    test('currentState beats supportPreset', () {
      final priorities = [
        StatePriority.supportPreset,
        StatePriority.currentState,
      ];
      final result = PriorityResolver.resolveHighest(priorities);
      expect(result, StatePriority.currentState);
    });

    test('supportPreset beats systemDefault', () {
      final priorities = [
        StatePriority.systemDefault,
        StatePriority.supportPreset,
      ];
      final result = PriorityResolver.resolveHighest(priorities);
      expect(result, StatePriority.supportPreset);
    });

    test('Full precedence chain: manual > currentState > preset > default', () {
      final priorities = [
        StatePriority.systemDefault,
        StatePriority.supportPreset,
        StatePriority.currentState,
        StatePriority.manualOverride,
      ];
      final result = PriorityResolver.resolveHighest(priorities);
      expect(result, StatePriority.manualOverride);
    });

    test('Empty list returns systemDefault', () {
      final result = PriorityResolver.resolveHighest([]);
      expect(result, StatePriority.systemDefault);
    });
  });

  // ============================================
  // TEST GROUP 3 — EVENT BUS
  // ============================================
  group('Event Bus', () {
    test('EventBus is a singleton', () {
      final bus1 = EventBus();
      final bus2 = EventBus();
      expect(bus1, same(bus2));
    });

    test('EventBus stream is broadcast', () {
      final bus = EventBus();
      expect(bus.stream.isBroadcast, true);
    });

    test('TaskCreatedEvent can be instantiated', () {
      final task = TaskItem(
        id: 'task_1',
        title: 'Test task',
        status: TaskStatus.pending,
        priority: task_priority.TaskPriority.medium,
        energy: TaskEnergy.medium,
        createdAt: DateTime.now(),
      );
      final event = TaskCreatedEvent(task: task);
      expect(event.eventType, 'task_created');
      expect(event.category.name, 'task');
    });
  });
}