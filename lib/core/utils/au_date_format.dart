import 'package:intl/intl.dart';

/// Australian date display: DD/MM/YYYY.
final _auDate = DateFormat('dd/MM/yyyy');

String formatAuDate(DateTime date) => _auDate.format(date);

/// Parse DD/MM/YYYY (also accepts D/M/YYYY). Returns null if invalid.
DateTime? parseAuDate(String raw) {
  final t = raw.trim();
  if (t.isEmpty) return null;
  try {
    return _auDate.parseStrict(t);
  } catch (_) {}
  final parts = t.split(RegExp(r'[/\-.]'));
  if (parts.length != 3) return null;
  final d = int.tryParse(parts[0]);
  final m = int.tryParse(parts[1]);
  final y = int.tryParse(parts[2]);
  if (d == null || m == null || y == null) return null;
  if (y < 100 || m < 1 || m > 12 || d < 1 || d > 31) return null;
  try {
    return DateTime(y, m, d);
  } catch (_) {
    return null;
  }
}
