import '../../enums/shared_enums.dart';
import '../resolver_context.dart';
import '../resolver_effect.dart';
import '../resolver_target.dart';
import '../resolver_rule.dart';
import '../rule_category.dart';
import '../rule_risk_level.dart';

class QuietHoursRule extends ResolverRule {
  @override
  String get ruleId => 'quiet_hours_rule';

  @override
  String get ruleName => 'Quiet Hours Rule';

  @override
  String get description => 'Suppresses all notifications during quiet hours';

  @override
  int get priority => 50;

  @override
  RuleCategory get category => RuleCategory.notification;

  @override
  RuleRiskLevel get riskLevel => RuleRiskLevel.green;

  @override
  List<String> get affectedTargets => ['notifications'];

  @override
  ResolverEffect evaluate(
    ResolverContext context,
    ResolverTarget target,
  ) {
    if (context.activeStateIds.contains('quietHours')) {
      return const ResolverEffect(
        decision: ResolverDecision.suppress,
        showNotification: false,
        suppressSound: true,
        suppressVibration: true,
        digestOnly: true,
        reason: 'Quiet hours active',
      );
    }

    return ResolverEffect.allow;
  }
}