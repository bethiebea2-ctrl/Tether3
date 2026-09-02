import 'package:flutter_test/flutter_test.dart';
import 'package:beth_app/core/support/sensitivity_toggle_catalog.dart';

void main() {
  test('sensitivity toggle catalog is populated', () {
    expect(sensitivityToggleCatalog, isNotEmpty);
    expect(sensitivityToggleById('reduce_notifications'), isNotNull);
    expect(sensitivityToggleById('shame_free_language'), isNotNull);
  });
}
