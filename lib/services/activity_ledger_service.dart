import 'package:uuid/uuid.dart';
import '../core/household/household_context.dart';
import '../database/activity_ledger_dao.dart';

class ActivityLedgerService {
  ActivityLedgerService._();
  static final ActivityLedgerService instance = ActivityLedgerService._();

  final ActivityLedgerDao _dao = ActivityLedgerDao();
  final _uuid = const Uuid();

  Future<void> log({
    required String action,
    String? actorLabel,
    String? userId,
    String? householdId,
    String? detail,
    String? dataUsed,
    String? sharedWith,
  }) async {
    try {
      await _dao.insert(
        ActivityLedgerEntry(
          id: _uuid.v4(),
          userId: userId,
          householdId: householdId ?? HouseholdContext.householdId,
          actorLabel: actorLabel ?? 'You',
          action: action,
          detail: detail,
          dataUsed: dataUsed,
          sharedWith: sharedWith,
          createdAt: DateTime.now(),
        ),
      );
    } catch (e) {
      // ignore: avoid_print
      print('Activity ledger log skipped: $e');
    }
  }

  Future<List<ActivityLedgerEntry>> recent({int limit = 80}) =>
      _dao.recent(limit: limit);
}
