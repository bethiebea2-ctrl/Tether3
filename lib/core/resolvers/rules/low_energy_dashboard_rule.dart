import '../../enums/shared_enums.dart';
import '../resolver_context.dart';
import '../resolver_effect.dart';
import '../resolver_target.dart';
import '../resolver_rule.dart';
import '../rule_category.dart';
import '../rule_risk_level.dart';

class LowEnergyDashboardRule extends ResolverRule {
  @override
  String get ruleId => 'low_energy_dashboard_rule';

  @override
  String get ruleName => 'Low Energy Dashboard Rule';

  @override
  String get description => 'Suppresses non-essential dashboard modules during low-energy states';

  @override
  int get priority => 45;

  @override
  RuleCategory get category => RuleCategory.accessibility;

  @override
  RuleRiskLevel get riskLevel => RuleRiskLevel.green;

  @override
  List<String> get affectedTargets => ['dashboard', 'tasks', 'team'];

  @override
  ResolverEffect evaluate(
    ResolverContext context,
    ResolverTarget target,
  ) {
    if (context.isLowEnergy) {
      return const ResolverEffect(
        decision: ResolverDecision.suppress,
        showNotification: false,
        suppressSound: true,
        suppressVibration: true,
        digestOnly: true,
        reason: 'Low energy state active — non-essential modules suppressed',
      );
    }

    return ResolverEffect.allow;
  }
}