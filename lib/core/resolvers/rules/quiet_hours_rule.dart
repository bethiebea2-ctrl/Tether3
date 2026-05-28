import '../../enums/shared_enums.dart';
import '../resolver_context.dart';
import '../resolver_effect.dart';
import '../resolver_rule.dart';
import '../resolver_target.dart';

class QuietHoursRule extends ResolverRule {
  @override
  String get ruleId => 'quiet_hours_rule';

  @override
  String get ruleName => 'Quiet Hours Rule';

  @override
  int get priority => 50;

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