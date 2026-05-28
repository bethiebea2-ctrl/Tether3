import '../../enums/shared_enums.dart';
import '../resolver_context.dart';
import '../resolver_effect.dart';
import '../resolver_target.dart';
import '../resolver_rule.dart';
import '../rule_category.dart';
import '../rule_risk_level.dart';

class OverwhelmNotificationRule extends ResolverRule {
  @override
  String get ruleId => 'RULE_OVERWHELM_NOTIFICATION';

  @override
  String get ruleName => 'Overwhelm Notification Rule';

  @override
  String get description => 'Suppresses non-urgent notifications during overwhelm states';

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
    if (context.notificationsSuppressed) {
      return ResolverEffect(
        decision: ResolverDecision.digest,
        showNotification: false,
        suppressSound: true,
        suppressVibration: true,
        digestOnly: true,
        reason: 'Notifications suppressed during overwhelm state.',
      );
    }

    return ResolverEffect.allow;
  }
}