/// A raw capture entry — always preserved in its original form.
///
/// Captures are the primary input to the Tether pipeline.
/// They are classified by Rhen and may produce tasks, events,
/// shopping items, or other outputs. The original text is never modified.
class CaptureEntry {
  final String id;
  final String userId;
  final String rawText;
  final String inputType; // text, voice, image, file
  final String? audioFileUrl;
  final String? imageFileUrl;
  final String sensitivityLevel; // d1, d2, d3, d4
  final String privacyScope; // private, household, selected_persons
  final DateTime createdAt;

  const CaptureEntry({
    required this.id,
    required this.userId,
    required this.rawText,
    this.inputType = 'text',
    this.audioFileUrl,
    this.imageFileUrl,
    this.sensitivityLevel = 'd2',
    this.privacyScope = 'private',
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'raw_text': rawText,
        'input_type': inputType,
        'audio_file_url': audioFileUrl,
        'image_file_url': imageFileUrl,
        'sensitivity_level': sensitivityLevel,
        'privacy_scope': privacyScope,
        'created_at': createdAt.toIso8601String(),
      };

  factory CaptureEntry.fromMap(Map<String, dynamic> map) => CaptureEntry(
        id: map['id'],
        userId: map['user_id'],
        rawText: map['raw_text'],
        inputType: map['input_type'] ?? 'text',
        audioFileUrl: map['audio_file_url'],
        imageFileUrl: map['image_file_url'],
        sensitivityLevel: map['sensitivity_level'] ?? 'd2',
        privacyScope: map['privacy_scope'] ?? 'private',
        createdAt: DateTime.parse(map['created_at']),
      );
}

/// How Rhen classified a capture entry.
class CaptureClassification {
  final String id;
  final String captureId;
  final String category; // task, calendar, shopping, health, family, budget, idea, correspondence, unsorted
  final String? subCategory;
  final double confidence; // 0.0–1.0
  final String instanceUsed; // which AI instance classified it
  final bool reviewedByUser;
  final String? userModifiedCategory;
  final DateTime createdAt;

  const CaptureClassification({
    required this.id,
    required this.captureId,
    required this.category,
    this.subCategory,
    this.confidence = 0.0,
    this.instanceUsed = 'rhen',
    this.reviewedByUser = false,
    this.userModifiedCategory,
    required this.createdAt,
  });
}

/// What was created from a capture.
class CaptureOutput {
  final String id;
  final String captureId;
  final String outputType; // task, event, note, shopping_item, draft, health_entry, medication_entry
  final String linkedEntityId; // ID in the target table
  final DateTime createdAt;

  const CaptureOutput({
    required this.id,
    required this.captureId,
    required this.outputType,
    required this.linkedEntityId,
    required this.createdAt,
  });
}