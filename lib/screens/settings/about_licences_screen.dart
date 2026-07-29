import 'package:flutter/material.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';

class AboutLicencesScreen extends StatelessWidget {
  const AboutLicencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BethColours.background,
      appBar: AppBar(title: const Text('About & licences')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Tether', style: BethTypography.heading),
          const SizedBox(height: 4),
          Text('Version 1.0.0 · Phase 1B complete', style: BethTypography.bodySmall),
          const SizedBox(height: 16),
          Text(
            'Tether is a life-coordination app: capture once, route intelligently, '
            'and keep household care calm and shame-free.',
            style: BethTypography.body,
          ),
          const SizedBox(height: 24),
          Text('Credits', style: BethTypography.subheading),
          const SizedBox(height: 8),
          Text('Product & design: Bethany Clulow', style: BethTypography.bodySmall),
          Text('Built with Flutter', style: BethTypography.bodySmall),
          const SizedBox(height: 24),
          Text('Open-source licences', style: BethTypography.subheading),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Flutter / Dart SDK'),
            subtitle: const Text('BSD-style licence'),
            onTap: () => showLicensePage(
              context: context,
              applicationName: 'Tether',
              applicationVersion: '1.0.0',
            ),
          ),
          Text(
            'Tap above to view package licences shipped with this build.',
            style: BethTypography.caption?.copyWith(color: BethColours.textMuted),
          ),
        ],
      ),
    );
  }
}
