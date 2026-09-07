import 'dart:async';
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
  bool _loadingContext = false;
  Object? _loadError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureAuthReady());
  }

  Future<void> _ensureAuthReady() async {
    final auth = context.read<AuthProvider>();
    if (auth.isInitialized) return;
    try {
      await auth.initialize();
    } catch (e, st) {
      // ignore: avoid_print
      print('AppGate auth init failed: $e\n$st');
      if (mounted) setState(() => _loadError = e);
    }
  }

  Future<void> _loadSignedInContext(String userId) async {
    if (_loadedUserId == userId || _loadingContext) return;
    setState(() {
      _loadingContext = true;
      _loadError = null;
    });
    try {
      await context.read<HouseholdProvider>().loadForUser(userId).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException('Household load timed out');
        },
      );
      await context.read<InstanceLibraryProvider>().load();
      _loadedUserId = userId;
    } catch (e, st) {
      // ignore: avoid_print
      print('AppGate context load failed: $e\n$st');
      if (mounted) setState(() => _loadError = e);
    } finally {
      if (mounted) setState(() => _loadingContext = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (!auth.isInitialized) {
      return Scaffold(
        body: Center(
          child: _loadError == null
              ? const CircularProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Could not start sign-in. Try fully quitting and reopening.'),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: () async {
                          setState(() => _loadError = null);
                          await _ensureAuthReady();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
        ),
      );
    }

    if (!auth.isSignedIn) {
      if (_loadedUserId != null) {
        _loadedUserId = null;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<HouseholdProvider>().reset();
        });
      }
      return const AuthScreen();
    }

    // New users set up their household during onboarding — don't block on DB load.
    if (!auth.onboardingCompleted) {
      return const OnboardingFlow();
    }

    final userId = auth.user!.id;
    final householdProvider = context.watch<HouseholdProvider>();

    // Onboarding finish may have already loaded the household in memory.
    if (householdProvider.isLoaded) {
      if (_loadedUserId != userId) {
        _loadedUserId = userId;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<InstanceLibraryProvider>().load();
        });
      }
      return const AppShell();
    }

    if (_loadedUserId != userId && !_loadingContext) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadSignedInContext(userId));
    }

    if (_loadingContext || (_loadedUserId != userId && _loadError == null)) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_loadError != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Could not load your household.'),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => _loadSignedInContext(userId),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return const AppShell();
  }
}
