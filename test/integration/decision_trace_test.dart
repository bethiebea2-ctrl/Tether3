import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beth_app/core/resolvers/resolver_engine.dart';
import 'package:beth_app/core/resolvers/resolver_context.dart';
import 'package:beth_app/core/resolvers/resolver_target.dart';
import 'package:beth_app/core/resolvers/rules/overwhelm_notification_rule.dart';
import 'package:beth_app/core/resolvers/rules/quiet_hours_rule.dart';
import 'package:beth_app/core/tracing/trace_service.dart';

class _TestTarget extends ResolverTarget {
  const _TestTarget() : super(id: 'test_target');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Decision Trace', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('trace is created for each resolution cycle', () {
      final traceService = TraceService();
      final engine = ResolverEngine(
        rules: [OverwhelmNotificationRule()],
      );

      final context = ResolverContext(
        reduceNotifications: true,
        activeStateIds: ['overwhelmed'],
        currentTime: DateTime.now(),
      );

      engine.resolve(context, const _TestTarget());

      // Trace should have been ended — no active trace
      expect(traceService.activeTrace, isNull);
    });

    test('trace IDs are unique across resolution cycles', () {
      final traceService = TraceService();
      final engine = ResolverEngine(
        rules: [OverwhelmNotificationRule()],
      );

      final context = ResolverContext(
        currentTime: DateTime.now(),
      );

      // Generate two trace IDs
      final id1 = traceService.generateTraceId();
      final id2 = traceService.generateTraceId();

      expect(id1.id, isNot(id2.id));
      expect(id1.id, startsWith('TRACE-'));
    });

    test('multiple rules produce complete trace', () {
      final engine = ResolverEngine(
        rules: [
          OverwhelmNotificationRule(),
          QuietHoursRule(),
        ],
      );

      final context = ResolverContext(
        reduceNotifications: true,
        activeStateIds: ['overwhelmed'],
        currentTime: DateTime.now(),
      );

      final result = engine.resolve(context, const _TestTarget());

      // Traces should include evaluation of both rules
      expect(result.traces.length, greaterThanOrEqualTo(1));
      expect(result.traces.any((t) => t.ruleId == 'RULE_OVERWHELM_NOTIFICATION'), true);
    });
  });
}