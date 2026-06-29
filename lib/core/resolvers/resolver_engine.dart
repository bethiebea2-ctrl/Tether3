import 'package:uuid/uuid.dart';
import '../enums/shared_enums.dart';
import '../models/resolver_result.dart';
import '../history/resolver_decision_service.dart';
import 'models/resolver_invocation.dart';
import 'resolver_context.dart';
import 'resolver_effect.dart';
import 'resolver_rule.dart';
import 'resolver_target.dart';
import '../tracing/trace_service.dart';

class ResolverEngine {
  final List<ResolverRule> _rules;
  final _decisionService = ResolverDecisionService();
  final _uuid = const Uuid();
  final _traceService = TraceService();
  ResolverEngine({
    List<ResolverRule>? rules,
  }) : _rules = rules ?? [];

  void registerRule(ResolverRule rule) {
    _rules.add(rule);
  }

  ResolverResult resolve(
    ResolverContext context,
    ResolverTarget target,
  ) {
    final stopwatch = Stopwatch()..start();
    final invocationId = _uuid.v4();
    final triggerTimestamp = DateTime.now().toIso8601String();

    // Capture active state context for causal linkage
    final activeStateId = context.activeStateIds.isNotEmpty
        ? context.activeStateIds.first
        : null;

    // Begin trace for this decision cycle
    final trace = _traceService.beginTrace(stateRecordId: activeStateId);
    final traceId = trace.traceId.id;

    final traces = <ResolverTrace>[];
    ResolverTrace? winningTrace;
    ResolverEffect finalEffect = ResolverEffect.allow;

    final sortedRules = [..._rules]
      ..sort((a, b) => b.priority.compareTo(a.priority));

    for (final rule in sortedRules) {
      final effect = rule.evaluate(context, target);
      final matched = effect.decision != ResolverDecision.allow ||
          effect.showNotification == false ||
          effect.digestOnly == true;

      final trace = ResolverTrace(
        ruleId: rule.ruleId,
        ruleName: rule.ruleName,
        matched: matched,
        priority: rule.priority,
        effect: matched ? effect.decision.name : 'allow',
      );

      traces.add(trace);

      if (matched) {
        winningTrace = trace;
        finalEffect = effect;
        break;
      }
    }

    stopwatch.stop();

    final result = ResolverResult(
      effect: finalEffect,
      winningRule: winningTrace,
      traces: traces,
    );

    // Persist every resolver decision (fire-and-forget, safe in test environments)
    try {
      _decisionService.saveDecision(
        target: target.toString(),
        winningRuleId: winningTrace?.ruleId ?? 'none',
        winningRuleName: winningTrace?.ruleName ?? 'none',
        effect: finalEffect.decision.name,
        traceCount: traces.length,
        originEventId: invocationId,
      );
    } catch (_) {
      // SharedPreferences not available in test VM environment — silently skip
    }

    // Build resolver invocation record for causal traceability
    final invocation = ResolverInvocation(
      invocationId: invocationId,
      stateRecordId: activeStateId,
      resolverName: 'ResolverEngine',
      triggerTimestamp: triggerTimestamp,
      executionDurationMs: stopwatch.elapsedMilliseconds,
      decisionId: winningTrace?.ruleId,
      confidence: null, // Future: calculate from rule match strength
      metadata: {
        'activeStateIds': context.activeStateIds,
        'activePresets': context.activePresets.map((p) => p.id).toList(),
        'target': target.toString(),
        'totalRules': _rules.length,
        'tracesEvaluated': traces.length,
        'traceId': traceId,
      },
    );

    // TODO: Persist invocation via ResolverInvocationService (Priority 1 complete — persistence deferred to Priority 2 tracing)
    _traceService.endTrace();
    return result;
  }
}