import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/models/resolver_result.dart';
import '../../providers/settings_prefs_provider.dart';
import '../../providers/support_preset_provider.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';
import 'resolver_debug_screen.dart';

/// PIN-gated entry to Ghost Log / Resolver debug (Phase 1B).
class GhostLogGateScreen extends StatefulWidget {
  const GhostLogGateScreen({super.key});

  @override
  State<GhostLogGateScreen> createState() => _GhostLogGateScreenState();
}

class _GhostLogGateScreenState extends State<GhostLogGateScreen> {
  final _pin = TextEditingController();
  String? _error;
  static const _defaultPin = '2468';

  @override
  void dispose() {
    _pin.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final prefs = await SharedPreferences.getInstance();
    final expected = prefs.getString('ghost_log_pin') ?? _defaultPin;
    if (_pin.text.trim() != expected) {
      setState(() => _error = 'Incorrect PIN');
      return;
    }
    if (!mounted) return;
    final presets = context.read<SupportPresetProvider>();
    final settings = context.read<SettingsPrefsProvider>();
    final activePresets = presets.activePresets.map((p) => p.id).toList();
    final activeStates = [
      if (settings.currentStateId != null) settings.currentStateId!,
    ];
    final toggles = settings.sensitivityToggleIds.toList();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResolverDebugScreen(
          activeStates: activeStates,
          activePresets: activePresets,
          activeToggles: toggles,
          traces: const <ResolverTrace>[],
          finalEffect: activePresets.isEmpty
              ? 'No active presets — baseline behaviour'
              : 'Presets active: ${activePresets.join(', ')}',
          notificationDecision: settings.deliveryMode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BethColours.background,
      appBar: AppBar(title: const Text('Ghost Log')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Developer access. Enter PIN to view resolver state.',
              style: BethTypography.bodySmall,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _pin,
              obscureText: true,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: 'PIN',
                errorText: _error,
              ),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: _submit, child: const Text('Unlock')),
            const SizedBox(height: 8),
            Text(
              'Default PIN for local builds: 2468',
              style: BethTypography.caption?.copyWith(color: BethColours.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
