import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PerformanceSnapshot {
  final String metricName;
  final int valueMs;
  final String timestamp;

  const PerformanceSnapshot({
    required this.metricName,
    required this.valueMs,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'metricName': metricName,
        'valueMs': valueMs,
        'timestamp': timestamp,
      };

  factory PerformanceSnapshot.fromJson(Map<String, dynamic> json) {
    return PerformanceSnapshot(
      metricName: json['metricName'] ?? '',
      valueMs: json['valueMs'] ?? 0,
      timestamp: json['timestamp'] ?? '',
    );
  }
}

class PerformanceSummary {
  final String metricName;
  final double averageMs;
  final int minMs;
  final int maxMs;
  final int sampleCount;

  const PerformanceSummary({
    required this.metricName,
    required this.averageMs,
    required this.minMs,
    required this.maxMs,
    required this.sampleCount,
  });
}

class PerformanceMetricsService {
  static const _key = 'performance_metrics';

  Future<void> record(String metricName, int durationMs) async {
    final snapshot = PerformanceSnapshot(
      metricName: metricName,
      valueMs: durationMs,
      timestamp: DateTime.now().toIso8601String(),
    );

    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_key) ?? [];
    existing.add(jsonEncode(snapshot.toJson()));

    // Keep only last 1000 entries to prevent unbounded growth
    if (existing.length > 1000) {
      existing.removeAt(0);
    }

    await prefs.setStringList(_key, existing);
  }

  Future<List<PerformanceSnapshot>> loadMetrics() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key) ?? [];
    return data
        .map((e) => PerformanceSnapshot.fromJson(jsonDecode(e)))
        .toList();
  }

  Future<List<PerformanceSummary>> summarize() async {
    final metrics = await loadMetrics();
    final grouped = <String, List<int>>{};

    for (final m in metrics) {
      grouped.putIfAbsent(m.metricName, () => []);
      grouped[m.metricName]!.add(m.valueMs);
    }

    return grouped.entries.map((entry) {
      final values = entry.value;
      values.sort();
      return PerformanceSummary(
        metricName: entry.key,
        averageMs: values.reduce((a, b) => a + b) / values.length,
        minMs: values.first,
        maxMs: values.last,
        sampleCount: values.length,
      );
    }).toList();
  }
}