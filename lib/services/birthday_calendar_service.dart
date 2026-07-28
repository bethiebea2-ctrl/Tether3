import 'package:uuid/uuid.dart';
import '../database/calendar_dao.dart';
import '../models/calendar_event.dart';
import '../models/person.dart';

enum BirthdaySyncChoice { keepCalendar, useDob, cancel }

class BirthdayCalendarService {
  final CalendarDao _dao = CalendarDao();
  final _uuid = const Uuid();

  /// Returns true if caller should show conflict dialog.
  Future<bool> needsBirthdayConflictPrompt(Person person) async {
    if (person.dateOfBirth == null) return false;
    final existing = await _findBirthdayEvent(person);
    if (existing == null) return false;
    final dob = person.dateOfBirth!;
    final eventDay = DateTime(existing.startTime.year, existing.startTime.month, existing.startTime.day);
    final dobDay = DateTime(dob.year, dob.month, dob.day);
    return eventDay.month != dobDay.month || eventDay.day != dobDay.day;
  }

  Future<CalendarEvent?> _findBirthdayEvent(Person person) async {
    if (person.calendarBirthdayEventId != null) {
      return _dao.getEventById(person.calendarBirthdayEventId!);
    }
    return _dao.getBirthdayEventForPerson(person.id);
  }

  Future<Person> syncBirthday({
    required Person person,
    BirthdaySyncChoice? conflictChoice,
  }) async {
    if (person.dateOfBirth == null) return person;

    final dob = person.dateOfBirth!;
    final existing = await _findBirthdayEvent(person);

    if (existing != null) {
      final eventMonthDay = (existing.startTime.month, existing.startTime.day);
      final dobMonthDay = (dob.month, dob.day);
      if (eventMonthDay == dobMonthDay) {
        return person.copyWith(calendarBirthdayEventId: existing.id);
      }
      if (conflictChoice == BirthdaySyncChoice.keepCalendar) {
        return person.copyWith(calendarBirthdayEventId: existing.id);
      }
      if (conflictChoice == BirthdaySyncChoice.cancel) {
        return person;
      }
      // useDob — update event
      final updated = _birthdayEvent(person, dob, existingId: existing.id);
      await _dao.updateEvent(updated);
      return person.copyWith(calendarBirthdayEventId: updated.id);
    }

    final event = _birthdayEvent(person, dob);
    await _dao.insertEvent(event);
    return person.copyWith(calendarBirthdayEventId: event.id);
  }

  CalendarEvent _birthdayEvent(Person person, DateTime dob, {String? existingId}) {
    final now = DateTime.now();
    final name = person.preferredName ?? person.displayName;
    final year = now.year;
    final start = DateTime(year, dob.month, dob.day);
    return CalendarEvent(
      id: existingId ?? _uuid.v4(),
      householdId: 'default',
      title: "$name's birthday",
      startTime: start,
      endTime: null,
      categoryId: person.calendarCategoryId ?? 'family',
      personId: person.id,
      priority: 'normal',
      source: 'family_hub',
      eventType: 'birthday',
      createdAt: now,
      updatedAt: now,
    );
  }
}
