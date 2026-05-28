import '../../enums/shared_enums.dart';
import '../resolver_context.dart';
import '../resolver_effect.dart';
import '../resolver_rule.dart';
import '../resolver_target.dart';

class FocusModeRule extends ResolverRule {
  @override
  String get ruleId => 'focus_mode_rule';

  @override
  String get ruleName => 'Focus Mode Rule';

  @override
  int get priority => 60;

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