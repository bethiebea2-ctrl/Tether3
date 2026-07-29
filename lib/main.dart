import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database/database_bootstrap.dart';
import 'database/database_helper.dart';
import 'app.dart';
import 'providers/dashboard_provider.dart';
import 'providers/calendar_provider.dart';
import 'providers/module_registry_provider.dart';
import 'providers/notes_provider.dart';
import 'providers/family_hub_provider.dart';
import 'providers/support_preset_provider.dart';
import 'providers/settings_prefs_provider.dart';
import 'providers/budget_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ensureDatabaseInitialized();
  await DatabaseHelper.warmUp();

  final moduleRegistry = ModuleRegistryProvider();
  await moduleRegistry.initialize();

  final settingsPrefs = SettingsPrefsProvider();
  await settingsPrefs.load();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: moduleRegistry),
        ChangeNotifierProvider.value(value: settingsPrefs),
        ChangeNotifierProvider(create: (_) => DashboardProvider()..load()),
        ChangeNotifierProvider(create: (_) => NotesProvider()),
        ChangeNotifierProvider(create: (_) => CalendarProvider()),
        ChangeNotifierProvider(create: (_) => FamilyHubProvider()..load()),
        ChangeNotifierProvider(create: (_) => SupportPresetProvider()),
        ChangeNotifierProvider(create: (_) => BudgetProvider()),
      ],
      child: const TetherApp(),
    ),
  );
}
