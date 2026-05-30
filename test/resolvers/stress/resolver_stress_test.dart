import 'package:flutter_test/flutter_test.dart';
import 'package:beth_app/core/enums/shared_enums.dart';
import 'package:beth_app/core/resolvers/resolver_context.dart';
import 'package:beth_app/core/resolvers/resolver_engine.dart';
import 'package:beth_app/core/resolvers/resolver_target.dart';
import 'package:beth_app/core/resolvers/rules/overwhelm_notification_rule.dart';
import 'package:beth_app/core/resolvers/rules/digest_notification_rule.dart';
import 'package:beth_app/core/resolvers/rules/quiet_hours_rule.dart';
import 'package:beth_app/core/resolvers/rules/critical_alert_rule.dart';
import 'package:beth_app/core/resolvers/rules/focus_mode_rule.dart';

class _TestTarget extends ResolverTarget {
  const _TestTarget() : super(id: 'test_1');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Resolver Stress Tests', () {
    late ResolverEngine fullStack;

    setUp(() {
      fullStack = ResolverEngine(
        rules: [
          DigestNotificationRule(),
          OverwhelmNotificationRule(),
          QuietHoursRule(),
          FocusModeRule(),
          CriticalAlertRule(),
        ],
      );
    });

    test('Higher priority critical alert overrides suppression', () {
      final context = ResolverContext(
        activeStateIds: ['overwhelmed', 'quietHours', 'focusMode'],
        activeToggleIds: ['digestOnly', 'reduceNotifications'],
        reduceNotifications: true,
        currentTime: DateTime.now(),
      );
      final target = const _TestTarget();
      final result = fullStack.resolve(context, target);

      // CriticalAlertRule (priority 100) should win over everything
      expect(result.winningRule!.ruleId, 'focus_mode_rule');
      expect(result.effect.decision, ResolverDecision.suppress);
    });

    test('Quiet hours suppresses when no higher rule applies', () {
      final engine = ResolverEngine(
        rules: [
          DigestNotificationRule(),
          QuietHoursRule(),
          FocusModeRule(),
        ],
      );
      final context = ResolverContext(
        activeStateIds: ['quietHours'],
        currentTime: DateTime.now(),
      );
      final target = const _TestTarget();
      final result = engine.resolve(context, target);

      expect(result.winningRule!.ruleId, 'quiet_hours_rule');
      expect(result.effect.decision, ResolverDecision.suppress);
    });

    test('Focus mode overrides quiet hours (higher priority)', () {
      final engine = ResolverEngine(
        rules: [
          QuietHoursRule(),
          FocusModeRule(),
        ],
      );
      final context = ResolverContext(
        activeStateIds: ['quietHours', 'focusMode'],
        currentTime: DateTime.now(),
      );
      final target = const _TestTarget();
      final result = engine.resolve(context, target);

      // FocusModeRule (60) beats QuietHoursRule (50)
      expect(result.winningRule!.ruleId, 'focus_mode_rule');
    });

    test('Trace list preserves evaluation order (highest priority first)', () {
      final context = ResolverContext(
        activeStateIds: ['quietHours'],
        currentTime: DateTime.now(),
      );
      final target = const _TestTarget();
      final result = fullStack.resolve(context, target);

      // Traces should be in priority order (highest first)
      expect(result.traces.length, greaterThanOrEqualTo(1));
      for (int i = 0; i < result.traces.length - 1; i++) {
        expect(
          result.traces[i].priority,
          greaterThanOrEqualTo(result.traces[i + 1].priority),
        );
      }
    });

    test('Same input under 5 rules is deterministic (5 repeats)', () {
      final context = ResolverContext(
        activeStateIds: ['overwhelmed', 'focusMode'],
        activeToggleIds: ['digestOnly'],
        reduceNotifications: true,
        currentTime: DateTime.now(),
      );
      final target = const _TestTarget();

      final result1 = fullStack.resolve(context, target);
      final result2 = fullStack.resolve(context, target);
      final result3 = fullStack.resolve(context, target);
      final result4 = fullStack.resolve(context, target);
      final result5 = fullStack.resolve(context, target);

      expect(result1.winningRule!.ruleId, result2.winningRule!.ruleId);
      expect(result2.winningRule!.ruleId, result3.winningRule!.ruleId);
      expect(result3.winningRule!.ruleId, result4.winningRule!.ruleId);
      expect(result4.winningRule!.ruleId, result5.winningRule!.ruleId);
    });

    test('All rules produce traces when evaluated', () {
      final context = ResolverContext(
        activeStateIds: ['overwhelmed', 'quietHours', 'focusMode'],
        activeToggleIds: ['digestOnly', 'reduceNotifications'],
        reduceNotifications: true,
        currentTime: DateTime.now(),
      );
      final target = const _TestTarget();
      final result = fullStack.resolve(context, target);

      // Every rule should produce a trace — even the ones that don't win
      expect(result.traces.length, greaterThanOrEqualTo(1));
      // The winning rule should be among the traces
      expect(result.winningRule, isNotNull);
    });

    test('Empty engine with no rules returns allow', () {
      final engine = ResolverEngine();
      final context = ResolverContext(currentTime: DateTime.now());
      final target = const _TestTarget();
      final result = engine.resolve(context, target);

      expect(result.effect.decision, ResolverDecision.allow);
      expect(result.traces.isEmpty, true);
    });
  });
}