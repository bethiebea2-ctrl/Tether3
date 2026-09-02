import 'package:flutter/material.dart';
import '../../theme/typography.dart';

class ClarificationCard extends StatelessWidget {
  final String originalText;
  final String question;
  final TextEditingController controller;
  final VoidCallback onSubmit;
  final bool collapsed;
  final String? clarifiedSummary;
  final bool isLoading;
  final List<String> examples;

  const ClarificationCard({
    super.key,
    required this.originalText,
    required this.question,
    required this.controller,
    required this.onSubmit,
    this.collapsed = false,
    this.clarifiedSummary,
    this.isLoading = false,
    this.examples = const [
      "Evander's paediatric checkup",
      'Team meeting',
      'Dinner with Ant',
    ],
  });

  @override
  Widget build(BuildContext context) {
    if (collapsed) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade300.withOpacity(0.6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          "✓ Clarified: '${clarifiedSummary ?? ''}'",
          style: BethTypography.bodySmall?.copyWith(color: Colors.grey.shade700),
        ),
      );
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF4A3A20),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '⚠ NEEDS MORE DETAILS',
            style: BethTypography.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You said: "$originalText"',
            style: BethTypography.caption?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 10),
          Text(
            'I need to know:',
            style: BethTypography.caption?.copyWith(color: Colors.white70),
          ),
          Text(
            question,
            style: BethTypography.bodySmall?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Your answer...',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              filled: true,
              fillColor: Colors.black26,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            onSubmitted: (_) => onSubmit(),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
              onPressed: isLoading ? null : onSubmit,
              child: Text(isLoading ? 'Submitting...' : 'Submit'),
            ),
          ),
          if (examples.isNotEmpty) ...[
            const Divider(color: Colors.white24, height: 20),
            Text(
              '💡 Examples:',
              style: BethTypography.caption?.copyWith(color: Colors.white70),
            ),
            ...examples.map(
              (e) => Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  '"$e"',
                  style: BethTypography.caption?.copyWith(color: Colors.white60),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
