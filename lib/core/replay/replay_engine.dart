import '../history/orchestration_event_record.dart';

class ReplayEngine {
  List<String> replay(List<OrchestrationEventRecord> events) {
    return events.map((event) {
      return 'REPLAY: ${event.eventType} — ${event.originModule} at ${event.timestamp}';
    }).toList();
  }
}