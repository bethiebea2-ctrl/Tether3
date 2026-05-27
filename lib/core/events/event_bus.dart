import 'dart:async';
import 'app_event.dart';

/// Simple publish/subscribe event bus.
///
/// Modules can emit events when things happen (task created,
/// calendar updated, capture classified) and other modules
/// can listen for those events without direct coupling.
///
/// Usage:
///   EventBus().emit(TaskCreatedEvent(taskId: '123'));
///   EventBus().stream.listen((event) { ... });
class EventBus {
  static final EventBus _instance = EventBus._internal();
  factory EventBus() => _instance;
  EventBus._internal();

  final StreamController<AppEvent> _controller =
      StreamController<AppEvent>.broadcast();

  /// Stream of all events. Listen to this to react to changes.
  Stream<AppEvent> get stream => _controller.stream;

  /// Emit an event to all listeners.
  void emit(AppEvent event) {
    _controller.add(event);
  }

  /// Clean up the stream controller.
  void dispose() {
    _controller.close();
  }
}