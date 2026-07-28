import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/module_registry_provider.dart';
import 'theme/colours.dart';
import 'theme/typography.dart';
import 'screens/dashboard/morning_dashboard.dart';
import 'screens/calendar/calendar_view.dart';
import 'screens/notes/notes_screen.dart';
import 'screens/family_hub/family_hub_screen.dart';
import 'screens/team/team_grid.dart';
import 'screens/debug/resolver_debug_screen.dart';
import 'screens/tasks/tasks_screen.dart';
import 'screens/budget/budget_screen.dart';
import 'features/timeline/timeline_screen.dart';
import 'features/state_history/state_history_screen.dart';
import 'features/decision_inspector/decision_inspector_screen.dart';
import 'widgets/more_menu_sheet.dart';

class TetherApp extends StatelessWidget {
  const TetherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tether',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: BethColours.primary,
          background: BethColours.background,
          surface: BethColours.surface,
        ),
        scaffoldBackgroundColor: BethColours.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: BethColours.surface,
          foregroundColor: BethColours.textPrimary,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: BethTypography.heading,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: BethColours.surface,
          selectedItemColor: BethColours.primary,
          unselectedItemColor: BethColours.textMuted,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
      ),
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  Widget _screenForModule(String moduleId) {
    switch (moduleId) {
      case 'dashboard':
        return const MorningDashboard();
      case 'capture_notes':
        return const NotesScreen();
      case 'calendar':
        return const CalendarView();
      case 'family_hub':
        return const FamilyHubScreen();
      case 'team':
        return const TeamGrid();
      case 'tasks':
        return const TasksScreen();
      case 'budget':
        return const BudgetScreen();
      case 'resolver_debug':
        return const ResolverDebugScreen(
          activeStates: [],
          activePresets: [],
          activeToggles: [],
          traces: [],
          finalEffect: 'No resolver run yet',
          notificationDecision: 'No notifications processed',
        );
      case 'timeline':
        return const FeaturesTimelineScreen();
      case 'state_history':
        return const StateHistoryScreen();
      case 'decision_inspector':
        return const DecisionInspectorScreen();
      default:
        return PlaceholderScreen(title: moduleId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final registry = context.watch<ModuleRegistryProvider>();

    if (!registry.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final modules = registry.activeModules;
    const showMoreTab = true;
    final tabCount = modules.length + 1;

    if (_currentIndex >= tabCount) {
      _currentIndex = 0;
    }

    final isMoreTab = showMoreTab && _currentIndex == modules.length;

    return Scaffold(
      body: isMoreTab
          ? const MorningDashboard()
          : _screenForModule(modules[_currentIndex].id),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (showMoreTab && index == modules.length) {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const MoreMenuSheet(),
            );
            return;
          }
          setState(() => _currentIndex = index);
        },
        items: [
          ...modules.map(
            (module) => BottomNavigationBarItem(
              icon: Icon(_iconForModule(module.id, filled: false)),
              activeIcon: Icon(_iconForModule(module.id, filled: true)),
              label: module.title,
            ),
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
      ),
    );
  }

  IconData _iconForModule(String moduleId, {bool filled = false}) {
    switch (moduleId) {
      case 'dashboard':
        return filled ? Icons.home : Icons.home_outlined;
      case 'capture_notes':
        return filled ? Icons.edit_note : Icons.edit_note_outlined;
      case 'calendar':
        return filled ? Icons.calendar_today : Icons.calendar_today_outlined;
      case 'family_hub':
        return filled ? Icons.family_restroom : Icons.family_restroom_outlined;
      case 'tasks':
        return filled ? Icons.check_circle : Icons.check_circle_outline;
      case 'budget':
        return filled ? Icons.account_balance_wallet : Icons.account_balance_wallet_outlined;
      case 'team':
        return filled ? Icons.groups : Icons.groups_outlined;
      case 'resolver_debug':
        return filled ? Icons.bug_report : Icons.bug_report_outlined;
      case 'timeline':
        return filled ? Icons.timeline : Icons.timeline_outlined;
      case 'state_history':
        return filled ? Icons.history : Icons.history_outlined;
      case 'decision_inspector':
        return filled ? Icons.psychology : Icons.psychology_outlined;
      default:
        return filled ? Icons.circle : Icons.circle_outlined;
    }
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text('$title — Coming soon', style: BethTypography.body),
      ),
    );
  }
}
