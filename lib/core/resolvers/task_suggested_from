import '../../events/app_event.dart';

class TaskSuggestedFromCaptureEvent extends AppEvent {
  final String captureId;
  final String suggestedTitle;
  final String? category;

  const TaskSuggestedFromCaptureEvent({
    required this.captureId,
    required this.suggestedTitle,
    this.category,
    required super.timestamp,
  });
}