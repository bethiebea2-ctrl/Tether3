import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
                onTap: () => _showConfigureStub(context, preset.displayName),
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

  void _showConfigureStub(BuildContext context, String name) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(name),
        content: const Text(
          'Per-toggle configure UI arrives with full Support Presets (Phase 1D/2B). '
          'Defaults from this preset are applied while it is active.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
        ],
      ),
    );
  }
}
