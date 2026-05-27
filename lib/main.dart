import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/dashboard_provider.dart';
import 'providers/capture_provider.dart';
import 'services/deepseek_service.dart';
import 'providers/calendar_provider.dart';
import 'providers/module_registry_provider.dart';
// import 'services/session_tracker.dart'; // Added when Ghost Log pipeline is active

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  DeepSeekService().setApiKey('sk-cec42879e0d0433a9eb0e402f497db5c');

  // SessionTracker().startSession(instanceId: 'viva'); // Added when Ghost Log pipeline is active

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        // ChangeNotifierProvider(create: (_) => SessionTracker()), // Added when Ghost Log pipeline is active
        ChangeNotifierProvider(create: (_) => CaptureProvider()),
        ChangeNotifierProvider(create: (_) => CalendarProvider()),
        ChangeNotifierProvider(create: (_) => ModuleRegistryProvider()),
      ],
      child: const TetherApp(),
    ),
  );
}