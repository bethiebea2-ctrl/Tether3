import '../history/orchestration_event_record.dart';

class ReplayEngine {
  static const int _maxReplayAgeDays = 90;

  /// Replays events that pass safety gates:
  /// - Event must be marked replayable
  /// - Event must not be older than 90 days
  /// Returns formatted replay lines for valid events only.
  List<String> replay(List<OrchestrationEventRecord> events) {
    final now = DateTime.now();
    final cutoff = now.subtract(Duration(days: _maxReplayAgeDays));

    return events.where((event) {
      // Safety gate 1: Must be marked replayable
      if (!event.replayable) return false;

      // Safety gate 2: Must not be older than 90 days
      final eventDate = DateTime.tryParse(event.timestamp);
      if (eventDate == null) return false;
      if (eventDate.isBefore(cutoff)) return false;

      return true;
    }).map((event) {
      return 'REPLAY: ${event.eventType} — ${event.originModule} at ${event.timestamp}';
    }).toList();
  }
}