import '../../enums/shared_enums.dart';
import '../resolver_context.dart';
import '../resolver_effect.dart';
import '../resolver_target.dart';
import '../resolver_rule.dart';
import '../rule_category.dart';
import '../rule_risk_level.dart';

class FocusModeRule extends ResolverRule {
  @override
  String get ruleId => 'focus_mode_rule';

  @override
  String get ruleName => 'Focus Mode Rule';

  @override
  String get description => 'Suppresses non-urgent notifications during focus mode';

  @override
  int get priority => 60;

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
    if (context.activeStateIds.contains('focusMode')) {
      return const ResolverEffect(
        decision: ResolverDecision.suppress,
        showNotification: false,
        suppressSound: true,
        suppressVibration: true,
        digestOnly: true,
        reason: 'Focus mode active — non-urgent notifications suppressed',
      );
    }

    return ResolverEffect.allow;
  }
}