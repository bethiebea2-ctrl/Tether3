import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
import '../theme/typography.dart';

class AffirmationCard extends StatelessWidget {
  const AffirmationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final text = context.watch<DashboardProvider>().displayAffirmation;
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 8),
      child: Text(
        text,
        style: BethTypography.affirmation,
        textAlign: TextAlign.left,
      ),
    );
  }
}
