import 'package:flutter_test/flutter_test.dart';
import 'package:beth_app/core/state/events/state_activated_event.dart';
import 'package:beth_app/core/state/events/state_cleared_event.dart';

void main() {
  group('State Events', () {
    test('StateActivatedEvent constructs correctly', () {
      final event = StateActivatedEvent(stateName: 'low_energy');

      expect(event.stateName, 'low_energy');
      expect(event.eventType, 'state_activated');
      expect(event.originModule, 'state_engine');
      expect(event.timestamp, isNotNull);
    });

    test('StateClearedEvent constructs correctly', () {
      final event = StateClearedEvent(stateName: 'overwhelmed');

      expect(event.stateName, 'overwhelmed');
      expect(event.eventType, 'state_cleared');
      expect(event.originModule, 'state_engine');
      expect(event.timestamp, isNotNull);
    });

    test('StateActivatedEvent timestamps are unique', () {
      final event1 = StateActivatedEvent(stateName: 'low_energy');
      final event2 = StateActivatedEvent(stateName: 'low_energy');

      expect(event1.timestamp, isNot(event2.timestamp));
    });
  });
}