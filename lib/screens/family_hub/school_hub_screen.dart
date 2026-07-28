import 'package:flutter/material.dart';
import '../../models/person.dart';
import '../../theme/typography.dart';

/// Placeholder for school-aged children (Phase 1D).
class SchoolHubScreen extends StatelessWidget {
  final Person person;
  const SchoolHubScreen({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${person.displayName} · School')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('School hub', style: BethTypography.subheading),
            const SizedBox(height: 8),
            const Text(
              'Timetable, teacher contacts, and permission slips will live here in a later phase.',
            ),
          ],
        ),
      ),
    );
  }
}
