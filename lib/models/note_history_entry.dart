/// Persisted capture / note sent through the Rhen pipeline.
class NoteHistoryEntry {
  final String id;
  final String rawText;
  final String inputType;
  final String? pipelineStatus;
  final String? responseText;
  final String? category;
  final String? priority;
  final String? emotionalSignal;
  final String? clarifyThreadJson;
  final DateTime createdAt;
  final DateTime updatedAt;

  const NoteHistoryEntry({
    required this.id,
    required this.rawText,
    this.inputType = 'text',
    this.pipelineStatus,
    this.responseText,
    this.category,
    this.priority,
    this.emotionalSignal,
    this.clarifyThreadJson,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'raw_text': rawText,
        'input_type': inputType,
        'pipeline_status': pipelineStatus,
        'response_text': responseText,
        'category': category,
        'priority': priority,
        'emotional_signal': emotionalSignal,
        'clarify_thread': clarifyThreadJson,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  factory NoteHistoryEntry.fromMap(Map<String, dynamic> map) => NoteHistoryEntry(
        id: map['id'] as String,
        rawText: map['raw_text'] as String,
        inputType: map['input_type'] as String? ?? 'text',
        pipelineStatus: map['pipeline_status'] as String?,
        responseText: map['response_text'] as String?,
        category: map['category'] as String?,
        priority: map['priority'] as String?,
        emotionalSignal: map['emotional_signal'] as String?,
        clarifyThreadJson: map['clarify_thread'] as String?,
        createdAt: DateTime.parse(map['created_at'] as String),
        updatedAt: DateTime.parse(map['updated_at'] as String),
      );
}
