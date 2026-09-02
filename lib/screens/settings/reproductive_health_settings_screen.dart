import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_prefs_provider.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';

class ReproductiveHealthSettingsScreen extends StatelessWidget {
  const ReproductiveHealthSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = context.watch<SettingsPrefsProvider>();

    return Scaffold(
      backgroundColor: BethColours.background,
      appBar: AppBar(title: const Text('Reproductive health')),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text(
              'Calendar overlay',
              style: BethTypography.caption.copyWith(color: BethColours.textMuted),
            ),
          ),
          SwitchListTile(
            title: const Text('Show cycle phases on calendar'),
            subtitle: const Text(
              'Subtle colour shading when Reproductive Health is active',
            ),
            value: prefs.showCyclePhases,
            onChanged: prefs.setShowCyclePhases,
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Cycle data stays on this device. Predictions use “may be” language — '
              'bodies are not clocks. Partner sharing is opt-in per entry (Phase 2A).',
              style: BethTypography.caption,
            ),
          ),
        ],
      ),
    );
  }
}
