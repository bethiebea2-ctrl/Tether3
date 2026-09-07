import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app.dart';
import '../../providers/auth_provider.dart';
import '../../providers/household_provider.dart';
import '../../providers/instance_library_provider.dart';
import '../onboarding/onboarding_flow.dart';
import 'auth_screen.dart';

/// Routes between auth, onboarding, and the main app shell.
class AppGate extends StatefulWidget {
  const AppGate({super.key});

  @override
  State<AppGate> createState() => _AppGateState();
}

class _AppGateState extends State<AppGate> {
  String? _loadedUserId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureAuthReady());
  }

  Future<void> _ensureAuthReady() async {
    final auth = context.read<AuthProvider>();
    if (!auth.isInitialized) {
      await auth.initialize();
    }
  }

  Future<void> _loadSignedInContext(String userId) async {
    if (_loadedUserId == userId) return;
    await context.read<HouseholdProvider>().loadForUser(userId);
    await context.read<InstanceLibraryProvider>().load();
    _loadedUserId = userId;
  }

  void _clearSignedInContext() {
    _loadedUserId = null;
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (!auth.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!auth.isSignedIn) {
      _clearSignedInContext();
      return const AuthScreen();
    }

    final userId = auth.user!.id;
    return FutureBuilder<void>(
      future: _loadSignedInContext(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (!auth.onboardingCompleted) {
          return const OnboardingFlow();
        }

        return const AppShell();
      },
    );
  }
}
