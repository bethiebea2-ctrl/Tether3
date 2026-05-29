import 'package:uuid/uuid.dart';

class OrchestrationSession {
  final String sessionId;
  final DateTime startedAt;

  OrchestrationSession()
      : sessionId = const Uuid().v4(),
        startedAt = DateTime.now();
}