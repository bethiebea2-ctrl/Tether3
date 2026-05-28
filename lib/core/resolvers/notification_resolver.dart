import '../models/resolver_result.dart';
import 'resolver_context.dart';
import 'resolver_engine.dart';
import 'resolver_target.dart';

class NotificationResolver {
  final ResolverEngine _engine;

  NotificationResolver({
    required ResolverEngine engine,
  }) : _engine = engine;

  ResolverResult resolveNotification({
    required ResolverContext context,
    required ResolverTarget target,
  }) {
    return _engine.resolve(context, target);
  }
}