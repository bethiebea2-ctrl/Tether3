import 'dart:async';
import 'app_event.dart';
import 'interfaces/i_event_bus.dart';

/// Simple publish/subscribe event bus.
///
/// Modules can emit events when things happen (task created,
/// calendar updated, capture classified) and other modules
/// can listen for those events without direct coupling.
///
/// Usage:
///   EventBus().emit(TaskCreatedEvent(taskId: '123'));
///   EventBus().stream.listen((event) { ... });


class EventBus implements IEventBus {
  static final EventBus _instance = EventBus._internal();
  factory EventBus() => _instance;
  EventBus._internal();

  @override
  Stream<T> on<T>() {
    return stream.where((event) => event is T).cast<T>();
  }

  final StreamController<AppEvent> _controller =
      StreamController<AppEvent>.broadcast();

  /// Stream of all events. Listen to this to react to changes.
  Stream<AppEvent> get stream => _controller.stream;

  /// Emit an event to all listeners.
  @override
  void emit(dynamic event) {
    _controller.add(event);
  }

  /// Clean up the stream controller.
  void dispose() {
    _controller.close();
  }
}