import '../enums/shared_enums.dart';
import '../models/resolver_result.dart';
import '../history/resolver_decision_service.dart';
import 'resolver_context.dart';
import 'resolver_effect.dart';
import 'resolver_rule.dart';
import 'resolver_target.dart';

class ResolverEngine {
  final List<ResolverRule> _rules;
  final _decisionService = ResolverDecisionService();

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
      );
    } catch (_) {
      // SharedPreferences not available in test VM environment — silently skip
    }

    return result;
  }
}