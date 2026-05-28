import '../../enums/shared_enums.dart';
import '../resolver_context.dart';
import '../resolver_effect.dart';
import '../resolver_rule.dart';
import '../resolver_target.dart';

class DigestNotificationRule extends ResolverRule {
  @override
  String get ruleId => 'digest_notification_rule';

  @override
  String get ruleName => 'Digest Notification Rule';

  @override
  int get priority => 40;

  @override
  ResolverEffect evaluate(
    ResolverContext context,
    ResolverTarget target,
  ) {
    if (context.activeToggleIds.contains('digestOnly')) {
      return const ResolverEffect(
        decision: ResolverDecision.digest,
        showNotification: false,
        suppressSound: true,
        suppressVibration: true,
        digestOnly: true,
        reason: 'Digest mode enabled',
      );
    }

    return ResolverEffect.allow;
  }
}