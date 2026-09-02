import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_prefs_provider.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';

class NotificationsSettingsScreen extends StatelessWidget {
  const NotificationsSettingsScreen({super.key});

  Future<void> _pickQuietTime(
    BuildContext context, {
    required bool isStart,
  }) async {
    final prefs = context.read<SettingsPrefsProvider>();
    final current = isStart ? prefs.quietHoursStart : prefs.quietHoursEnd;
    final parts = current.split(':');
    final initial = TimeOfDay(
      hour: int.tryParse(parts[0]) ?? (isStart ? 21 : 7),
      minute: int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0,
    );
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      helpText: isStart ? 'Quiet hours start' : 'Quiet hours end',
    );
    if (picked == null) return;
    final formatted =
        '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    if (isStart) {
      await prefs.setQuietHoursStart(formatted);
    } else {
      await prefs.setQuietHoursEnd(formatted);
    }
  }

  @override
  Widget build(BuildContext context) {
    final prefs = context.watch<SettingsPrefsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        children: [
          _header('Delivery mode'),
          RadioListTile<String>(
            title: const Text('Real-Time'),
            subtitle: const Text('Send as they happen'),
            value: 'realtime',
            groupValue: prefs.deliveryMode,
            onChanged: (v) => prefs.setDeliveryMode(v!),
          ),
          RadioListTile<String>(
            title: const Text('Digest'),
            subtitle: const Text('Batched summaries'),
            value: 'digest',
            groupValue: prefs.deliveryMode,
            onChanged: (v) => prefs.setDeliveryMode(v!),
          ),
          RadioListTile<String>(
            title: const Text('Hybrid (recommended)'),
            subtitle: const Text('Urgent real-time, rest in digest'),
            value: 'hybrid',
            groupValue: prefs.deliveryMode,
            onChanged: (v) => prefs.setDeliveryMode(v!),
          ),
          _header('Quiet hours'),
          SwitchListTile(
            title: const Text('Enabled'),
            subtitle: Text(
              'Mute non-urgent alerts between ${prefs.quietHoursStart} and ${prefs.quietHoursEnd}. '
              'Useful for night shift too — set any window.',
            ),
            value: prefs.quietHoursEnabled,
            onChanged: prefs.setQuietHoursEnabled,
          ),
          ListTile(
            enabled: prefs.quietHoursEnabled,
            title: const Text('Starts'),
            subtitle: Text(prefs.quietHoursStart),
            trailing: const Icon(Icons.schedule),
            onTap: prefs.quietHoursEnabled
                ? () => _pickQuietTime(context, isStart: true)
                : null,
          ),
          ListTile(
            enabled: prefs.quietHoursEnabled,
            title: const Text('Ends'),
            subtitle: Text(prefs.quietHoursEnd),
            trailing: const Icon(Icons.schedule),
            onTap: prefs.quietHoursEnabled
                ? () => _pickQuietTime(context, isStart: false)
                : null,
          ),
          SwitchListTile(
            title: const Text('Allow urgent during quiet hours'),
            value: prefs.allowUrgentDuringQuiet,
            onChanged: prefs.setAllowUrgentDuringQuiet,
          ),
          _header('Urgent override'),
          SwitchListTile(
            title: const Text('Urgent notifications always bypass digest and quiet hours'),
            value: prefs.urgentBypass,
            onChanged: prefs.setUrgentBypass,
          ),
          _header('Notification types'),
          ...const [
            ('calendar', 'Calendar reminders'),
            ('tasks', 'Task deadlines'),
            ('medication', 'Medication reminders'),
            ('family', 'Family updates'),
            ('budget', 'Budget alerts'),
            ('meals', 'Meal suggestions'),
            ('resources', 'Resource updates'),
            ('team', 'Team activity'),
          ].map(
            (e) => SwitchListTile(
              title: Text(e.$2),
              value: prefs.notificationTypes.contains(e.$1),
              onChanged: (_) => prefs.toggleNotificationType(e.$1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Partner notification sharing arrives in Phase 2A.',
              style: BethTypography.caption.copyWith(color: BethColours.textMuted),
            ),
          ),
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
