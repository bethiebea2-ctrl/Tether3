import 'resolver_context.dart';
import 'resolver_effect.dart';
import 'resolver_engine.dart';
import 'resolver_target.dart';

/// The notification-specific resolver.
///
/// This wraps the ResolverEngine and is the entry point
/// for all notification-related resolution. Any module that
/// wants to show a notification passes through here first.
class NotificationResolver {
  final ResolverEngine _engine;

  NotificationResolver({
    required ResolverEngine engine,
  }) : _engine = engine;

  /// Resolve whether a notification should be shown for the given target.
  ResolverEffect resolveNotification({
    required ResolverContext context,
    required ResolverTarget target,
  }) {
    return _engine.resolve(context, target);
  }
}