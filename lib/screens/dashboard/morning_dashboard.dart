import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';
import '../../widgets/status_shield.dart';
import '../../widgets/affirmation_card.dart';
import '../../widgets/children_summary_card.dart';

class MorningDashboard extends StatelessWidget {
  const MorningDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // TODO: Open side drawer
          },
        ),
        title: const Text('Good morning, Beth'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  // TODO: Open notifications panel
                },
              ),
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: BethColours.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
            ],
          ),
          const CircleAvatar(
            radius: 16,
            backgroundColor: BethColours.primary,
            child: Text('B', style: TextStyle(color: Colors.white, fontSize: 14)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Affirmation
            const AffirmationCard(),
            const SizedBox(height: 20),

            // Children summary card
            const ChildrenSummaryCard(),
            const SizedBox(height: 20),

            // Today's schedule
            _sectionHeader('Today', 'See all'),
            const SizedBox(height: 8),
            _scheduleItem('9:00 AM', 'Evander — Paediatrician', BethColours.evander),
            const SizedBox(height: 8),
            _scheduleItem('2:00 PM', 'Team meeting — Work', BethColours.work),
            const SizedBox(height: 4),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add event'),
              style: TextButton.styleFrom(foregroundColor: BethColours.textMuted),
            ),
            const SizedBox(height: 20),

            // Cycle day indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: BethColours.surfaceAlt,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.water_drop_outlined, size: 16, color: BethColours.textMuted),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Day 14 · Follicular phase · Energy may feel higher today',
                      style: BethTypography.caption,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Urgent section
            _sectionHeader('Urgent', null),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: BethColours.red.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: BethColours.red.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.priority_high, color: BethColours.red, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Interview prep — Cairns Community Health (tomorrow)',
                      style: BethTypography.bodySmall?.copyWith(color: BethColours.red),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Snoozed section
            _sectionHeader('Snoozed', '2 items'),
            const SizedBox(height: 8),
            _snoozedItem('Research paediatric dentists', 'Remind tonight'),
            const SizedBox(height: 6),
            _snoozedItem('Update CV — aged care section', 'Remind tomorrow'),
            const SizedBox(height: 24),

            // Status Shield
            const StatusShield(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, String? action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: BethTypography.subheading),
        if (action != null)
          TextButton(
            onPressed: () {},
            child: Text(action, style: BethTypography.caption?.copyWith(color: BethColours.primary)),
          ),
      ],
    );
  }

  Widget _scheduleItem(String time, String title, Color colour) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: BethColours.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: colour, width: 3)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(time, style: BethTypography.caption?.copyWith(fontWeight: FontWeight.w500)),
          ),
          Expanded(child: Text(title, style: BethTypography.bodySmall)),
        ],
      ),
    );
  }

  Widget _snoozedItem(String title, String reminder) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: BethColours.surfaceAlt,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                title,
                style: BethTypography.bodySmall?.copyWith(color: BethColours.textMuted),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: Text(
                reminder,
                style: BethTypography.caption,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }
}