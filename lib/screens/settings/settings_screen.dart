import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/module_registry_provider.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';
import 'accessibility_settings_screen.dart';
import 'calendar_settings_screen.dart';
import 'current_state_settings_screen.dart';
import 'event_categories_settings_screen.dart';
import 'family_hub_settings_screen.dart';
import 'module_management_screen.dart';
import 'notifications_settings_screen.dart';
import 'sensitivity_toggles_screen.dart';
import 'settings_stub_screen.dart';
import 'status_shield_settings_screen.dart';
import 'support_presets_settings_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final modules = context.watch<ModuleRegistryProvider>();
    final activeCount = modules.activeModules.length;
    final registeredCount = modules.manageableModules.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // ── Profile header stub ────────────────────────────
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person_outline)),
            title: const Text('Bethany Clulow'),
            subtitle: const Text('bethany.clulow.1@gmail.com'),
            trailing: TextButton(
              onPressed: () => openSettingsStub(
                context,
                title: 'Edit profile',
                phase: '2A',
                summary: 'Profile editing and context encoding arrive with authentication.',
              ),
              child: const Text('Edit profile'),
            ),
          ),
          const Divider(),

          // ── MODULES ────────────────────────────────────────
          _header('Modules'),
          ListTile(
            leading: const Icon(Icons.view_module_outlined),
            title: const Text('Module management'),
            subtitle: Text('Active: $activeCount · Registered: $registeredCount'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _push(context, const ModuleManagementScreen()),
          ),
          const Divider(),

          // ── SUPPORT & ACCESSIBILITY ────────────────────────
          _header('Support & accessibility'),
          ListTile(
            leading: const Icon(Icons.favorite_outline),
            title: const Text('Support presets'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _push(context, const SupportPresetsSettingsScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.tune),
            title: const Text('Sensitivity toggles'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _push(context, const SensitivityTogglesScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.spa_outlined),
            title: const Text('Current state'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _push(context, const CurrentStateSettingsScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.accessibility_new),
            title: const Text('Accessibility'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _push(context, const AccessibilitySettingsScreen()),
          ),
          const Divider(),

          // ── CALENDAR & TIME ────────────────────────────────
          _header('Calendar & time'),
          ListTile(
            leading: const Icon(Icons.calendar_month_outlined),
            title: const Text('Calendar settings'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _push(context, const CalendarSettingsScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text('Event categories'),
            subtitle: const Text('Colours linked to people'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _push(context, const EventCategoriesSettingsScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('Notifications'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _push(context, const NotificationsSettingsScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.shield_outlined),
            title: const Text('Status shield'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _push(context, const StatusShieldSettingsScreen()),
          ),
          const Divider(),

          // ── FAMILY & HOUSEHOLD ─────────────────────────────
          _header('Family & household'),
          if (modules.isModuleActive('family_hub'))
            ListTile(
              leading: const Icon(Icons.family_restroom_outlined),
              title: const Text('Family Hub settings'),
              subtitle: const Text('People, pets, defaults'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _push(context, const FamilyHubSettingsScreen()),
            ),
          ListTile(
            leading: const Icon(Icons.restaurant_outlined),
            title: const Text('Meals preferences'),
            subtitle: Text(
              'Coming in Phase 1D',
              style: BethTypography.caption.copyWith(color: BethColours.textMuted),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => openSettingsStub(
              context,
              title: 'Meals preferences',
              phase: '1D',
              summary: 'Household meal defaults, allergies, and dietary needs.',
            ),
          ),
          const Divider(),

          // ── HEALTH & WELLBEING ─────────────────────────────
          _header('Health & wellbeing'),
          _phaseTile(
            context,
            icon: Icons.favorite_outline,
            title: 'Health status settings',
            phase: '1D',
            summary: 'Condition categories, trackers, and medication defaults.',
          ),
          _phaseTile(
            context,
            icon: Icons.water_drop_outlined,
            title: 'Reproductive health',
            phase: '1D',
            summary: 'Cycle tracking defaults and overlay preferences.',
          ),
          _phaseTile(
            context,
            icon: Icons.psychology_outlined,
            title: 'Mental health toolkit',
            phase: '1D',
            summary: 'Regulation tools and crisis resource preferences.',
          ),
          const Divider(),

          // ── FINANCE ────────────────────────────────────────
          _header('Finance'),
          _phaseTile(
            context,
            icon: Icons.account_balance_wallet_outlined,
            title: 'Budget settings',
            phase: '1B',
            summary: 'Period, Tim preferences, and financial sensitivity. Stub for now.',
          ),
          _phaseTile(
            context,
            icon: Icons.category_outlined,
            title: 'Budget categories',
            phase: '1B',
            summary: 'Category list and shared budget mapping.',
          ),
          const Divider(),

          // ── TASKS ──────────────────────────────────────────
          _header('Tasks'),
          _phaseTile(
            context,
            icon: Icons.check_circle_outline,
            title: 'Task defaults',
            phase: '1B',
            summary: 'Default priority, snooze, layers, and energy gauge.',
          ),
          _phaseTile(
            context,
            icon: Icons.inventory_2_outlined,
            title: 'Task packs',
            phase: '1D',
            summary: 'Browse and activate suggested task packs from Support Presets.',
          ),
          const Divider(),

          // ── TEAM & COMPANION ───────────────────────────────
          _header('Team & companion'),
          _phaseTile(
            context,
            icon: Icons.groups_outlined,
            title: 'Team configuration',
            phase: '2A',
            summary: 'Instance roster and role defaults.',
          ),
          _phaseTile(
            context,
            icon: Icons.face_retouching_natural,
            title: 'Instance personalisation',
            phase: '2A',
            summary: 'Personality, voice, and appearance per instance.',
          ),
          _phaseTile(
            context,
            icon: Icons.record_voice_over_outlined,
            title: 'Companion settings',
            phase: '1C',
            summary: 'Voice companion and ambient presence preferences.',
          ),
          const Divider(),

          // ── PRIVACY & DATA ─────────────────────────────────
          _header('Privacy & data'),
          _phaseTile(
            context,
            icon: Icons.lock_outline,
            title: 'Sharing & privacy',
            phase: '2A',
            summary: 'Household roles, data sensitivity, and teen privacy.',
          ),
          _phaseTile(
            context,
            icon: Icons.history,
            title: 'User activity ledger',
            phase: '2A',
            summary: 'Audit trail of actions across modules.',
          ),
          _phaseTile(
            context,
            icon: Icons.import_export,
            title: 'Data export & delete',
            phase: '2A',
            summary: 'Export JSON per module or delete account data.',
          ),
          const Divider(),

          // ── APP ────────────────────────────────────────────
          _header('App'),
          _phaseTile(
            context,
            icon: Icons.auto_awesome_outlined,
            title: 'Affirmations',
            phase: '1D',
            summary: 'Affirmation source and frequency.',
          ),
          _phaseTile(
            context,
            icon: Icons.new_releases_outlined,
            title: "What's new",
            phase: '1B',
            summary: 'Changelog for this build.',
          ),
          _phaseTile(
            context,
            icon: Icons.info_outline,
            title: 'About & licences',
            phase: '1B',
            summary: 'App info, open-source licences, and credits.',
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign out'),
            subtitle: Text(
              'Coming in Phase 2A',
              style: BethTypography.caption.copyWith(color: BethColours.textMuted),
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sign out arrives with authentication (Phase 2A).')),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            child: Text(
              'Version 1.0.0 (Phase 1B)',
              style: BethTypography.caption.copyWith(color: BethColours.textMuted),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title.toUpperCase(),
        style: BethTypography.caption.copyWith(
          color: BethColours.textMuted,
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  Widget _phaseTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String phase,
    required String summary,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(
        'Coming in Phase $phase',
        style: BethTypography.caption.copyWith(color: BethColours.textMuted),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => openSettingsStub(
        context,
        title: title,
        phase: phase,
        summary: summary,
      ),
    );
  }

  void _push(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}

void openSettings(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const SettingsScreen()),
  );
}
