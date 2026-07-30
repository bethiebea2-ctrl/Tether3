import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/dashboard_provider.dart';
import '../../providers/module_registry_provider.dart';
import '../../providers/calendar_provider.dart';
import '../../providers/support_preset_provider.dart';
import '../../providers/settings_prefs_provider.dart';
import '../../core/tasks/task_repository.dart';
import '../../core/tasks/task_priority.dart';
import '../../core/tasks/task_status.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';
import '../../widgets/status_shield.dart';
import '../../widgets/affirmation_card.dart';
import '../../widgets/family_hub_summary_card.dart';
import '../../widgets/colour_card.dart';
import '../../widgets/capacity_check_in.dart';
import '../../widgets/current_state_bar.dart';
import '../../widgets/at_a_glance_section.dart';
import '../settings/settings_screen.dart';
import '../calendar/event_creation.dart';
import '../calendar/event_detail.dart';
import '../companion/companion_screen.dart';
import '../creative/win_dream_screens.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _tasks.load();
      if (mounted) setState(() {});
      final dashboard = context.read<DashboardProvider>();
      dashboard.attachPresets(context.read<SupportPresetProvider>());
      dashboard.refreshNotificationHold();
      _syncShieldFromCurrentState();
    });
  }

  void _syncShieldFromCurrentState() {
    final prefs = context.read<SettingsPrefsProvider>();
    final id = prefs.currentStateId;
    if (id == null) return;
    const headsDownStates = {
      'overwhelmed',
      'migraine',
      'exhausted',
      'low_energy',
      'shutdown',
      'panicking',
    };
    if (headsDownStates.contains(id)) {
      context.read<DashboardProvider>().setHeadsDownFromCurrentState(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final registry = context.watch<ModuleRegistryProvider>();
    final dashboard = context.watch<DashboardProvider>();
    final calendar = context.watch<CalendarProvider>();
    final simplified = context.watch<SupportPresetProvider>().simplifiedDashboard ||
        dashboard.minimiseDashboard;

    final todayEvents = calendar.events.where((e) {
      final d = e.date;
      final now = DateTime.now();
      return d.year == now.year && d.month == now.month && d.day == now.day;
    }).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    final pending = _tasks.getTasks().where((t) => t.status == TaskStatus.pending).toList();
    final urgent = pending.where((t) => t.priority == TaskPriority.high).toList();
    final snoozed = _tasks.getTasks().where((t) => t.status == TaskStatus.snoozed).toList();

    final showBare = dashboard.bareMinimumsOnly;
    final visibleUrgent = showBare ? urgent.take(2).toList() : urgent;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => openSettings(context),
        ),
        title: Text(DashboardProvider.timeGreeting()),
        actions: [
          IconButton(
            tooltip: 'Companion',
            icon: const Icon(Icons.record_voice_over_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CompanionScreen()),
              );
            },
          ),
          IconButton(
            icon: Badge(
              isLabelVisible: dashboard.heldNotificationCount > 0,
              label: Text('${dashboard.heldNotificationCount}'),
              child: const Icon(Icons.notifications_outlined),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications — coming soon')),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const CircleAvatar(
              radius: 14,
              backgroundColor: BethColours.primary,
              child: Text('B', style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
            onSelected: (v) {
              if (v == 'settings') openSettings(context);
              if (v == 'companion') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CompanionScreen()),
                );
              }
              if (v == 'signout') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sign out — coming in Phase 2A')),
                );
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'companion', child: Text('Companion mode')),
              PopupMenuItem(value: 'profile', child: Text('My profile')),
              PopupMenuItem(value: 'settings', child: Text('Settings')),
              PopupMenuItem(value: 'signout', child: Text('Sign out')),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await calendar.loadEvents();
          dashboard.refreshNotificationHold();
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const AffirmationCard(),
            const SizedBox(height: 12),
            const ColourCard(),
            const SizedBox(height: 12),
            if (!simplified) ...[
              const CapacityCheckIn(),
              const SizedBox(height: 8),
            ],
            const CurrentStateBar(),
            const SizedBox(height: 16),
            if (registry.isModuleActive('family_hub')) ...[
              const FamilyHubSummaryCard(),
              const SizedBox(height: 20),
            ],
            if (!simplified) ...[
              Row(
                children: [
                  Expanded(
                    child: _dashboardLinkCard(
                      icon: Icons.emoji_events_outlined,
                      title: 'Win log',
                      subtitle: 'Tiny wins count',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const WinLogScreen()),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _dashboardLinkCard(
                      icon: Icons.auto_awesome_outlined,
                      title: 'Dream board',
                      subtitle: 'Goals & dreams',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DreamBoardScreen(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
            if (registry.isModuleActive('calendar') && !simplified) ...[
              _sectionHeader(
                'Today — ${DateFormat('EEEE d MMMM').format(DateTime.now())}',
                null,
              ),
              const SizedBox(height: 8),
              if (todayEvents.isEmpty)
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EventCreation()),
                  ),
                  child: const Text('Nothing scheduled today. Add an event?'),
                )
              else
                ...todayEvents.take(5).map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EventDetailScreen(event: e),
                            ),
                          ),
                          borderRadius: BorderRadius.circular(8),
                          child: _scheduleItem(
                            e.isAllDay
                                ? 'All day'
                                : DateFormat.jm().format(e.startTime),
                            e.title,
                            calendar.getCategoryColour(e.categoryId),
                          ),
                        ),
                      ),
                    ),
              if (todayEvents.length > 5)
                Text('+${todayEvents.length - 5} more events', style: BethTypography.caption),
              TextButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EventCreation()),
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add event'),
              ),
              const SizedBox(height: 12),
            ],
            if (registry.isModuleActive('reproductive_health')) ...[
              Text(
                '🩸 Cycle tracking active · Open Reproductive Health for details',
                style: BethTypography.caption?.copyWith(color: BethColours.textMuted),
              ),
              const SizedBox(height: 16),
            ],
            if (registry.isModuleActive('tasks')) ...[
              if (visibleUrgent.isNotEmpty) ...[
                Text('⚠ Urgent', style: BethTypography.subheading?.copyWith(color: BethColours.red)),
                const SizedBox(height: 8),
                ...visibleUrgent.map(
                  (t) => Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: BethColours.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: const Border(left: BorderSide(color: BethColours.red, width: 3)),
                    ),
                    child: Text('☐ ${t.title}', style: BethTypography.bodySmall),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (snoozed.isNotEmpty && !simplified) ...[
                _sectionHeader('📌 Snoozed', '${snoozed.length} items'),
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
            if (!simplified) const AtAGlanceSection(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, String? action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: Text(title, style: BethTypography.subheading)),
        if (action != null)
          Text(action, style: BethTypography.caption?.copyWith(color: BethColours.primary)),
      ],
    );
  }

  Widget _dashboardLinkCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: BethColours.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: BethColours.primary),
              const SizedBox(height: 8),
              Text(title, style: BethTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
              )),
              Text(subtitle, style: BethTypography.caption),
            ],
          ),
        ),
      ),
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
            width: 70,
            child: Text(time, style: BethTypography.caption?.copyWith(fontWeight: FontWeight.w600)),
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
            const Text('🕐 '),
            Expanded(child: Text(title, style: BethTypography.bodySmall)),
            Text(reminder, style: BethTypography.caption),
          ],
        ),
      ),
    );
  }
}
