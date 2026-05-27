/// Something a resolver rule operates on.
///
/// A target can be a task, event, notification, or anything else
/// that needs to pass through the resolver engine before being
/// displayed to the user.
abstract class ResolverTarget {
  final String id;

  const ResolverTarget({
    required this.id,
  });
}