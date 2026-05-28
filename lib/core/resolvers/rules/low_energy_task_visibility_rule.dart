import '../../enums/shared_enums.dart';
import '../resolver_context.dart';
import '../resolver_effect.dart';
import '../resolver_target.dart';
import '../resolver_rule.dart';
import '../rule_category.dart';
import '../rule_risk_level.dart';

class LowEnergyTaskVisibilityRule extends ResolverRule {
  @override
  String get ruleId => 'low_energy_task_visibility_rule';

  @override
  String get ruleName => 'Low Energy Task Visibility Rule';

  @override
  String get description => 'Hides high-energy tasks when low energy state is active';

  @override
  int get priority => 45;

  @override
  RuleCategory get category => RuleCategory.accessibility;

  @override
  RuleRiskLevel get riskLevel => RuleRiskLevel.green;

  @override
  List<String> get affectedTargets => ['tasks'];

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
        reason: 'Low energy state active — high-energy tasks suppressed',
      );
    }

    return ResolverEffect.allow;
  }
}