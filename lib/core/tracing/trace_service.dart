import 'trace_context.dart';
import 'trace_id.dart';

class TraceService {
  static final TraceService _instance = TraceService._internal();
  factory TraceService() => _instance;
  TraceService._internal();

  TraceContext? _activeTrace;

  /// Begin a new trace for a decision cycle
  TraceContext beginTrace({String? stateRecordId}) {
    final trace = TraceContext(
      traceId: TraceId.generate(),
      stateRecordId: stateRecordId,
    );
    _activeTrace = trace;
    return trace;
  }

  /// Get the currently active trace, if any
  TraceContext? get activeTrace => _activeTrace;

  /// End the active trace
  void endTrace() {
    _activeTrace = null;
  }

  /// Generate a trace ID without starting a full trace context
  TraceId generateTraceId() => TraceId.generate();
}