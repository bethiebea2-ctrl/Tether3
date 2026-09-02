import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/tasks/task_repository.dart';
import '../core/tasks/task_status.dart';
import '../core/tasks/task_priority.dart';
import '../providers/module_registry_provider.dart';
import '../theme/colours.dart';
import '../theme/typography.dart';

class AtAGlanceSection extends StatefulWidget {
  const AtAGlanceSection({super.key});

  @override
  State<AtAGlanceSection> createState() => _AtAGlanceSectionState();
}

class _AtAGlanceSectionState extends State<AtAGlanceSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final registry = context.watch<ModuleRegistryProvider>();
    final cards = <Widget>[];

    if (registry.isModuleActive('tasks')) {
      final tasks = TaskRepository().getTasks();
      final pending = tasks.where((t) => t.status == TaskStatus.pending).length;
      final high = tasks
          .where((t) => t.status == TaskStatus.pending && t.priority == TaskPriority.high)
          .length;
      cards.add(_card('📋', high > 0
          ? '$pending chores pending · $high urgent'
          : '$pending chores pending'));
    }

    if (registry.isModuleActive('budget')) {
      cards.add(_card('💰', 'Budget: open Budget for this period\'s totals'));
    }

    if (cards.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('At a glance', style: BethTypography.subheading),
            const Spacer(),
            TextButton(
              onPressed: () => setState(() => _expanded = !_expanded),
              child: Text(_expanded ? 'Collapse' : 'Expand'),
            ),
          ],
        ),
        if (_expanded) ...cards,
      ],
    );
  }

  Widget _card(String icon, String text) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: BethColours.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: BethColours.primary.withOpacity(0.12)),
      ),
      child: Text('$icon  $text', style: BethTypography.bodySmall),
    );
  }
}
