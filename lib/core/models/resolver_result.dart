import '../resolvers/resolver_effect.dart';

class ResolverTrace {
  final String ruleId;
  final String ruleName;
  final bool matched;
  final int priority;
  final String effect;
  final String? originEventId; 

  const ResolverTrace({
    required this.ruleId,
    required this.ruleName,
    required this.matched,
    required this.priority,
    required this.effect,
    this.originEventId,
  });
}

class ResolverResult {
  final ResolverEffect effect;
  final ResolverTrace? winningRule;
  final List<ResolverTrace> traces;

  const ResolverResult({
    required this.effect,
    required this.winningRule,
    required this.traces,
  });
}