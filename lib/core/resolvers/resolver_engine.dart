import 'package:uuid/uuid.dart';
import '../enums/shared_enums.dart';
import '../models/resolver_result.dart';
import '../history/resolver_decision_service.dart';
import '../tracing/trace_service.dart';
import '../performance/performance_metrics_service.dart';
import 'models/resolver_invocation.dart';
import 'models/decision_explanation.dart';
import 'resolver_context.dart';
import 'resolver_effect.dart';
import 'resolver_rule.dart';
import 'resolver_target.dart';

class ResolverEngine {
  final List<ResolverRule> _rules;
  final _decisionService = ResolverDecisionService();
  final _traceService = TraceService();
  final _metricsService = PerformanceMetricsService();
  final _uuid = const Uuid();

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

      final resolverTrace = ResolverTrace(
        ruleId: rule.ruleId,
        ruleName: rule.ruleName,
        matched: matched,
        priority: rule.priority,
        effect: matched ? effect.decision.name : 'allow',
      );

      traces.add(resolverTrace);

      if (matched) {
        winningTrace = resolverTrace;
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
      _decisionService.saveDecision(
      target: target.toString(),
      winningRuleId: winningTrace?.ruleId ?? 'none',
      winningRuleName: winningTrace?.ruleName ?? 'none',
      effect: finalEffect.decision.name,
      traceCount: traces.length,
      originEventId: invocationId,
    ).catchError((_) {});
    
    _metricsService.record('resolver_execution', stopwatch.elapsedMilliseconds).catchError((_) {});

    // Build decision explanation
    final explanation = DecisionExplanation(
      decisionId: winningTrace?.ruleId ?? 'none',
      reason: _buildReason(finalEffect, winningTrace),
      confidence: winningTrace != null ? 0.95 : 0.5,
      triggeredRules: traces.map((t) => t.ruleId).toList(),
      supportingEvents: [],
      recommendation: _buildRecommendation(finalEffect),
      timestamp: triggerTimestamp,
    );

    // Build resolver invocation record for causal traceability
    final invocation = ResolverInvocation(
      invocationId: invocationId,
      stateRecordId: activeStateId,
      resolverName: 'ResolverEngine',
      triggerTimestamp: triggerTimestamp,
      executionDurationMs: stopwatch.elapsedMilliseconds,
      decisionId: winningTrace?.ruleId,
      confidence: explanation.confidence,
      metadata: {
        'traceId': traceId,
        'activeStateIds': context.activeStateIds,
        'activePresets': context.activePresets.map((p) => p.id).toList(),
        'target': target.toString(),
        'totalRules': _rules.length,
        'tracesEvaluated': traces.length,
        'reason': explanation.reason,
        'recommendation': explanation.recommendation,
      },
    );

    _traceService.endTrace();

    return result;
  }

  String _buildReason(ResolverEffect effect, ResolverTrace? winningTrace) {
    if (winningTrace == null) {
      return 'No rules matched — default allow applied';
    }
    return 'Rule "${winningTrace.ruleName}" matched with decision: ${effect.decision.name}';
  }

  String? _buildRecommendation(ResolverEffect effect) {
    switch (effect.decision) {
      case ResolverDecision.digest:
        return 'Review in digest at end of period';
      case ResolverDecision.suppress:
        return 'Re-evaluate when state changes';
      case ResolverDecision.allow:
      default:
        return null;
    }
  }
}