import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_prefs_provider.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';

class CalendarSettingsScreen extends StatelessWidget {
  const CalendarSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = context.watch<SettingsPrefsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Calendar settings')),
      body: ListView(
        children: [
          _header('Default view'),
          for (final entry in const [
            ('month', 'Month'),
            ('week', 'Week'),
            ('day', 'Day'),
            ('agenda', 'Agenda'),
          ])
            RadioListTile<String>(
              title: Text(entry.$2),
              value: entry.$1,
              groupValue: prefs.calendarDefaultView,
              onChanged: (v) => prefs.setCalendarDefaultView(v!),
            ),
          _header('Week starts on'),
          RadioListTile<String>(
            title: const Text('Monday'),
            value: 'monday',
            groupValue: prefs.weekStartsOn,
            onChanged: (v) => prefs.setWeekStartsOn(v!),
          ),
          RadioListTile<String>(
            title: const Text('Sunday'),
            value: 'sunday',
            groupValue: prefs.weekStartsOn,
            onChanged: (v) => prefs.setWeekStartsOn(v!),
          ),
          _header('Buffer time'),
          ListTile(
            title: const Text('Default buffer between events'),
            trailing: DropdownButton<String>(
              value: prefs.bufferMinutes,
              items: const [
                DropdownMenuItem(value: '0', child: Text('None')),
                DropdownMenuItem(value: '5', child: Text('5 minutes')),
                DropdownMenuItem(value: '15', child: Text('15 minutes')),
                DropdownMenuItem(value: '30', child: Text('30 minutes')),
              ],
              onChanged: (v) {
                if (v != null) prefs.setBufferMinutes(v);
              },
            ),
          ),
          _header('Conflict detection'),
          SwitchListTile(
            title: const Text('Warn if events overlap'),
            value: prefs.warnOverlap,
            onChanged: prefs.setWarnOverlap,
          ),
          SwitchListTile(
            title: const Text('Block overlapping events'),
            value: prefs.blockOverlap,
            onChanged: prefs.setBlockOverlap,
          ),
          _header('Cycle overlay'),
          SwitchListTile(
            title: const Text('Show cycle phases on calendar'),
            value: prefs.showCyclePhases,
            onChanged: prefs.setShowCyclePhases,
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
