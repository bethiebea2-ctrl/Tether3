import 'package:flutter_test/flutter_test.dart';
import 'package:beth_app/core/utils/au_date_format.dart';

void main() {
  group('parseAuDate', () {
    test('parses DD/MM/YYYY', () {
      final d = parseAuDate('15/03/2020');
      expect(d, DateTime(2020, 3, 15));
    });

    test('parses D/M/YYYY', () {
      final d = parseAuDate('5/3/2020');
      expect(d, DateTime(2020, 3, 5));
    });

    test('parses compact DDMMYYYY', () {
      final d = parseAuDate('15032020');
      expect(d, DateTime(2020, 3, 15));
    });

    test('rejects US order MM/DD/YYYY when month > 12', () {
      expect(parseAuDate('03/15/2020'), isNull);
    });
  });

  group('dateOnly storage', () {
    test('round trip', () {
      final d = DateTime(2020, 3, 15);
      expect(parseStoredDate(toStoredDate(d)), d);
    });
  });
}
