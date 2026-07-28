import '../core/family/person_age_utils.dart';
import '../database/calendar_dao.dart';
import '../database/family_care_dao.dart';
import '../models/person.dart';

class PersonUrgentLine {
  final String personId;
  final String line;

  PersonUrgentLine({required this.personId, required this.line});
}

class FamilyHubUrgencyService {
  final FamilyCareDao _care = FamilyCareDao();
  final CalendarDao _calendar = CalendarDao();

  Future<List<PersonUrgentLine>> urgentLinesForPeople(List<Person> people) async {
    final lines = <PersonUrgentLine>[];
    for (final person in people) {
      if (person.isPet) continue;
      final line = await _urgentFor(person);
      if (line != null) {
        lines.add(PersonUrgentLine(personId: person.id, line: line));
      }
    }
    return lines;
  }

  Future<String?> _urgentFor(Person person) async {
    final name = personDisplayName(person);
    if (person.ageStage == 'baby' || person.ageStage == 'toddler') {
      final meds = await _care.getMedications(person.id);
      for (final med in meds) {
        final last = med['last_given'] as String?;
        final hours = med['minimum_interval_hours'] as int? ?? 4;
        if (last == null) {
          return '$name · ${med['name']} available';
        }
        final lastDt = DateTime.tryParse(last);
        if (lastDt != null) {
          final next = lastDt.add(Duration(hours: hours));
          if (DateTime.now().isAfter(next)) {
            return '$name · ${med['name']} available';
          }
        }
      }
      final feed = await _care.getLastFeed(person.id);
      if (feed != null) {
        final at = DateTime.tryParse(feed['logged_at'] as String? ?? '');
        if (at != null) {
          final ago = DateTime.now().difference(at);
          if (ago.inHours >= 3) {
            return '$name · last feed ${ago.inHours}h ago';
          }
        }
      }
    }

    final upcoming = await _calendar.getUpcomingForPerson(person.id, limit: 1);
    if (upcoming.isNotEmpty) {
      final e = upcoming.first;
      return '$name · ${e.title} soon';
    }
    return null;
  }
}
