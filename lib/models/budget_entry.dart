class Message {
  final String id;
  final String instanceId;
  final String content;
  final String role; // user, assistant, system
  final DateTime timestamp;
  final String? metadata; // JSON string for additional context

  Message({
    required this.id,
    required this.instanceId,
    required this.content,
    required this.role,
    required this.timestamp,
    this.metadata,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'instance_id': instanceId,
    'content': content,
    'role': role,
    'timestamp': timestamp.toIso8601String(),
    'metadata': metadata,
  };

  factory Message.fromMap(Map<String, dynamic> map) => Message(
    id: map['id'],
    instanceId: map['instance_id'],
    content: map['content'],
    role: map['role'],
    timestamp: DateTime.parse(map['timestamp']),
    metadata: map['metadata'],
  );

  Map<String, String> toApiFormat() => {
    'role': role,
    'content': content,
  };
}