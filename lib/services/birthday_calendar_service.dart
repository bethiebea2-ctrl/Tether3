import 'package:uuid/uuid.dart';
import '../core/family/person_age_utils.dart';
import '../database/calendar_dao.dart';
import '../models/calendar_event.dart';
import '../models/person.dart';

enum BirthdaySyncChoice { keepCalendar, useDob, cancel }

class BirthdayCalendarService {
  final CalendarDao _dao = CalendarDao();
  final _uuid = const Uuid();

  static const _yearlyTypes = {'birthday', 'memorial', 'anniversary'};

  /// Sync birthday, memorial, and anniversary calendar events for a person.
  Future<Person> syncPersonCalendar({
    required Person person,
    BirthdaySyncChoice? conflictChoice,
  }) async {
    var updated = person;
    if (person.dateOfBirth != null) {
      updated = await syncBirthday(person: updated, conflictChoice: conflictChoice);
    } else {
      updated = await _clearEvent(updated, 'birthday', (p) => p.calendarBirthdayEventId);
    }
    updated = await _syncMemorial(updated);
    updated = await _syncAnniversary(updated);
    return updated;
  }

  /// Returns true if caller should show conflict dialog.
  Future<bool> needsBirthdayConflictPrompt(Person person) async {
    if (person.dateOfBirth == null) return false;
    final existing = await _findEvent(person, 'birthday', person.calendarBirthdayEventId);
    if (existing == null) return false;
    final dob = person.dateOfBirth!;
    final eventDay = DateTime(
      existing.startTime.year,
      existing.startTime.month,
      existing.startTime.day,
    );
    final dobDay = DateTime(dob.year, dob.month, dob.day);
    return eventDay.month != dobDay.month || eventDay.day != dobDay.day;
  }

  Future<CalendarEvent?> _findEvent(
    Person person,
    String eventType,
    String? storedId,
  ) async {
    if (storedId != null) {
      return _dao.getEventById(storedId);
    }
    return _dao.getPersonEventByType(person.id, eventType);
  }

  Future<Person> syncBirthday({
    required Person person,
    BirthdaySyncChoice? conflictChoice,
  }) async {
    if (person.dateOfBirth == null) return person;

    final dob = person.dateOfBirth!;
    final existing = await _findEvent(person, 'birthday', person.calendarBirthdayEventId);

    if (existing != null) {
      final eventMonthDay = (existing.startTime.month, existing.startTime.day);
      final dobMonthDay = (dob.month, dob.day);
      if (eventMonthDay == dobMonthDay) {
        final refreshed = _birthdayEvent(
          person,
          dob,
          existingId: existing.id,
          preserveCreatedAt: existing.createdAt,
        );
        await _dao.updateEvent(refreshed);
        return person.copyWith(calendarBirthdayEventId: refreshed.id);
      }
      if (conflictChoice == BirthdaySyncChoice.keepCalendar) {
        return person.copyWith(calendarBirthdayEventId: existing.id);
      }
      if (conflictChoice == BirthdaySyncChoice.cancel) {
        return person;
      }
      // useDob (or default when dates already match): align calendar to DOB.
      final updated = _birthdayEvent(
        person,
        dob,
        existingId: existing.id,
        preserveCreatedAt: existing.createdAt,
      );
      await _dao.updateEvent(updated);
      return person.copyWith(calendarBirthdayEventId: updated.id);
    }

    final event = _birthdayEvent(person, dob);
    await _dao.insertEvent(event);
    return person.copyWith(calendarBirthdayEventId: event.id);
  }

  Future<Person> _syncMemorial(Person person) async {
    if (person.dateOfDeath == null) {
      return _clearEvent(person, 'memorial', (p) => p.calendarMemorialEventId);
    }
    final dod = person.dateOfDeath!;
    final existing =
        await _findEvent(person, 'memorial', person.calendarMemorialEventId);
    final event = _memorialEvent(person, dod, existingId: existing?.id);
    if (existing != null) {
      await _dao.updateEvent(event);
    } else {
      await _dao.insertEvent(event);
    }
    return person.copyWith(calendarMemorialEventId: event.id);
  }

  Future<Person> _syncAnniversary(Person person) async {
    if (person.anniversaryDate == null) {
      return _clearEvent(
        person,
        'anniversary',
        (p) => p.calendarAnniversaryEventId,
      );
    }
    final ann = person.anniversaryDate!;
    final existing = await _findEvent(
      person,
      'anniversary',
      person.calendarAnniversaryEventId,
    );
    final event = _anniversaryEvent(person, ann, existingId: existing?.id);
    if (existing != null) {
      await _dao.updateEvent(event);
    } else {
      await _dao.insertEvent(event);
    }
    return person.copyWith(calendarAnniversaryEventId: event.id);
  }

  Future<Person> _clearEvent(
    Person person,
    String eventType,
    String? Function(Person) eventId,
  ) async {
    final id = eventId(person);
    if (id != null) {
      await _dao.deleteEvent(id);
    } else {
      final existing = await _dao.getPersonEventByType(person.id, eventType);
      if (existing != null) await _dao.deleteEvent(existing.id);
    }
    switch (eventType) {
      case 'birthday':
        return person.copyWith(clearCalendarBirthdayEventId: true);
      case 'memorial':
        return person.copyWith(clearCalendarMemorialEventId: true);
      case 'anniversary':
        return person.copyWith(clearCalendarAnniversaryEventId: true);
      default:
        return person;
    }
  }

  CalendarEvent _birthdayEvent(
    Person person,
    DateTime dob, {
    String? existingId,
    DateTime? preserveCreatedAt,
  }) {
    final now = DateTime.now();
    final name = personDisplayName(person);
    final turning = ageTurningOnNextBirthday(dob, from: now);
    final title = person.isDeceased
        ? "In memory — $name's birthday (would be turning $turning)"
        : "$name's birthday (turning $turning)";
    final start = _nextYearlyDate(dob, from: now);
    return CalendarEvent(
      id: existingId ?? _uuid.v4(),
      householdId: 'default',
      title: title,
      startTime: start,
      endTime: null,
      isAllDay: true,
      categoryId: person.calendarCategoryId ?? 'family',
      personId: person.id,
      emoji: person.isPet ? '🐾' : (person.isDeceased ? '🕯️' : '🎂'),
      priority: 'important',
      recurrenceRule: 'yearly',
      source: 'family_hub',
      eventType: 'birthday',
      createdAt: preserveCreatedAt ?? now,
      updatedAt: now,
    );
  }

  CalendarEvent _memorialEvent(Person person, DateTime dod, {String? existingId}) {
    final now = DateTime.now();
    final name = personDisplayName(person);
    final years = _yearsSince(dod, from: now);
    final start = _nextYearlyDate(dod, from: now);
    return CalendarEvent(
      id: existingId ?? _uuid.v4(),
      householdId: 'default',
      title: years > 0
          ? "Memorial — $name ($years ${years == 1 ? 'year' : 'years'})"
          : 'Memorial — $name',
      startTime: start,
      endTime: null,
      isAllDay: true,
      categoryId: person.calendarCategoryId ?? 'family',
      personId: person.id,
      emoji: '🕯️',
      priority: 'important',
      recurrenceRule: 'yearly',
      source: 'family_hub',
      eventType: 'memorial',
      createdAt: now,
      updatedAt: now,
    );
  }

  CalendarEvent _anniversaryEvent(Person person, DateTime ann, {String? existingId}) {
    final now = DateTime.now();
    final name = personDisplayName(person);
    final years = _yearsSince(ann, from: now);
    final start = _nextYearlyDate(ann, from: now);
    return CalendarEvent(
      id: existingId ?? _uuid.v4(),
      householdId: 'default',
      title: years > 0
          ? "$name's anniversary ($years ${years == 1 ? 'year' : 'years'})"
          : "$name's anniversary",
      startTime: start,
      endTime: null,
      isAllDay: true,
      categoryId: person.calendarCategoryId ?? 'family',
      personId: person.id,
      emoji: person.isDeceased ? '🕯️' : '💍',
      priority: 'important',
      recurrenceRule: 'yearly',
      source: 'family_hub',
      eventType: 'anniversary',
      createdAt: now,
      updatedAt: now,
    );
  }

  int _yearsSince(DateTime anchor, {DateTime? from}) {
    final now = from ?? DateTime.now();
    var years = now.year - anchor.year;
    if (now.month < anchor.month ||
        (now.month == anchor.month && now.day < anchor.day)) {
      years--;
    }
    return years < 0 ? 0 : years;
  }

  DateTime _nextYearlyDate(DateTime anchor, {DateTime? from}) {
    final now = from ?? DateTime.now();
    var year = now.year;
    final thisYear = DateTime(year, anchor.month, anchor.day);
    if (thisYear.isBefore(DateTime(now.year, now.month, now.day))) {
      year += 1;
    }
    return DateTime(year, anchor.month, anchor.day);
  }

  static bool isYearlyPersonEvent(String? eventType) =>
      eventType != null && _yearlyTypes.contains(eventType);
}
