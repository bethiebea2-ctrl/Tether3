import '../../enums/shared_enums.dart';
import '../resolver_context.dart';
import '../resolver_effect.dart';
import '../resolver_rule.dart';
import '../resolver_target.dart';

class TestPriorityRule extends ResolverRule {
  @override
  String get ruleId => 'RULE_TEST_PRIORITY';

  @override
  String get ruleName => 'Test Priority Rule';

  @override
  int get priority => 100;

  @override
  ResolverEffect evaluate(
    ResolverContext context,
    ResolverTarget target,
  ) {
    return const ResolverEffect(
      decision: ResolverDecision.digest,
      showNotification: false,
      suppressSound: true,
      suppressVibration: true,
      digestOnly: true,
      reason: 'Test priority rule — always suppresses.',
    );
  }
}