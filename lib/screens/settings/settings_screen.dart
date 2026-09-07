import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/module_registry_provider.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';
import 'accessibility_settings_screen.dart';
import 'about_licences_screen.dart';
import 'affirmations_settings_screen.dart';
import 'calendar_settings_screen.dart';
import 'current_state_settings_screen.dart';
import 'event_categories_settings_screen.dart';
import 'family_hub_settings_screen.dart';
import 'module_management_screen.dart';
import 'notifications_settings_screen.dart';
import 'sensitivity_toggles_screen.dart';
import 'profile_edit_screen.dart';
import 'sharing_privacy_settings_screen.dart';
import 'user_activity_ledger_screen.dart';
import 'instance_library_screen.dart';
import '../household/household_screen.dart';
import '../../providers/auth_provider.dart';
import 'status_shield_settings_screen.dart';
import 'support_presets_settings_screen.dart';
import 'task_defaults_settings_screen.dart';
import 'team_configuration_settings_screen.dart';
import 'companion_settings_screen.dart';
import 'health_status_settings_screen.dart';
import 'reproductive_health_settings_screen.dart';
import 'mental_health_settings_screen.dart';
import 'meals_settings_screen.dart';
import '../tasks/task_pack_library_screen.dart';
import '../debug/ghost_log_gate_screen.dart';
import '../creative/win_dream_screens.dart';
import '../../providers/household_provider.dart';
import 'settings_stub_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final modules = context.watch<ModuleRegistryProvider>();
    final auth = context.watch<AuthProvider>();
    final activeCount = modules.activeModules.length;
    final registeredCount = modules.manageableModules.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // ── Profile header stub ────────────────────────────
          ListTile(
            leading: CircleAvatar(
              child: Text(
                (auth.user?.displayName.isNotEmpty == true
                        ? auth.user!.displayName[0]
                        : '?')
                    .toUpperCase(),
              ),
            ),
            title: Text(auth.user?.displayName ?? 'Your profile'),
            subtitle: Text(auth.user?.email ?? 'Sign in to sync your household'),
            trailing: TextButton(
              onPressed: auth.isSignedIn
                  ? () => _push(context, const ProfileEditScreen())
                  : null,
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
            leading: const Icon(Icons.home_outlined),
            title: const Text('Household'),
            subtitle: const Text('Members, invite code, roles'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _push(context, const HouseholdScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.restaurant_outlined),
            title: const Text('Meals preferences'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _push(context, const MealsSettingsScreen()),
          ),
          const Divider(),

          // ── HEALTH & WELLBEING ─────────────────────────────
          _header('Health & wellbeing'),
          ListTile(
            leading: const Icon(Icons.favorite_outline),
            title: const Text('Health status settings'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _push(context, const HealthStatusSettingsScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.accessibility),
            title: const Text('Reproductive health'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _push(context, const ReproductiveHealthSettingsScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.psychology_outlined),
            title: const Text('Mental health toolkit'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _push(context, const MentalHealthSettingsScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.emoji_events_outlined),
            title: const Text('Win log'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _push(context, const WinLogScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.auto_awesome_outlined),
            title: const Text('Dream board'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _push(context, const DreamBoardScreen()),
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
          ListTile(
            leading: const Icon(Icons.check_circle_outline),
            title: const Text('Task defaults'),
            subtitle: const Text('Default priority, layers, and energy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _push(context, const TaskDefaultsSettingsScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.inventory_2_outlined),
            title: const Text('Task packs'),
            subtitle: const Text('Browse and add suggested packs'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _push(context, const TaskPackLibraryScreen()),
          ),
          const Divider(),

          // ── TEAM & COMPANION ───────────────────────────────
          _header('Team & companion'),
          ListTile(
            leading: const Icon(Icons.groups_outlined),
            title: const Text('Team configuration'),
            subtitle: const Text('Show or hide instances on the grid'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _push(context, const TeamConfigurationSettingsScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.library_books_outlined),
            title: const Text('Instance library'),
            subtitle: const Text('Add or swap team instances'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _push(context, const InstanceLibraryScreen()),
          ),
          _phaseTile(
            context,
            icon: Icons.face_retouching_natural,
            title: 'Instance personalisation',
            phase: '2A+',
            summary: 'Personality, voice, and appearance per instance.',
          ),
          ListTile(
            leading: const Icon(Icons.record_voice_over_outlined),
            title: const Text('Companion settings'),
            subtitle: const Text('Instance, TTS, and presence prefs'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _push(context, const CompanionSettingsScreen()),
          ),
          const Divider(),

          // ── PRIVACY & DATA ─────────────────────────────────
          _header('Privacy & data'),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Sharing & privacy'),
            subtitle: const Text('Household roles and data sensitivity'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _push(context, const SharingPrivacySettingsScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('User activity ledger'),
            subtitle: const Text('Plain-English log of your actions'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _push(context, const UserActivityLedgerScreen()),
          ),
          _phaseTile(
            context,
            icon: Icons.import_export,
            title: 'Data export & delete',
            phase: '2A',
            summary: 'Export JSON per module or delete account data.',
          ),
          ListTile(
            leading: const Icon(Icons.bug_report_outlined),
            title: const Text('Ghost Log (developer)'),
            subtitle: const Text('PIN-protected resolver debug'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _push(context, const GhostLogGateScreen()),
          ),
          const Divider(),

          // ── APP ────────────────────────────────────────────
          _header('App'),
          ListTile(
            leading: const Icon(Icons.auto_awesome_outlined),
            title: const Text('Affirmations'),
            subtitle: const Text('Source and frequency'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _push(context, const AffirmationsSettingsScreen()),
          ),
          _phaseTile(
            context,
            icon: Icons.new_releases_outlined,
            title: "What's new",
            phase: '2A',
            summary: 'Changelog for this build.',
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About & licences'),
            subtitle: const Text('Version 1.0.0 · Phase 1B'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _push(context, const AboutLicencesScreen()),
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign out'),
            onTap: auth.isSignedIn
                ? () async {
                    await context.read<AuthProvider>().signOut();
                    await context.read<HouseholdProvider>().reset();
                  }
                : null,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            child: Text(
              'Version 1.0.0 (Phase 2A — Connection layer)',
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
