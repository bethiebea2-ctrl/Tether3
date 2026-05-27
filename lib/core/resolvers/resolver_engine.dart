import '../enums/shared_enums.dart';
import '../models/resolver_result.dart';
import 'resolver_context.dart';
import 'resolver_effect.dart';
import 'resolver_rule.dart';
import 'resolver_target.dart';

class ResolverEngine {
  final List<ResolverRule> _rules;

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

    return ResolverResult(
      effect: finalEffect,
      winningRule: winningTrace,
      traces: traces,
    );
  }
}