import 'resolver_rule.dart';
import 'rules/low_energy_task_visibility_rule.dart';
import 'rules/overwhelm_notification_rule.dart';
import 'rules/digest_notification_rule.dart';
import 'rules/quiet_hours_rule.dart';
import 'rules/focus_mode_rule.dart';
import 'rules/critical_alert_rule.dart';
import 'rules/test_priority_rule.dart';
import 'rules/low_energy_dashboard_rule.dart';


class RuleRegistry {
    static final List<ResolverRule> rules = [
    CriticalAlertRule(),
    FocusModeRule(),
    QuietHoursRule(),
    OverwhelmNotificationRule(),
    LowEnergyDashboardRule(),
    LowEnergyTaskVisibilityRule(),
    DigestNotificationRule(),
  ];

  static void validate() {
    final ids = <String>{};

    for (final rule in rules) {
      if (ids.contains(rule.ruleId)) {
        throw Exception('Duplicate ruleId: ${rule.ruleId}');
      }
      ids.add(rule.ruleId);
    }
  }
}