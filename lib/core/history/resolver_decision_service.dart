import 'package:uuid/uuid.dart';
import 'models/resolver_decision_record.dart';
import 'orchestration_history_service.dart';

class ResolverDecisionService {
  final _history = OrchestrationHistoryService();
  final _uuid = const Uuid();

  Future<void> saveDecision({
    required String target,
    required String winningRuleId,
    required String winningRuleName,
    required String effect,
    required int traceCount,
    String? sessionId,
    String? originEventId,
  }) async {
    final record = ResolverDecisionRecord(
      decisionId: _uuid.v4(),
      timestamp: DateTime.now().toIso8601String(),
      target: target,
      winningRuleId: winningRuleId,
      winningRuleName: winningRuleName,
      effect: effect,
      traceCount: traceCount,
      sessionId: sessionId,
      originEventId: originEventId,
    );

    try {
      await _history.saveDecision(record);
    } catch (_) {
      // SharedPreferences unavailable (test VM) — silently skip persistence
    }
  }
}