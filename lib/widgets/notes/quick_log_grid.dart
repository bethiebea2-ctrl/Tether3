import 'package:flutter/material.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';

class QuickLogAction {
  final String id;
  final String label;
  final String emoji;
  final String pipelineHint;

  const QuickLogAction({
    required this.id,
    required this.label,
    required this.emoji,
    required this.pipelineHint,
  });
}

List<QuickLogAction> quickLogActionsForContext({
  String? ageStage,
  bool overwhelmed = false,
}) {
  if (overwhelmed) {
    return const [
      QuickLogAction(id: 'meds', label: 'Meds', emoji: '💊', pipelineHint: 'Log medication'),
      QuickLogAction(id: 'task', label: 'Task', emoji: '✅', pipelineHint: 'Add a task'),
      QuickLogAction(id: 'note', label: 'Note', emoji: '📝', pipelineHint: 'Save a note'),
    ];
  }

  switch (ageStage) {
    case 'baby':
    case 'toddler':
      return const [
        QuickLogAction(id: 'feed', label: 'Feed', emoji: '🍼', pipelineHint: 'Log feed'),
        QuickLogAction(id: 'meds', label: 'Meds', emoji: '💊', pipelineHint: 'Log medication'),
        QuickLogAction(id: 'nap', label: 'Nap', emoji: '😴', pipelineHint: 'Log nap'),
        QuickLogAction(id: 'nappy', label: 'Nappy', emoji: '🧷', pipelineHint: 'Log nappy'),
        QuickLogAction(id: 'bath', label: 'Bath', emoji: '🛁', pipelineHint: 'Log bath'),
        QuickLogAction(id: 'tummy', label: 'Tummy', emoji: '🏃', pipelineHint: 'Log tummy time'),
        QuickLogAction(id: 'note', label: 'Note', emoji: '📝', pipelineHint: 'Save a note'),
        QuickLogAction(id: 'event', label: 'Event', emoji: '📅', pipelineHint: 'Add an event'),
        QuickLogAction(id: 'more', label: 'More', emoji: '⋯', pipelineHint: 'General note'),
      ];
    case 'child':
      return const [
        QuickLogAction(id: 'chore', label: 'Chore', emoji: '✅', pipelineHint: 'Add a chore'),
        QuickLogAction(id: 'school', label: 'School', emoji: '📅', pipelineHint: 'Add school event'),
        QuickLogAction(id: 'meds', label: 'Meds', emoji: '💊', pipelineHint: 'Log medication'),
        QuickLogAction(id: 'checkin', label: 'Check-in', emoji: '💬', pipelineHint: 'Log check-in'),
        QuickLogAction(id: 'note', label: 'Note', emoji: '📝', pipelineHint: 'Save a note'),
        QuickLogAction(id: 'homework', label: 'Homework', emoji: '🏫', pipelineHint: 'Log homework'),
        QuickLogAction(id: 'more', label: 'More', emoji: '⋯', pipelineHint: 'General note'),
      ];
    case 'teen':
      return const [
        QuickLogAction(id: 'event', label: 'Event', emoji: '📅', pipelineHint: 'Add an event'),
        QuickLogAction(id: 'meds', label: 'Meds', emoji: '💊', pipelineHint: 'Log medication'),
        QuickLogAction(id: 'checkin', label: 'Check-in', emoji: '💬', pipelineHint: 'Log check-in'),
        QuickLogAction(id: 'chore', label: 'Chore', emoji: '✅', pipelineHint: 'Add a chore'),
        QuickLogAction(id: 'note', label: 'Note', emoji: '📝', pipelineHint: 'Save a note'),
        QuickLogAction(id: 'school', label: 'School', emoji: '🏫', pipelineHint: 'School note'),
        QuickLogAction(id: 'more', label: 'More', emoji: '⋯', pipelineHint: 'General note'),
      ];
    default:
      return const [
        QuickLogAction(id: 'task', label: 'Task', emoji: '✅', pipelineHint: 'Add a task'),
        QuickLogAction(id: 'note', label: 'Note', emoji: '📝', pipelineHint: 'Save a note'),
        QuickLogAction(id: 'event', label: 'Event', emoji: '📅', pipelineHint: 'Add an event'),
        QuickLogAction(id: 'meds', label: 'Meds', emoji: '💊', pipelineHint: 'Log personal medication'),
        QuickLogAction(id: 'symptom', label: 'Symptom', emoji: '🩺', pipelineHint: 'Log a symptom'),
        QuickLogAction(id: 'worry', label: 'Worry', emoji: '🧠', pipelineHint: 'Capture a worry'),
        QuickLogAction(id: 'expense', label: 'Expense', emoji: '💰', pipelineHint: 'Log an expense'),
        QuickLogAction(id: 'dream', label: 'Dream', emoji: '🌙', pipelineHint: 'Capture a dream or goal'),
        QuickLogAction(id: 'general', label: 'General', emoji: '📋', pipelineHint: 'General note'),
      ];
  }
}

class QuickLogGrid extends StatelessWidget {
  final List<QuickLogAction> actions;
  final ValueChanged<QuickLogAction> onSelected;

  const QuickLogGrid({
    super.key,
    required this.actions,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Text('QUICK LOG', style: BethTypography.caption?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
          )),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.05,
            children: actions.map((a) {
              return Material(
                color: BethColours.surface,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => onSelected(a),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: BethColours.surfaceAlt),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(a.emoji, style: const TextStyle(fontSize: 28)),
                        const SizedBox(height: 6),
                        Text(a.label, style: BethTypography.caption),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
