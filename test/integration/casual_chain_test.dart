import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beth_app/core/resolvers/resolver_engine.dart';
import 'package:beth_app/core/resolvers/resolver_context.dart';
import 'package:beth_app/core/resolvers/resolver_target.dart';
import 'package:beth_app/core/resolvers/rules/overwhelm_notification_rule.dart';
import 'package:beth_app/core/history/orchestration_history_service.dart';

class _TestTarget extends ResolverTarget {
  const _TestTarget() : super(id: 'test_target');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Causal Chain', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('decision persistence survives across multiple resolutions', () async {
      final engine = ResolverEngine(
        rules: [OverwhelmNotificationRule()],
      );

      final overwhelmContext = ResolverContext(
        reduceNotifications: true,
        activeStateIds: ['overwhelmed'],
        currentTime: DateTime.now(),
      );

      final normalContext = ResolverContext(
        reduceNotifications: false,
        activeStateIds: [],
        currentTime: DateTime.now(),
      );

      final target = const _TestTarget();

      // Run multiple resolutions
      engine.resolve(overwhelmContext, target);
      await Future.delayed(const Duration(milliseconds: 100));
      engine.resolve(normalContext, target);
      await Future.delayed(const Duration(milliseconds: 100));
      engine.resolve(overwhelmContext, target);
      await Future.delayed(const Duration(milliseconds: 100));

      // Verify all decisions persisted
      final history = OrchestrationHistoryService();
      final decisions = await history.loadDecisions();

      expect(decisions.length, 3);
      expect(decisions[0].effect, 'digest');
      expect(decisions[1].effect, 'allow');
      expect(decisions[2].effect, 'digest');
    });
  });
}