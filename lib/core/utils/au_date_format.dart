import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Australian date display: DD/MM/YYYY.
final _auDate = DateFormat('dd/MM/yyyy');

const auLocale = Locale('en', 'AU');

String formatAuDate(DateTime date) => _auDate.format(date);

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
      if (y >= 0 && y < 100) y += y >= 50 ? 1900 : 2000;
      if (y >= 100 && m >= 1 && m <= 12 && d >= 1 && d <= 31) {
        try {
          return DateTime(y, m, d);
        } catch (_) {}
      }
    }
  }
  // Compact digits: DDMMYYYY or DMMYYYY
  final digits = t.replaceAll(RegExp(r'\D'), '');
  if (digits.length == 8) {
    final d = int.tryParse(digits.substring(0, 2));
    final m = int.tryParse(digits.substring(2, 4));
    final y = int.tryParse(digits.substring(4, 8));
    if (d != null && m != null && y != null) {
      try {
        return DateTime(y, m, d);
      } catch (_) {}
    }
  }
  return null;
}
