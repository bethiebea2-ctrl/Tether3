import 'resolver_target.dart';

class NotificationResolverTarget extends ResolverTarget {
  final String urgency; // urgent, normal, low

  const NotificationResolverTarget({
    required super.id,
    this.urgency = 'normal',
  });
}
