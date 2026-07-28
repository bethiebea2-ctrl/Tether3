import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_prefs_provider.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';

class AccessibilitySettingsScreen extends StatelessWidget {
  const AccessibilitySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = context.watch<SettingsPrefsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Accessibility')),
      body: ListView(
        children: [
          _header('Visual'),
          ListTile(
            title: const Text('Font size'),
            subtitle: Text(prefs.fontSize),
            trailing: DropdownButton<String>(
              value: prefs.fontSize,
              items: const [
                DropdownMenuItem(value: 'small', child: Text('Small')),
                DropdownMenuItem(value: 'medium', child: Text('Medium')),
                DropdownMenuItem(value: 'large', child: Text('Large')),
                DropdownMenuItem(value: 'xlarge', child: Text('Extra large')),
              ],
              onChanged: (v) {
                if (v != null) prefs.setFontSize(v);
              },
            ),
          ),
          ..._toggles(prefs, const [
            ('opendyslexic', 'OpenDyslexic font'),
            ('high_contrast', 'High contrast'),
            ('soft_contrast', 'Soft contrast'),
            ('reduced_motion', 'Reduced motion'),
            ('disable_animations', 'Disable animations'),
            ('no_flashing', 'No flashing/strobing'),
            ('colour_overlays', 'Colour overlays'),
            ('large_buttons', 'Large buttons'),
            ('simplified_dashboard', 'Simplified dashboard'),
          ]),
          _header('Audio'),
          ..._toggles(prefs, const [
            ('silent_mode', 'Silent mode'),
            ('vibration_only', 'Vibration only'),
            ('visual_alerts_audio', 'Visual alerts for audio'),
            ('captions', 'Captions for all media'),
            ('no_sharp_tones', 'No sharp alert tones'),
          ]),
          _header('Interaction'),
          ..._toggles(prefs, const [
            ('screen_reader', 'Screen reader optimised'),
            ('voice_input', 'Voice input prioritised'),
            ('tts_default', 'Text-to-speech by default'),
            ('one_handed', 'One-handed mode'),
            ('reduced_precision', 'Reduced precision input'),
            ('switch_access', 'Switch access support'),
            ('keyboard_nav', 'Keyboard navigation'),
          ]),
          _header('Cognitive'),
          ..._toggles(prefs, const [
            ('plain_language', 'Plain language by default'),
            ('simplified_text', 'Simplified text mode'),
            ('one_step', 'One step at a time'),
            ('confirm_destructive', 'Confirm before destructive actions'),
            ('undo_30s', 'Undo available (30 sec)'),
            ('reduced_choices', 'Reduced choices'),
          ]),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.restart_alt),
            title: const Text('Reset to defaults'),
            onTap: () => prefs.resetAccessibility(),
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

  List<Widget> _toggles(SettingsPrefsProvider prefs, List<(String, String)> items) {
    return items
        .map(
          (item) => SwitchListTile(
            title: Text(item.$2),
            value: prefs.isAccessibilityOn(item.$1),
            onChanged: (_) => prefs.toggleAccessibility(item.$1),
          ),
        )
        .toList();
  }
}
