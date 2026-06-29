class TraceId {
  final String id;
  final DateTime createdAt;

  const TraceId._({
    required this.id,
    required this.createdAt,
  });

  /// Creates a new trace ID with format TRACE-YYYY-XXXXXXXX
  factory TraceId.generate() {
    final now = DateTime.now();
    final year = now.year;
    final counter = now.microsecondsSinceEpoch.remainder(100000000).toString().padLeft(8, '0');
    return TraceId._(
      id: 'TRACE-$year-$counter',
      createdAt: now,
    );
  }

  /// Creates a TraceId from an existing ID string
  factory TraceId.fromString(String id) {
    return TraceId._(
      id: id,
      createdAt: DateTime.now(),
    );
  }

  @override
  String toString() => id;

  @override
  bool operator ==(Object other) =>
      other is TraceId && other.id == id;

  @override
  int get hashCode => id.hashCode;
}