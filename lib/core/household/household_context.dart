/// Active household id for new records (Phase 2A).
/// Legacy rows may still use `default` until cloud sync migration.
class HouseholdContext {
  HouseholdContext._();

  static String _householdId = 'default';

  static String get householdId => _householdId;

  static void setHouseholdId(String id) {
    if (id.isEmpty) return;
    _householdId = id;
  }

  static void reset() {
    _householdId = 'default';
  }
}
