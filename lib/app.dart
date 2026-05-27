import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/module_registry_provider.dart';
import 'models/module_definition.dart';
import 'theme/colours.dart';
import 'theme/typography.dart';
import 'screens/dashboard/morning_dashboard.dart';
import 'screens/calendar/calendar_view.dart';
import 'screens/notes/notes_screen.dart';
import 'screens/children/children_screen.dart';
import 'screens/team/team_grid.dart';

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

  /// Map module IDs to their screen widgets
  Widget _screenForModule(String moduleId) {
    switch (moduleId) {
      case 'dashboard':
        return const MorningDashboard();
      case 'capture_notes':
        return const NotesScreen();
      case 'calendar':
        return const CalendarView();
      case 'children':
        return const ChildrenScreen();
      case 'team':
        return const TeamGrid();
      // Placeholder for modules not yet built
      default:
        return PlaceholderScreen(title: moduleId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final modules = context.watch<ModuleRegistryProvider>().activeModules;

    // Safety: if registry is empty, show loading
    if (modules.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Keep current index in bounds if modules changed
    if (_currentIndex >= modules.length) {
      _currentIndex = 0;
    }

    return Scaffold(
      body: _screenForModule(modules[_currentIndex].id),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: modules.map((module) {
          return BottomNavigationBarItem(
            icon: Icon(_iconForModule(module.id, filled: false)),
            activeIcon: Icon(_iconForModule(module.id, filled: true)),
            label: module.title,
          );
        }).toList(),
      ),
    );
  }

  /// Map module IDs to Material icons
  IconData _iconForModule(String moduleId, {bool filled = false}) {
    switch (moduleId) {
      case 'dashboard':
        return filled ? Icons.home : Icons.home_outlined;
      case 'capture_notes':
        return filled ? Icons.edit_note : Icons.edit_note_outlined;
      case 'calendar':
        return filled ? Icons.calendar_today : Icons.calendar_today_outlined;
      case 'children':
        return filled ? Icons.child_care : Icons.child_care_outlined;
      case 'tasks':
        return filled ? Icons.check_circle : Icons.check_circle_outline;
      case 'budget':
        return filled ? Icons.account_balance_wallet : Icons.account_balance_wallet_outlined;
      case 'team':
        return filled ? Icons.groups : Icons.groups_outlined;
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
        child: Text(
          '$title — Coming soon',
          style: BethTypography.body,
        ),
      ),
    );
  }
}