import 'resolver_context.dart';
import 'resolver_effect.dart';
import 'resolver_target.dart';

abstract class ResolverRule {
  String get ruleId;
  String get ruleName;
  int get priority => 0;

  ResolverEffect evaluate(
    ResolverContext context,
    ResolverTarget target,
  );
}