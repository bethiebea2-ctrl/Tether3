import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_prefs_provider.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';

class StatusShieldSettingsScreen extends StatelessWidget {
  const StatusShieldSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = context.watch<SettingsPrefsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Status shield')),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              'Status Shield lets your team know if you\'re open to input or need focus time.',
              style: BethTypography.caption.copyWith(color: BethColours.textMuted),
            ),
          ),
          _header('Default state'),
          RadioListTile<String>(
            title: const Text('Open to leads'),
            value: 'open',
            groupValue: prefs.shieldDefault,
            onChanged: (v) => prefs.setShieldDefault(v!),
          ),
          RadioListTile<String>(
            title: const Text('Heads down'),
            value: 'heads_down',
            groupValue: prefs.shieldDefault,
            onChanged: (v) => prefs.setShieldDefault(v!),
          ),
          _header('Auto-expiry'),
          RadioListTile<String>(
            title: const Text('Rest of day'),
            value: 'rest_of_day',
            groupValue: prefs.shieldExpiry,
            onChanged: (v) => prefs.setShieldExpiry(v!),
          ),
          RadioListTile<String>(
            title: const Text('Custom (4 hours)'),
            value: 'custom',
            groupValue: prefs.shieldExpiry,
            onChanged: (v) => prefs.setShieldExpiry(v!),
          ),
          RadioListTile<String>(
            title: const Text('Until I turn it off'),
            value: 'until_off',
            groupValue: prefs.shieldExpiry,
            onChanged: (v) => prefs.setShieldExpiry(v!),
          ),
          _header('Voice commands'),
          SwitchListTile(
            title: const Text('"Heads down" / "Open to leads"'),
            value: prefs.shieldVoiceCommands,
            onChanged: prefs.setShieldVoiceCommands,
          ),
          _header('Current state integration'),
          const ListTile(
            title: Text('"Overwhelmed" → Heads down'),
            subtitle: Text('Local preference note — wired when Current State surfaces on dashboard'),
          ),
          const ListTile(
            title: Text('"Low energy" → Heads down'),
          ),
          const ListTile(
            title: Text('"Migraine mode" → Heads down'),
          ),
          _header('Sharing'),
          SwitchListTile(
            title: const Text('Share status with household'),
            subtitle: Text(
              'Household sync arrives in Phase 2A — preference saved locally.',
              style: BethTypography.caption,
            ),
            value: prefs.shieldShareHousehold,
            onChanged: prefs.setShieldShareHousehold,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _header(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(title, style: BethTypography.caption.copyWith(color: BethColours.textMuted)),
    );
  }
}
