abstract class IEventBus {
  void emit(dynamic event);
  Stream<T> on<T>();
}