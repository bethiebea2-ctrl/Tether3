import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/person.dart';
import '../../providers/calendar_provider.dart';
import '../../providers/family_hub_provider.dart';
import '../../services/birthday_calendar_service.dart';

/// Shows Keep calendar / Use DOB when DOB changes conflict with linked birthday event.
Future<BirthdaySyncChoice?> showBirthdaySyncDialog(BuildContext context) {
  return showDialog<BirthdaySyncChoice>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Birthday on calendar'),
      content: const Text(
        'The calendar birthday does not match the date of birth. Which should we use?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, BirthdaySyncChoice.keepCalendar),
          child: const Text('Keep calendar'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, BirthdaySyncChoice.useDob),
          child: const Text('Keep date of birth'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, BirthdaySyncChoice.cancel),
          child: const Text('Cancel'),
        ),
      ],
    ),
  );
}

Future<Person?> savePersonResolvingBirthday(
  BuildContext context,
  Person person, {
  BirthdaySyncChoice? preselected,
}) async {
  final hub = context.read<FamilyHubProvider>();
  final service = BirthdayCalendarService();
  BirthdaySyncChoice? choice = preselected;
  if (person.dateOfBirth != null && choice == null) {
    final needs = await service.needsBirthdayConflictPrompt(person);
    if (needs && context.mounted) {
      choice = await showBirthdaySyncDialog(context);
      if (choice == null || choice == BirthdaySyncChoice.cancel) return null;
    }
  }
  final saved = await hub.savePerson(person, birthdayChoice: choice, awaitBirthday: true);
  if (saved != null && context.mounted) {
    final calendar = context.read<CalendarProvider>();
    await calendar.loadEvents();
    await calendar.loadUpcoming();
  }
  return saved;
}
