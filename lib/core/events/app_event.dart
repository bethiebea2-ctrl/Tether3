/// Base class for all application events.
///
/// Every event in Tether extends this class.
/// Events are passed through the EventBus to notify
/// modules of changes without tight coupling.
abstract class AppEvent {
  /// When the event occurred
  final DateTime timestamp;

  const AppEvent({
    required this.timestamp,
  });
}