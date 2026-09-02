import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/calendar_event.dart';
import '../../providers/calendar_provider.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';
import 'event_creation.dart';

class EventDetailScreen extends StatelessWidget {
  final CalendarEvent event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CalendarProvider>();
    CalendarEvent live = event;
    for (final e in [...provider.events, ...provider.upcoming]) {
      if (e.id == event.id) {
        live = e;
        break;
      }
    }

    final colour = provider.getCategoryColour(live.categoryId);
    final catName = provider.getCategoryName(live.categoryId);
    final titlePrefix =
        live.emoji != null && live.emoji!.isNotEmpty ? '${live.emoji} ' : '';

    final dateStr = DateFormat('EEEE d MMMM yyyy').format(live.startTime);
    String timeStr;
    if (live.isAllDay) {
      timeStr = 'All day';
    } else if (live.endTime != null) {
      timeStr =
          '${DateFormat('h:mm a').format(live.startTime)} — ${DateFormat('h:mm a').format(live.endTime!)}';
    } else {
      timeStr = DateFormat('h:mm a').format(live.startTime);
    }

    return Scaffold(
      backgroundColor: BethColours.background,
      appBar: AppBar(
        backgroundColor: BethColours.surface,
        elevation: 0,
        title: const Text('Event detail', style: BethTypography.heading),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              if (live.categoryId != null)
                Container(
                  width: 14,
                  height: 14,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(color: colour, shape: BoxShape.circle),
                ),
              Expanded(
                child: Text(
                  '$titlePrefix${live.title}'
                  '${catName.isNotEmpty ? ' · $catName' : ''}',
                  style: BethTypography.subheading,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(live.sourceLabel(), style: BethTypography.caption),
          const SizedBox(height: 24),
          _row(Icons.calendar_today, dateStr),
          const SizedBox(height: 12),
          _row(Icons.access_time, timeStr),
          if (live.recurrenceLabel != null) ...[
            const SizedBox(height: 12),
            _row(Icons.repeat, live.recurrenceLabel!),
          ],
          if (live.location != null && live.location!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _row(Icons.place_outlined, live.location!),
          ],
          const SizedBox(height: 12),
          _row(Icons.flag_outlined, 'Priority: ${live.priorityLabel}'),
          if (live.description != null && live.description!.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text('Notes', style: BethTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: BethColours.textPrimary,
            )),
            const SizedBox(height: 6),
            Text(live.description!, style: BethTypography.body),
          ],
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _edit(context, live),
                  child: const Text('Edit event'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: BethColours.red,
                  ),
                  onPressed: () => _delete(context, live),
                  child: const Text('Delete event'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: BethColours.textMuted),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: BethTypography.bodySmall)),
      ],
    );
  }

  Future<void> _edit(BuildContext context, CalendarEvent event) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EventCreation(existing: event),
      ),
    );
  }

  Future<void> _delete(BuildContext context, CalendarEvent event) async {
    final provider = context.read<CalendarProvider>();
    String scope = 'this';

    if (event.isRecurring) {
      final choice = await showDialog<String>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Delete recurring event'),
          content: const Text(
            'Delete this event only, or all future events?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, 'cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, 'this'),
              child: const Text('This only'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, 'future'),
              child: const Text('All future'),
            ),
          ],
        ),
      );
      if (choice == null || choice == 'cancel') return;
      scope = choice;
    } else {
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Delete event?'),
          content: Text('Remove "${event.title}" from the calendar?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(
                'Delete',
                style: TextStyle(color: BethColours.red),
              ),
            ),
          ],
        ),
      );
      if (ok != true) return;
    }

    // Phase 1B: single-occurrence delete; "all future" deletes this row
    // (occurrence expansion is backend-generated later).
    await provider.deleteEvent(event.id);
    if (scope == 'future') {
      // Placeholder for series delete when recurrence instances exist.
    }
    if (context.mounted) Navigator.pop(context);
  }
}
