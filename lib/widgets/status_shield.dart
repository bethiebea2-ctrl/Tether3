import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
import '../theme/typography.dart';
import '../theme/colours.dart';

class StatusShield extends StatelessWidget {
  const StatusShield({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();
    final isHeadsDown = provider.statusShield == 'Heads down today';
    final colour = isHeadsDown ? BethColours.statusHeadsDown : BethColours.statusOpen;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colour.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colour.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            isHeadsDown ? Icons.headset_off : Icons.headset_mic,
            color: colour,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.statusShield,
                  style: BethTypography.body?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colour,
                  ),
                ),
                if (provider.statusShieldExpiry != null)
                  Text(
                    'Until ${_formatTime(provider.statusShieldExpiry!)} · ${provider.heldNotificationCount} held',
                    style: BethTypography.caption,
                  ),
              ],
            ),
          ),
          Switch(
            value: isHeadsDown,
            onChanged: (_) => provider.toggleStatusShield(),
            activeColor: BethColours.statusHeadsDown,
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final amPm = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:00 $amPm';
  }
}