import 'package:flutter/material.dart';
import '../theme/typography.dart';
import '../theme/colours.dart';

class AffirmationCard extends StatelessWidget {
  const AffirmationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          'You have everything you need for today.',
          style: BethTypography.affirmation,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}