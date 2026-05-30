import 'package:flutter_test/flutter_test.dart';
import 'package:beth_app/core/enums/shared_enums.dart';
import 'package:beth_app/core/resolvers/resolver_context.dart';
import 'package:beth_app/core/resolvers/resolver_engine.dart';
import 'package:beth_app/core/resolvers/resolver_target.dart';
import 'package:beth_app/core/resolvers/rules/overwhelm_notification_rule.dart';
import 'package:beth_app/core/resolvers/rules/test_priority_rule.dart';

class _TestTarget extends ResolverTarget {
  const _TestTarget() : super(id: 'test_1');
}
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Conflict Resolution', () {
    test('higher priority rule wins', () {
      // OverwhelmNotificationRule has priority 50
      // TestPriorityRule has priority 100
      final engine = ResolverEngine(
        rules: [OverwhelmNotificationRule(), TestPriorityRule()],
      );

      final context = ResolverContext(
        reduceNotifications: true,
        activeStateIds: ['overwhelmed'],
        currentTime: DateTime.now(),
      );
      final target = const _TestTarget();
      final result = engine.resolve(context, target);

      // TestPriorityRule (priority 100) should win over OverwhelmNotificationRule (priority 50)
      expect(result.winningRule!.ruleId, 'RULE_TEST_PRIORITY');
    });

    test('same priority — first registered wins', () {
      // Two TestPriorityRules both have priority 100
      final engine = ResolverEngine(
        rules: [TestPriorityRule(), TestPriorityRule()],
      );

      final context = ResolverContext(
        reduceNotifications: false,
        currentTime: DateTime.now(),
      );
      final target = const _TestTarget();
      final result = engine.resolve(context, target);

      // First registered TestPriorityRule wins (both always match)
      expect(result.winningRule!.ruleId, 'RULE_TEST_PRIORITY');
      expect(result.effect.decision, ResolverDecision.digest);
    });

    test('manual override — empty engine beats all rules', () {
      final engine = ResolverEngine();

      final context = ResolverContext(
        reduceNotifications: true,
        activeStateIds: ['overwhelmed'],
        currentTime: DateTime.now(),
      );
      final target = const _TestTarget();
      final result = engine.resolve(context, target);

      // No rules = manual override = allow everything
      expect(result.effect.decision, ResolverDecision.allow);
      expect(result.effect.showNotification, true);
      expect(result.traces.isEmpty, true);
    });
  });
}