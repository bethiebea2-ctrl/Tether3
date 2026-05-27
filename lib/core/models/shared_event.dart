import '../enums/shared_enums.dart';

/// An event as seen by the resolver engine.
///
/// Lightweight, resolver-specific view of a calendar event.
/// Contains only the fields resolver rules need to evaluate:
/// priority, timing, sensitivity, and privacy scope.
class SharedEvent {
  final String id;
  final String title;
  final String? description;

  final DateTime startTime;
  final DateTime endTime;

  final EventPriority priority;

  final SensitivityLevel sensitivityLevel;
  final PrivacyScope privacyScope;

  final String? sourceModule;

  const SharedEvent({
    required this.id,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    required this.priority,
    required this.sensitivityLevel,
    required this.privacyScope,
    this.sourceModule,
  });
}