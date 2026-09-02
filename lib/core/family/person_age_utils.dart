import '../../models/person.dart';

/// Age stage from date of birth per Family Hub spec.
String ageStageFromDateOfBirth(DateTime dob) {
  final now = DateTime.now();
  int years = now.year - dob.year;
  if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
    years--;
  }
  if (years < 0) return 'baby';
  if (years < 2) return 'baby';
  if (years < 5) return 'toddler';
  if (years < 13) return 'child';
  if (years < 18) return 'teen';
  return 'adult';
}

String ageDisplayLabel(Person person) {
  if (person.dateOfBirth == null) return '';
  final dob = person.dateOfBirth!;
  final now = DateTime.now();
  int months = (now.year - dob.year) * 12 + now.month - dob.month;
  if (now.day < dob.day) months--;
  if (months < 24) return '$months months';
  return '${months ~/ 12} years';
}

String personDisplayName(Person person) =>
    person.preferredName?.isNotEmpty == true ? person.preferredName! : person.displayName;

/// Age they will turn on their next birthday (for calendar titles).
int ageTurningOnNextBirthday(DateTime dob, {DateTime? from}) {
  final now = from ?? DateTime.now();
  var nextYear = now.year;
  if (now.month > dob.month || (now.month == dob.month && now.day > dob.day)) {
    nextYear = now.year + 1;
  }
  return nextYear - dob.year;
}
