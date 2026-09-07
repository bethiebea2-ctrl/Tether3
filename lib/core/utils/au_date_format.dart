import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Australian date display: DD/MM/YYYY.
final _auDate = DateFormat('dd/MM/yyyy');

const auLocale = Locale('en', 'AU');

String formatAuDate(DateTime date) => _auDate.format(date);

/// Store as yyyy-MM-dd (no timezone shift on web).
String? toStoredDate(DateTime? date) {
  if (date == null) return null;
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

DateTime? parseStoredDate(String? raw) {
  if (raw == null) return null;
  final s = raw.trim();
  if (s.isEmpty) return null;
  final m = RegExp(r'^(\d{4})-(\d{2})-(\d{2})').firstMatch(s);
  if (m != null) {
    return DateTime(
      int.parse(m.group(1)!),
      int.parse(m.group(2)!),
      int.parse(m.group(3)!),
    );
  }
  final parsed = DateTime.tryParse(s);
  if (parsed == null) return null;
  return DateTime(parsed.year, parsed.month, parsed.day);
}

/// Date picker using Australian DD/MM/YYYY (calendar + typed input).
Future<DateTime?> showAuDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
  String? helpText,
}) {
  return showDatePicker(
    context: context,
    locale: auLocale,
    // Calendar only — no pencil/input toggle (that mode uses US MM/DD/YYYY on web).
    // Users type DD/MM/YYYY in [AuDateInput] instead.
    initialEntryMode: DatePickerEntryMode.calendarOnly,
    builder: (context, child) {
      return Localizations.override(
        context: context,
        locale: auLocale,
        child: child ?? const SizedBox.shrink(),
      );
    },
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    helpText: helpText ?? 'Select date (DD/MM/YYYY)',
    fieldHintText: 'DD/MM/YYYY',
    fieldLabelText: 'DD/MM/YYYY',
  );
}

/// Parse DD/MM/YYYY (also accepts D/M/YYYY, dashes/dots). Returns null if invalid.
DateTime? parseAuDate(String raw) {
  final t = raw.trim();
  if (t.isEmpty) return null;
  try {
    return _auDate.parseStrict(t);
  } catch (_) {}
  final parts = t.split(RegExp(r'[/\-.]'));
  if (parts.length == 3) {
    final d = int.tryParse(parts[0].trim());
    final m = int.tryParse(parts[1].trim());
    var y = int.tryParse(parts[2].trim());
    if (d != null && m != null && y != null) {
      final dt = _dateFromParts(d, m, y);
      if (dt != null) return dt;
    }
  }
  // Compact digits: DDMMYYYY
  final digits = t.replaceAll(RegExp(r'\D'), '');
  if (digits.length == 8) {
    final d = int.tryParse(digits.substring(0, 2));
    final m = int.tryParse(digits.substring(2, 4));
    final y = int.tryParse(digits.substring(4, 8));
    if (d != null && m != null && y != null) {
      final dt = _dateFromParts(d, m, y);
      if (dt != null) return dt;
    }
  }
  return null;
}

bool _isValidCalendarDate(int year, int month, int day) {
  if (month < 1 || month > 12 || day < 1) return false;
  try {
    final dt = DateTime(year, month, day);
    return dt.year == year && dt.month == month && dt.day == day;
  } catch (_) {
    return false;
  }
}

DateTime? _dateFromParts(int day, int month, int year) {
  if (year >= 0 && year < 100) year += year >= 50 ? 1900 : 2000;
  if (!_isValidCalendarDate(year, month, day)) return null;
  return DateTime(year, month, day);
}
