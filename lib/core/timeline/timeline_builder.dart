import '../history/orchestration_event_record.dart';
import 'timeline_entry.dart';

class TimelineBuilder {
  static List<TimelineEntry> build(List<OrchestrationEventRecord> events) {
    return events.map((event) {
      return TimelineEntry(
        title: event.eventType,
        description: '${event.originModule} → ${event.payload}',
        timestamp: DateTime.tryParse(event.timestamp) ?? DateTime.now(),
      );
    }).toList();
  }
}