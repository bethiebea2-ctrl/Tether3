import 'state_priority.dart';

/// Resolves conflicts between multiple state sources.
///
/// When a toggle is set by both a Support Preset and a Current State,
/// this determines which one wins. Higher priority beats lower priority.
///
/// Manual user override always wins.
/// Current State beats Support Preset.
/// Support Preset beats system default.
class PriorityResolver {
  /// Given a list of priorities, return the highest one.
  /// If the list is empty, returns systemDefault.
  static StatePriority resolveHighest(List<StatePriority> priorities) {
    if (priorities.isEmpty) return StatePriority.systemDefault;

    priorities.sort((a, b) => b.index.compareTo(a.index));
    return priorities.first;
  }

  /// Does the given priority beat the current one?
  static bool beats(StatePriority challenger, StatePriority current) {
    return challenger.index > current.index;
  }
}