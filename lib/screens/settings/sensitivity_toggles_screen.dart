import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/support_preset.dart';
import '../../core/support/sensitivity_toggle_catalog.dart';
import '../../providers/settings_prefs_provider.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';

class SensitivityTogglesScreen extends StatefulWidget {
  const SensitivityTogglesScreen({super.key});

  @override
  State<SensitivityTogglesScreen> createState() => _SensitivityTogglesScreenState();
}

class _SensitivityTogglesScreenState extends State<SensitivityTogglesScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final prefs = context.watch<SettingsPrefsProvider>();
    final filtered = sensitivityToggleCatalog.where((t) {
      if (_query.isEmpty) return true;
      final q = _query.toLowerCase();
      return t.displayName.toLowerCase().contains(q) ||
          t.description.toLowerCase().contains(q) ||
          t.category.toLowerCase().contains(q);
    }).toList();

    final byCategory = <String, List<SensitivityToggle>>{};
    for (final t in filtered) {
      byCategory.putIfAbsent(t.category, () => []).add(t);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Sensitivity toggles')),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              'Fine-tune how the app behaves. These work with or without a Support Preset.',
              style: BethTypography.caption.copyWith(color: BethColours.textMuted),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search toggles',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          for (final entry in byCategory.entries) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Text(
                sensitivityToggleCategoryLabels[entry.key] ?? entry.key,
                style: BethTypography.caption.copyWith(color: BethColours.textMuted),
              ),
            ),
            ...entry.value.map(
              (t) => SwitchListTile(
                title: Text(t.displayName),
                subtitle: Text(t.description, style: BethTypography.caption),
                value: prefs.isSensitivityOn(t.id),
                onChanged: (_) => prefs.toggleSensitivity(t.id),
              ),
            ),
          ],
          const Divider(),
          ListTile(
            leading: const Icon(Icons.restart_alt),
            title: const Text('Reset all toggles to off'),
            onTap: () => prefs.resetSensitivity(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
