import 'package:flutter_test/flutter_test.dart';
import 'package:beth_app/core/resolvers/rule_registry.dart';

void main() {
  group('Rule Governance', () {
    setUp(() {
      RuleRegistry.validate();
    });

    test('All rules have unique IDs', () {
      final ids = <String>{};
      for (final rule in RuleRegistry.rules) {
        expect(ids.contains(rule.ruleId), false,
            reason: 'Duplicate ruleId found: ${rule.ruleId}');
        ids.add(rule.ruleId);
      }
    });

    test('All rules have descriptions', () {
      for (final rule in RuleRegistry.rules) {
        expect(rule.description.isNotEmpty, true,
            reason: '${rule.ruleName} is missing a description');
      }
    });

    test('All rules declare affected targets', () {
      for (final rule in RuleRegistry.rules) {
        expect(rule.affectedTargets.isNotEmpty, true,
            reason: '${rule.ruleName} has no affected targets');
      }
    });

    test('All rules have valid priorities', () {
      for (final rule in RuleRegistry.rules) {
        expect(rule.priority, greaterThanOrEqualTo(0),
            reason: '${rule.ruleName} has invalid priority: ${rule.priority}');
      }
    });

    test('Rule registry contains no duplicates', () {
      final ids = <String>{};
      for (final rule in RuleRegistry.rules) {
        ids.add(rule.ruleId);
      }
      expect(ids.length, RuleRegistry.rules.length,
          reason: 'Registry contains duplicate rule IDs');
    });
  });
}