import 'trace_id.dart';

class TraceContext {
  final TraceId traceId;
  final List<String> eventIds;
  final List<String> decisionIds;
  final String? stateRecordId;

  const TraceContext({
    required this.traceId,
    this.eventIds = const [],
    this.decisionIds = const [],
    this.stateRecordId,
  });

  TraceContext copyWith({
    TraceId? traceId,
    List<String>? eventIds,
    List<String>? decisionIds,
    String? stateRecordId,
  }) {
    return TraceContext(
      traceId: traceId ?? this.traceId,
      eventIds: eventIds ?? this.eventIds,
      decisionIds: decisionIds ?? this.decisionIds,
      stateRecordId: stateRecordId ?? this.stateRecordId,
    );
  }

  TraceContext addEvent(String eventId) {
    return copyWith(eventIds: [...eventIds, eventId]);
  }

  TraceContext addDecision(String decisionId) {
    return copyWith(decisionIds: [...decisionIds, decisionId]);
  }
}