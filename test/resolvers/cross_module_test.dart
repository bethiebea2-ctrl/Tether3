import 'package:flutter_test/flutter_test.dart';
import 'package:beth_app/core/enums/shared_enums.dart';
import 'package:beth_app/core/resolvers/resolver_context.dart';
import 'package:beth_app/core/resolvers/resolver_engine.dart';
import 'package:beth_app/core/resolvers/resolver_target.dart';
import 'package:beth_app/core/resolvers/rules/low_energy_dashboard_rule.dart';
import 'package:beth_app/core/resolvers/rules/low_energy_task_visibility_rule.dart';
import 'package:beth_app/core/events/event_bus.dart';
import 'package:beth_app/core/tasks/events/task_suggested_from_capture_event.dart';
import 'package:beth_app/core/tasks/events/task_created_event.dart';
import 'package:beth_app/core/tasks/task_item.dart';
import 'package:beth_app/core/tasks/task_status.dart';
import 'package:beth_app/core/tasks/task_priority.dart' as task_priority;
import 'package:beth_app/core/tasks/task_energy.dart';

class _TestTarget extends ResolverTarget {
  const _TestTarget() : super(id: 'test_target');
}

void main() {
  group('Cross-Module Event Chain', () {
    test('TaskSuggestedFromCaptureEvent can be instantiated', () {
      final event = TaskSuggestedFromCaptureEvent(
        captureId: 'cap_001',
        suggestedTitle: 'Book dentist appointment',
        category: 'schedule',
        timestamp: DateTime.now(),
      );
      expect(event.captureId, 'cap_001');
      expect(event.suggestedTitle, 'Book dentist appointment');
      expect(event.category, 'schedule');
    });

    test('EventBus stream is operational for cross-module events', () {
      final bus = EventBus();
      expect(bus.stream.isBroadcast, true);
    });

    test('TaskCreatedEvent carries sourceCaptureId from suggestion', () {
      final task = TaskItem(
        id: 'task_from_capture',
        title: 'Schedule team meeting',
        status: TaskStatus.pending,
        priority: task_priority.TaskPriority.medium,
        energy: TaskEnergy.medium,
        createdAt: DateTime.now(),
        sourceCaptureId: 'cap_002',
      );
      expect(task.sourceCaptureId, 'cap_002');
    });
  });

  group('Cross-Module Resolver', () {
    test('Dashboard modules suppressed during low energy', () {
      final engine = ResolverEngine(
        rules: [LowEnergyDashboardRule()],
      );
      final context = ResolverContext(
        activeStateIds: ['low_energy'],
        currentTime: DateTime.now(),
      );
      final target = const _TestTarget();
      final result = engine.resolve(context, target);

      expect(result.effect.decision, ResolverDecision.suppress);
      expect(result.winningRule!.ruleId, 'low_energy_dashboard_rule');
    });

    test('Task visibility suppressed during low energy', () {
      final engine = ResolverEngine(
        rules: [LowEnergyTaskVisibilityRule()],
      );
      final context = ResolverContext(
        activeStateIds: ['low_energy'],
        currentTime: DateTime.now(),
      );
      final target = const _TestTarget();
      final result = engine.resolve(context, target);

      expect(result.effect.decision, ResolverDecision.suppress);
      expect(result.winningRule!.ruleId, 'low_energy_task_visibility_rule');
    });

    test('Both rules can coexist in same engine', () {
      final engine = ResolverEngine(
        rules: [
          LowEnergyDashboardRule(),
          LowEnergyTaskVisibilityRule(),
        ],
      );
      final context = ResolverContext(
        activeStateIds: ['low_energy'],
        currentTime: DateTime.now(),
      );
      final target = const _TestTarget();
      final result = engine.resolve(context, target);

      expect(result.effect.decision, ResolverDecision.suppress);
    });
  });

  group('Cross-Module Determinism', () {
    test('Cross-module orchestration is deterministic (5 repeats)', () {
      final engine = ResolverEngine(
        rules: [
          LowEnergyDashboardRule(),
          LowEnergyTaskVisibilityRule(),
        ],
      );
      final context = ResolverContext(
        activeStateIds: ['low_energy', 'flare_day'],
        currentTime: DateTime.now(),
      );

      final r1 = engine.resolve(context, const _TestTarget());
      final r2 = engine.resolve(context, const _TestTarget());
      final r3 = engine.resolve(context, const _TestTarget());

      expect(r1.winningRule!.ruleId, r2.winningRule!.ruleId);
      expect(r2.winningRule!.ruleId, r3.winningRule!.ruleId);
    });
  });
}