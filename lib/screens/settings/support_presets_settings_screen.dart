import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/support/sensitivity_toggle_catalog.dart';
import '../../models/support_preset.dart';
import '../../providers/settings_prefs_provider.dart';
import '../../providers/support_preset_provider.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';

class SupportPresetsSettingsScreen extends StatelessWidget {
  const SupportPresetsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final presets = context.watch<SupportPresetProvider>();
    final active = presets.activePresets;
    final available = SupportPresetProvider.catalog
        .where((p) => !presets.isPresetActive(p.id))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Support presets')),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              'Support Presets are bundles of settings that adapt the app to your needs. '
              'You can customise any preset or build your own.',
              style: BethTypography.caption.copyWith(color: BethColours.textMuted),
            ),
          ),
          _header('Active presets'),
          if (active.isEmpty)
            const ListTile(
              title: Text('None active'),
              subtitle: Text('Activate a preset below'),
            )
          else
            ...active.map(
              (preset) => ListTile(
                title: Text(preset.displayName),
                subtitle: Text(
                  '${preset.defaultToggleIds.length} default toggles · ${SupportPresetProvider.categoryLabels[preset.category] ?? preset.category}',
                  style: BethTypography.caption,
                ),
                trailing: TextButton(
                  onPressed: () => presets.deactivatePreset(preset.id),
                  child: const Text('Deactivate'),
                ),
                onTap: () => _showConfigureSheet(context, preset),
              ),
            ),
          const Divider(),
          _header('Available presets'),
          for (final category in SupportPresetProvider.categoryOrder) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Text(
                SupportPresetProvider.categoryLabels[category] ?? category,
                style: BethTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            ...available.where((p) => p.category == category).map(
              (preset) => ListTile(
                title: Text(preset.displayName),
                subtitle: Text(preset.description, style: BethTypography.caption),
                trailing: IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  tooltip: 'Activate',
                  onPressed: () => presets.togglePreset(preset.id),
                ),
                onTap: () => presets.togglePreset(preset.id),
              ),
            ),
          ],
          const Divider(),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Create custom preset'),
            subtitle: Text(
              'Coming in Phase 2B',
              style: BethTypography.caption.copyWith(color: BethColours.textMuted),
            ),
            enabled: false,
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

  void _showConfigureSheet(BuildContext context, SupportPreset preset) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _PresetConfigureSheet(preset: preset),
    );
  }
}

class _PresetConfigureSheet extends StatelessWidget {
  final SupportPreset preset;
  const _PresetConfigureSheet({required this.preset});

  @override
  Widget build(BuildContext context) {
    final prefs = context.watch<SettingsPrefsProvider>();
    final toggles = preset.defaultToggleIds
        .map(sensitivityToggleById)
        .whereType<SensitivityToggle>()
        .toList();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (ctx, scrollController) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(preset.displayName, style: BethTypography.subheading),
            const SizedBox(height: 4),
            Text(preset.description, style: BethTypography.caption),
            const SizedBox(height: 12),
            Text(
              'Toggle overrides for this preset',
              style: BethTypography.caption.copyWith(color: BethColours.textMuted),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                controller: scrollController,
                children: [
                  if (toggles.isEmpty)
                    const Text('No configurable toggles for this preset.')
                  else
                    ...toggles.map(
                      (t) => SwitchListTile(
                        title: Text(t.displayName),
                        subtitle: Text(t.description, style: BethTypography.caption),
                        value: prefs.isSensitivityOn(t.id),
                        onChanged: (_) => prefs.toggleSensitivity(t.id),
                      ),
                    ),
                  if (preset.currentStateShortcuts.isNotEmpty) ...[
                    const Divider(),
                    Text(
                      'Linked current states',
                      style: BethTypography.caption.copyWith(color: BethColours.textMuted),
                    ),
                    const SizedBox(height: 4),
                    Text(preset.currentStateShortcuts.join(', ')),
                  ],
                ],
              ),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}
