import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beth_app/core/resolvers/resolver_engine.dart';
import 'package:beth_app/core/resolvers/resolver_context.dart';
import 'package:beth_app/core/resolvers/resolver_target.dart';
import 'package:beth_app/core/resolvers/rules/overwhelm_notification_rule.dart';
import 'package:beth_app/core/enums/shared_enums.dart';
import 'package:beth_app/core/history/orchestration_history_service.dart';
import 'package:beth_app/core/history/resolver_decision_service.dart';

class _TestTarget extends ResolverTarget {
  const _TestTarget() : super(id: 'test_target');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('State-to-Resolver Causal Chain', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('complete causal chain: state → resolver → decision', () async {
      // 1. Set up resolver with known rule
      final engine = ResolverEngine(
        rules: [OverwhelmNotificationRule()],
      );

      // 2. Create context with active state
      final context = ResolverContext(
        reduceNotifications: true,
        activeStateIds: ['overwhelmed'],
        currentTime: DateTime.now(),
      );

      final target = const _TestTarget();

      // 3. Resolve — this triggers state capture, trace, decision persistence
      final result = engine.resolve(context, target);
      await Future.delayed(const Duration(milliseconds: 100));

      // 4. Verify resolver produced a decision
      expect(result.effect.decision, ResolverDecision.digest);
      expect(result.winningRule, isNotNull);
      expect(result.winningRule!.ruleId, 'RULE_OVERWHELM_NOTIFICATION');
      expect(result.traces.isNotEmpty, true);

      // 5. Verify decision was persisted
      final history = OrchestrationHistoryService();
      final decisions = await history.loadDecisions();
      expect(decisions.isNotEmpty, true);
      expect(decisions.last.winningRuleId, 'RULE_OVERWHELM_NOTIFICATION');
      expect(decisions.last.effect, 'digest');
    });

    test('state change produces different decision', () {
      final engine = ResolverEngine(
        rules: [OverwhelmNotificationRule()],
      );

      // No overwhelm state — should allow
      final normalContext = ResolverContext(
        reduceNotifications: false,
        activeStateIds: [],
        currentTime: DateTime.now(),
      );

      final target = const _TestTarget();
      final normalResult = engine.resolve(normalContext, target);

      expect(normalResult.effect.decision, ResolverDecision.allow);

      // With overwhelm state — should digest
      final overwhelmContext = ResolverContext(
        reduceNotifications: true,
        activeStateIds: ['overwhelmed'],
        currentTime: DateTime.now(),
      );

      final overwhelmResult = engine.resolve(overwhelmContext, target);

      expect(overwhelmResult.effect.decision, ResolverDecision.digest);
      expect(overwhelmResult.effect.showNotification, false);
    });
  });
}