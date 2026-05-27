import '../resolvers/resolver_effect.dart';

class ResolverTrace {
  final String ruleId;
  final String ruleName;
  final bool matched;
  final int priority;
  final String effect;

  const ResolverTrace({
    required this.ruleId,
    required this.ruleName,
    required this.matched,
    required this.priority,
    required this.effect,
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