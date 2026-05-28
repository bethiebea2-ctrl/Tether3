import 'resolver_context.dart';
import 'resolver_effect.dart';
import 'resolver_target.dart';
import 'rule_category.dart';
import 'rule_risk_level.dart';

abstract class ResolverRule {
  String get ruleId;
  String get ruleName;
  String get description;
  int get priority;
  RuleCategory get category;
  RuleRiskLevel get riskLevel;
  List<String> get affectedTargets;

  ResolverEffect evaluate(
    ResolverContext context,
    ResolverTarget target,
  );
}