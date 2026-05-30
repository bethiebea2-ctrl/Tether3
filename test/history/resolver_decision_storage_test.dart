import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beth_app/core/history/resolver_decision_service.dart';
import 'package:beth_app/core/history/orchestration_history_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Resolver Decision Persistence', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('resolver decision persists', () async {
      final service = ResolverDecisionService();

      await service.saveDecision(
        target: 'task',
        winningRuleId: 'rule1',
        winningRuleName: 'Test Rule',
        effect: 'allow',
        traceCount: 1,
      );

      final history = OrchestrationHistoryService();
      final decisions = await history.loadDecisions();

      expect(decisions.isNotEmpty, true);
      expect(decisions.last.winningRuleId, 'rule1');
      expect(decisions.last.effect, 'allow');
    });

    test('decision fields are populated correctly', () async {
      final service = ResolverDecisionService();

      await service.saveDecision(
        target: 'notification',
        winningRuleId: 'critical_alert_rule',
        winningRuleName: 'Critical Alert Rule',
        effect: 'allow',
        traceCount: 3,
        sessionId: 'session_test',
        originEventId: 'evt_001',
      );

      final history = OrchestrationHistoryService();
      final decisions = await history.loadDecisions();
      final saved = decisions.last;

      expect(saved.decisionId.isNotEmpty, true);
      expect(saved.timestamp.isNotEmpty, true);
      expect(saved.target, 'notification');
      expect(saved.winningRuleId, 'critical_alert_rule');
      expect(saved.winningRuleName, 'Critical Alert Rule');
      expect(saved.effect, 'allow');
      expect(saved.traceCount, 3);
      expect(saved.sessionId, 'session_test');
      expect(saved.originEventId, 'evt_001');
    });
  });
}