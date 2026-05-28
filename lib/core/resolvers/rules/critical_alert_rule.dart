import '../../enums/shared_enums.dart';
import '../resolver_context.dart';
import '../resolver_effect.dart';
import '../resolver_rule.dart';
import '../resolver_target.dart';

class CriticalAlertRule extends ResolverRule {
  @override
  String get ruleId => 'critical_alert_rule';

  @override
  String get ruleName => 'Critical Alert Rule';

  @override
  int get priority => 100;

  @override
  ResolverEffect evaluate(
    ResolverContext context,
    ResolverTarget target,
  ) {
    // Critical alerts always bypass suppression
    // In a real implementation, this would check target metadata
    return ResolverEffect.allow;
  }
}