import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/calendar_event.dart';
import '../../providers/calendar_provider.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';

/// Shared event row used in month detail, agenda, and week lists.
class CalendarEventTile extends StatelessWidget {
  final CalendarEvent event;
  final VoidCallback? onTap;
  final bool showDate;
  final bool compact;

  const CalendarEventTile({
    super.key,
    required this.event,
    this.onTap,
    this.showDate = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CalendarProvider>();
    final colour = provider.getCategoryColour(event.categoryId);
    final catName = provider.getCategoryName(event.categoryId);
    final muted = event.normalisedPriority == 'routine';

    final timeStr = event.isAllDay
        ? 'All day'
        : DateFormat('h:mm a').format(event.startTime);

    final titlePrefix = event.emoji != null && event.emoji!.isNotEmpty
        ? '${event.emoji} '
        : '';

    return Opacity(
      opacity: muted ? 0.65 : 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: compact ? 6 : 10,
            horizontal: 4,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (event.categoryId != null)
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.only(top: 4, right: 10),
                  decoration: BoxDecoration(
                    color: colour,
                    shape: BoxShape.circle,
                  ),
                )
              else
                const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          timeStr,
                          style: BethTypography.bodySmall.copyWith(
                            fontWeight: FontWeight.w700,
                            color: BethColours.textPrimary,
                            fontSize: 14,
                          ),
                        ),
                        if (event.normalisedPriority == 'urgent') ...[
                          const SizedBox(width: 8),
                          Text(
                            '⚠',
                            style: BethTypography.caption.copyWith(
                              color: BethColours.red,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$titlePrefix${event.title}'
                      '${catName.isNotEmpty ? ' · $catName' : ''}',
                      style: BethTypography.bodySmall.copyWith(
                        fontSize: 14,
                        color: BethColours.textPrimary,
                      ),
                    ),
                    if (!compact) ...[
                      const SizedBox(height: 2),
                      Text(
                        event.sourceLabel(),
                        style: BethTypography.caption.copyWith(fontSize: 11),
                      ),
                      if (event.recurrenceLabel != null)
                        Text(
                          event.recurrenceLabel!,
                          style: BethTypography.caption.copyWith(fontSize: 11),
                        ),
                      if (showDate)
                        Text(
                          DateFormat('EEE d MMM').format(event.startTime),
                          style: BethTypography.caption.copyWith(fontSize: 11),
                        ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
