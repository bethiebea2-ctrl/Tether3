import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/module_registry_provider.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';
import 'event_categories_settings_screen.dart';
import 'family_hub_settings_screen.dart';
import 'module_management_screen.dart';
import 'support_presets_settings_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final modules = context.watch<ModuleRegistryProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          _header('App'),
          ListTile(
            leading: const Icon(Icons.view_module_outlined),
            title: const Text('Modules'),
            subtitle: const Text('Navigation and overflow'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ModuleManagementScreen()),
            ),
          ),
          const Divider(),
          _header('Family & calendar'),
          if (modules.isModuleActive('family_hub'))
            ListTile(
              leading: const Icon(Icons.family_restroom_outlined),
              title: const Text('Family Hub'),
              subtitle: const Text('People, pets, export before delete'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FamilyHubSettingsScreen()),
              ),
            ),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text('Event categories'),
            subtitle: const Text('Colours linked to people'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EventCategoriesSettingsScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('Notifications'),
            subtitle: const Text('Coming soon'),
            enabled: false,
          ),
          const Divider(),
          _header('Support & sensitivity'),
          ListTile(
            leading: const Icon(Icons.favorite_outline),
            title: const Text('Support presets'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SupportPresetsSettingsScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.shield_outlined),
            title: const Text('Status shield'),
            subtitle: const Text('Coming soon'),
            enabled: false,
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Sharing, data export, and instance personalisation arrive in Phase 2A.',
              style: BethTypography.caption?.copyWith(color: BethColours.textMuted),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(title, style: BethTypography.caption?.copyWith(color: BethColours.textMuted)),
    );
  }
}

void openSettings(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const SettingsScreen()),
  );
}
