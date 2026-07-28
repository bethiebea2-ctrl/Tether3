import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/support_preset_provider.dart';
import '../../theme/typography.dart';

class SupportPresetsSettingsScreen extends StatelessWidget {
  const SupportPresetsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final presets = context.watch<SupportPresetProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Support presets')),
      body: ListView(
        children: SupportPresetProvider.catalog.map((preset) {
          return SwitchListTile(
            title: Text(preset.displayName),
            subtitle: Text(preset.description, style: BethTypography.caption),
            value: presets.isPresetActive(preset.id),
            onChanged: (_) => presets.togglePreset(preset.id),
          );
        }).toList(),
      ),
    );
  }
}
