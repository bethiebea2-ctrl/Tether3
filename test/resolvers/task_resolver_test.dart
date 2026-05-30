import 'package:flutter_test/flutter_test.dart';
import 'package:beth_app/core/enums/shared_enums.dart';
import 'package:beth_app/core/resolvers/resolver_context.dart';
import 'package:beth_app/core/resolvers/resolver_engine.dart';
import 'package:beth_app/core/resolvers/resolver_target.dart';
import 'package:beth_app/core/resolvers/rules/low_energy_task_visibility_rule.dart';

class _TestTarget extends ResolverTarget {
  const _TestTarget() : super(id: 'test_task');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Task Resolver', () {
    late ResolverEngine engine;

    setUp(() {
      engine = ResolverEngine(
        rules: [LowEnergyTaskVisibilityRule()],
      );
    });

    test('high-energy tasks hidden during low-energy state', () {
      final context = ResolverContext(
        activeStateIds: ['low_energy'],
        currentTime: DateTime.now(),
      );
      final target = const _TestTarget();
      final result = engine.resolve(context, target);

      expect(result.effect.decision, ResolverDecision.suppress);
      expect(result.winningRule!.ruleId, 'low_energy_task_visibility_rule');
    });

    test('all tasks visible when no low-energy state', () {
      final context = ResolverContext(
        activeStateIds: [],
        currentTime: DateTime.now(),
      );
      final target = const _TestTarget();
      final result = engine.resolve(context, target);

      expect(result.effect.decision, ResolverDecision.allow);
    });

    test('sleep_deprived state also triggers suppression', () {
      final context = ResolverContext(
        activeStateIds: ['sleep_deprived'],
        currentTime: DateTime.now(),
      );
      final target = const _TestTarget();
      final result = engine.resolve(context, target);

      expect(result.effect.decision, ResolverDecision.suppress);
      expect(result.winningRule!.ruleId, 'low_energy_task_visibility_rule');
    });

    test('flare_day state also triggers suppression', () {
      final context = ResolverContext(
        activeStateIds: ['flare_day'],
        currentTime: DateTime.now(),
      );
      final target = const _TestTarget();
      final result = engine.resolve(context, target);

      expect(result.effect.decision, ResolverDecision.suppress);
    });

    test('deterministic output under task resolver', () {
      final context = ResolverContext(
        activeStateIds: ['low_energy'],
        currentTime: DateTime.now(),
      );
      final target = const _TestTarget();

      final r1 = engine.resolve(context, target);
      final r2 = engine.resolve(context, target);
      final r3 = engine.resolve(context, target);

      expect(r1.effect.decision, r2.effect.decision);
      expect(r2.effect.decision, r3.effect.decision);
    });

    test('traces generated for task visibility decisions', () {
      final context = ResolverContext(
        activeStateIds: ['low_energy'],
        currentTime: DateTime.now(),
      );
      final target = const _TestTarget();
      final result = engine.resolve(context, target);

      expect(result.traces.isNotEmpty, true);
      expect(result.winningRule, isNotNull);
    });
  });
}