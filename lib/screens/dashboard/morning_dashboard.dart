import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/dashboard_provider.dart';
import '../../providers/module_registry_provider.dart';
import '../../providers/calendar_provider.dart';
import '../../providers/support_preset_provider.dart';
import '../../core/tasks/task_repository.dart';
import '../../core/tasks/task_priority.dart';
import '../../core/tasks/task_status.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';
import '../../widgets/status_shield.dart';
import '../../widgets/affirmation_card.dart';
import '../../widgets/family_hub_summary_card.dart';
import '../settings/settings_screen.dart';

class MorningDashboard extends StatefulWidget {
  const MorningDashboard({super.key});

  @override
  State<MorningDashboard> createState() => _MorningDashboardState();
}

class _MorningDashboardState extends State<MorningDashboard> {
  final TaskRepository _tasks = TaskRepository();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dashboard = context.read<DashboardProvider>();
      dashboard.attachPresets(context.read<SupportPresetProvider>());
      dashboard.refreshNotificationHold();
    });
  }

  @override
  Widget build(BuildContext context) {
    final registry = context.watch<ModuleRegistryProvider>();
    final dashboard = context.watch<DashboardProvider>();
    final calendar = context.watch<CalendarProvider>();
    final simplified = context.watch<SupportPresetProvider>().simplifiedDashboard;

    final todayEvents = calendar.events.where((e) {
      final d = e.date;
      final now = DateTime.now();
      return d.year == now.year && d.month == now.month && d.day == now.day;
    }).toList();

    final pending = _tasks.getTasks().where((t) => t.status == TaskStatus.pending).toList();
    final urgent = pending.where((t) => t.priority == TaskPriority.high).toList();
    final snoozed = _tasks.getTasks().where((t) => t.status == TaskStatus.snoozed).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => openSettings(context),
        ),
        title: const Text('Good morning, Beth'),
        actions: [
          if (dashboard.heldNotificationCount > 0)
            Stack(
              children: [
                const IconButton(
                  icon: Icon(Icons.notifications_outlined),
                  onPressed: null,
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: BethColours.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${dashboard.heldNotificationCount}',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
              ],
            )
          else
            const IconButton(icon: Icon(Icons.notifications_outlined), onPressed: null),
          const CircleAvatar(
            radius: 16,
            backgroundColor: BethColours.primary,
            child: Text('B', style: TextStyle(color: Colors.white, fontSize: 14)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AffirmationCard(),
            const SizedBox(height: 20),
            if (registry.isModuleActive('family_hub')) ...[
              const FamilyHubSummaryCard(),
              const SizedBox(height: 20),
            ],
            if (registry.isModuleActive('calendar') && !simplified) ...[
              _sectionHeader('Today', null),
              const SizedBox(height: 8),
              if (todayEvents.isEmpty)
                Text('Nothing on the calendar today.', style: BethTypography.caption)
              else
                ...todayEvents.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _scheduleItem(
                      DateFormat.jm().format(e.startTime),
                      e.title,
                      BethColours.primary,
                    ),
                  ),
                ),
              const SizedBox(height: 20),
            ],
            if (registry.isModuleActive('tasks')) ...[
              if (urgent.isNotEmpty) ...[
                _sectionHeader('Urgent', null),
                const SizedBox(height: 8),
                ...urgent.map(
                  (t) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text('• ${t.title}', style: BethTypography.bodySmall),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (snoozed.isNotEmpty && !simplified) ...[
                _sectionHeader('Snoozed', '${snoozed.length} items'),
                const SizedBox(height: 8),
                ...snoozed.take(3).map(
                      (t) => _snoozedItem(
                        t.title,
                        t.snoozedUntil != null
                            ? DateFormat.jm().format(t.snoozedUntil!)
                            : 'Later',
                      ),
                    ),
                const SizedBox(height: 16),
              ],
            ],
            const StatusShield(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, String? action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: BethTypography.subheading),
        if (action != null)
          Text(action, style: BethTypography.caption?.copyWith(color: BethColours.primary)),
      ],
    );
  }

  Widget _scheduleItem(String time, String title, Color colour) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: BethColours.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: colour, width: 3)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(time, style: BethTypography.caption?.copyWith(fontWeight: FontWeight.w500)),
          ),
          Expanded(child: Text(title, style: BethTypography.bodySmall)),
        ],
      ),
    );
  }

  Widget _snoozedItem(String title, String reminder) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: BethColours.surfaceAlt,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Expanded(child: Text(title, style: BethTypography.bodySmall)),
            Text(reminder, style: BethTypography.caption),
          ],
        ),
      ),
    );
  }
}
