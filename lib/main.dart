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
import 'providers/budget_extras_provider.dart';
import 'providers/companion_provider.dart';
import 'providers/health_provider.dart';
import 'providers/reproductive_provider.dart';
import 'providers/mental_health_provider.dart';
import 'providers/meals_provider.dart';
import 'screens/creative/win_dream_screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ensureDatabaseInitialized();
  await DatabaseHelper.warmUp();

  final moduleRegistry = ModuleRegistryProvider();
  await moduleRegistry.initialize();

  final settingsPrefs = SettingsPrefsProvider();
  await settingsPrefs.load();

  final supportPresets = SupportPresetProvider();
  supportPresets.attachSettings(settingsPrefs);
  await supportPresets.load();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: moduleRegistry),
        ChangeNotifierProvider.value(value: settingsPrefs),
        ChangeNotifierProvider(create: (_) => DashboardProvider()..load()),
        ChangeNotifierProvider(create: (_) => NotesProvider()),
        ChangeNotifierProvider(create: (_) => CalendarProvider()),
        ChangeNotifierProvider(create: (_) => FamilyHubProvider()..load()),
        ChangeNotifierProvider.value(value: supportPresets),
        ChangeNotifierProvider(create: (_) => BudgetProvider()..load()),
        ChangeNotifierProvider(create: (_) => BudgetExtrasProvider()..load()),
        ChangeNotifierProvider(create: (_) => CompanionProvider()..load()),
        ChangeNotifierProvider(create: (_) => HealthProvider()),
        ChangeNotifierProvider(create: (_) => ReproductiveProvider()),
        ChangeNotifierProvider(create: (_) => MentalHealthProvider()),
        ChangeNotifierProvider(create: (_) => MealsProvider()),
        ChangeNotifierProvider(create: (_) => WinLogProvider()),
      ],
      child: const TetherApp(),
    ),
  );
}
