import '../../enums/shared_enums.dart';
import '../resolver_context.dart';
import '../resolver_effect.dart';
import '../resolver_target.dart';
import '../resolver_rule.dart';
import '../rule_category.dart';
import '../rule_risk_level.dart';

class CriticalAlertRule extends ResolverRule {
  @override
  String get ruleId => 'critical_alert_rule';

  @override
  String get ruleName => 'Critical Alert Rule';

  @override
  String get description => 'Allows critical alerts to bypass all suppression rules';

  @override
  int get priority => 100;

  @override
  RuleCategory get category => RuleCategory.safety;

  @override
  RuleRiskLevel get riskLevel => RuleRiskLevel.amber;

  @override
  List<String> get affectedTargets => ['notifications', 'alerts'];

  @override
  ResolverEffect evaluate(
    ResolverContext context,
    ResolverTarget target,
  ) {
    return ResolverEffect.allow;
  }
}