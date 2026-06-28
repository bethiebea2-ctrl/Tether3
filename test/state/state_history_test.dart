import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beth_app/core/state/state_history_service.dart';
import 'package:beth_app/core/state/models/state_record.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('State History', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('StateRecord serializes correctly', () {
      final record = StateRecord(
        stateId: 'state_1',
        stateName: 'low_energy',
        status: 'activated',
        timestamp: '2026-06-02T10:00:00.000',
        sessionId: 'session_1',
        originEventId: 'evt_001',
      );

      final json = record.toJson();

      expect(json['stateId'], 'state_1');
      expect(json['stateName'], 'low_energy');
      expect(json['status'], 'activated');
      expect(json['timestamp'], '2026-06-02T10:00:00.000');
      expect(json['sessionId'], 'session_1');
      expect(json['originEventId'], 'evt_001');
    });

    test('StateRecord fromJson deserializes correctly', () {
      final json = {
        'stateId': 'state_2',
        'stateName': 'overwhelmed',
        'status': 'cleared',
        'timestamp': '2026-06-02T11:00:00.000',
        'sessionId': 'session_2',
        'originEventId': null,
      };

      final record = StateRecord.fromJson(json);

      expect(record.stateId, 'state_2');
      expect(record.stateName, 'overwhelmed');
      expect(record.status, 'cleared');
      expect(record.timestamp, '2026-06-02T11:00:00.000');
      expect(record.sessionId, 'session_2');
      expect(record.originEventId, null);
    });

    test('StateHistoryService saves and loads states', () async {
      final service = StateHistoryService();

      await service.saveState(StateRecord(
        stateId: 'state_3',
        stateName: 'focus_mode',
        status: 'activated',
        timestamp: '2026-06-02T09:00:00.000',
        sessionId: 'session_1',
      ));

      await service.saveState(StateRecord(
        stateId: 'state_4',
        stateName: 'focus_mode',
        status: 'cleared',
        timestamp: '2026-06-02T12:00:00.000',
        sessionId: 'session_1',
      ));

      final states = await service.loadStates();

      expect(states.length, 2);
      expect(states[0].stateName, 'focus_mode');
      expect(states[0].status, 'activated');
      expect(states[1].stateName, 'focus_mode');
      expect(states[1].status, 'cleared');
    });
  });
}