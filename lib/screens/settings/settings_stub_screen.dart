import 'package:flutter/material.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';

/// Phase-labeled or coming-soon settings destination.
class SettingsStubScreen extends StatelessWidget {
  const SettingsStubScreen({
    super.key,
    required this.title,
    this.phase,
    this.summary,
    this.children = const [],
  });

  final String title;
  final String? phase;
  final String? summary;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final phaseLabel = phase == null ? 'Coming soon' : 'Coming in Phase $phase';
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(phaseLabel, style: BethTypography.caption.copyWith(color: BethColours.textMuted)),
          if (summary != null) ...[
            const SizedBox(height: 8),
            Text(summary!, style: BethTypography.bodySmall),
          ],
          if (children.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(),
            ...children,
          ],
        ],
      ),
    );
  }
}

void openSettingsStub(
  BuildContext context, {
  required String title,
  String? phase,
  String? summary,
}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => SettingsStubScreen(
        title: title,
        phase: phase,
        summary: summary,
      ),
    ),
  );
}
