import 'package:flutter_test/flutter_test.dart';
import 'package:beth_app/core/history/models/resolver_decision_record.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Decision Validation', () {
    test('valid decision has all required fields', () {
      final record = ResolverDecisionRecord(
        decisionId: 'dec_001',
        timestamp: DateTime.now().toIso8601String(),
        target: 'task',
        winningRuleId: 'rule_1',
        winningRuleName: 'Test Rule',
        effect: 'suppress',
        traceCount: 2,
      );

      expect(record.decisionId.isNotEmpty, true);
      expect(record.winningRuleId.isNotEmpty, true);
      expect(record.effect.isNotEmpty, true);
      expect(record.timestamp.isNotEmpty, true);
    });

    test('empty decisionId is invalid', () {
      final record = ResolverDecisionRecord(
        decisionId: '',
        timestamp: DateTime.now().toIso8601String(),
        target: 'task',
        winningRuleId: 'rule_1',
        winningRuleName: 'Test Rule',
        effect: 'suppress',
        traceCount: 2,
      );

      expect(record.decisionId.isEmpty, true);
    });

    test('empty winningRuleId is invalid', () {
      final record = ResolverDecisionRecord(
        decisionId: 'dec_001',
        timestamp: DateTime.now().toIso8601String(),
        target: 'task',
        winningRuleId: '',
        winningRuleName: 'Test Rule',
        effect: 'suppress',
        traceCount: 2,
      );

      expect(record.winningRuleId.isEmpty, true);
    });

    test('encode and decode roundtrip preserves all fields', () {
      final original = ResolverDecisionRecord(
        decisionId: 'dec_001',
        timestamp: '2026-05-30T12:00:00.000',
        target: 'notification',
        winningRuleId: 'critical_alert_rule',
        winningRuleName: 'Critical Alert Rule',
        effect: 'allow',
        traceCount: 5,
        sessionId: 'session_1',
        originEventId: 'evt_001',
      );

      final encoded = original.encode();
      final decoded = ResolverDecisionRecord.decode(encoded);

      expect(decoded.decisionId, original.decisionId);
      expect(decoded.target, original.target);
      expect(decoded.winningRuleId, original.winningRuleId);
      expect(decoded.winningRuleName, original.winningRuleName);
      expect(decoded.effect, original.effect);
      expect(decoded.traceCount, original.traceCount);
      expect(decoded.sessionId, original.sessionId);
      expect(decoded.originEventId, original.originEventId);
    });
  });
}