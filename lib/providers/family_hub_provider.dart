import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../core/family/person_age_utils.dart';
import '../database/people_dao.dart';
import '../database/calendar_dao.dart';
import '../database/database_helper.dart';
import '../models/person.dart';
import '../services/birthday_calendar_service.dart';

class FamilyHubProvider extends ChangeNotifier {
  FamilyHubProvider();

  final PeopleDao _dao = PeopleDao();
  final CalendarDao _calendarDao = CalendarDao();
  final BirthdayCalendarService _birthdayService = BirthdayCalendarService();
  final _uuid = const Uuid();
  List<Person> _people = [];
  bool _loaded = false;
  bool _loadRunning = false;
  String? _loadError;
  Future<void> _syncChain = Future.value();

  /// Optional hook (set from main) to refresh calendar UI after family-hub sync.
  Future<void> Function()? onCalendarEventsChanged;

  static const Duration _dbTimeout = Duration(seconds: 15);

  List<Person> get people => List.unmodifiable(_people);
  bool get isLoaded => _loaded;
  String? get loadError => _loadError;

  List<Person> get partners => _people
      .where((p) => p.relationshipToUser == 'partner' && !p.isContact && !p.isDeceased)
      .toList();

  List<Person> get pets =>
      _people.where((p) => p.isPet && !p.isContact).toList();

  List<Person> get householdPeople => _people
      .where((p) =>
          !p.isPet && p.relationshipToUser != 'partner' && !p.isContact && !p.isDeceased)
      .toList();

  /// People who usually live in this home (or share custody here).
  List<Person> get localHouseholdPeople => householdPeople
      .where((p) =>
          p.livingArrangement == 'lives_with_me' ||
          p.livingArrangement == 'shared_custody')
      .toList();

  /// Children / young people who live elsewhere, visit, or are overseas.
  List<Person> get connectedAwayPeople => householdPeople
      .where((p) =>
          p.livingArrangement == 'visitation' ||
          p.livingArrangement == 'lives_elsewhere' ||
          p.livingArrangement == 'international')
      .toList();

  /// Extended family, friends, co-workers — Contacts subsection of Family Hub.
  List<Person> get contacts =>
      _people.where((p) => p.isContact && !p.isPet && !p.isDeceased).toList();

  /// Loved ones who have passed — memorial dates on calendar.
  List<Person> get deceasedLovedOnes =>
      _people.where((p) => p.isDeceased && !p.isPet).toList();

  List<Person> get children => _people
      .where((p) =>
          !p.isContact &&
          !p.isDeceased &&
          (p.ageStage == 'baby' ||
              p.ageStage == 'toddler' ||
              p.ageStage == 'child' ||
              p.ageStage == 'teen'))
      .toList();

  List<Person> get schoolAged => _people
      .where((p) => !p.isContact && !p.isDeceased && (p.ageStage == 'child' || p.ageStage == 'teen'))
      .toList();

  Future<void>? _loadFuture;

  Future<void> load() {
    return _loadFuture ??= _loadInternal().whenComplete(() => _loadFuture = null);
  }

  /// Re-read people from the database (e.g. when opening Family Hub).
  Future<void> refreshFromDatabase() async {
    try {
      _people = await _dao.getAll().timeout(_dbTimeout);
      notifyListeners();
    } catch (e) {
      debugPrint('FamilyHubProvider.refreshFromDatabase: $e');
    }
  }

  Future<void> reloadAfterReset() async {
    _loaded = false;
    _people = [];
    _loadError = null;
    notifyListeners();
    await load();
  }

  Future<void> resetLocalDataAndReload() async {
    await DatabaseHelper.resetLocalDatabase();
    await reloadAfterReset();
  }

  Future<void> _loadInternal() async {
    if (_loadRunning) return;
    _loadRunning = true;
    _loadError = null;
    notifyListeners();

    try {
      await _refreshFromDb(allowSeed: true).timeout(_dbTimeout);
      unawaited(_linkCalendarCategories().timeout(_dbTimeout).catchError((e) {
        debugPrint('Category link skipped: $e');
      }));
      await _syncAllPersonCalendar().timeout(_dbTimeout).catchError((e) {
        debugPrint('Calendar sync skipped: $e');
      });
    } on TimeoutException {
      _loadError = 'Database timed out. Try “Reset local data” below.';
      debugPrint('FamilyHubProvider.load timed out');
    } catch (e, st) {
      final detail = e.toString();
      _loadError = detail.length > 120
          ? 'Could not load family data. ${detail.substring(0, 120)}…'
          : 'Could not load family data. $detail';
      debugPrint('FamilyHubProvider.load failed: $e\n$st');
    } finally {
      _loaded = true;
      _loadRunning = false;
      notifyListeners();
    }
  }

  Future<void> _linkCalendarCategories() async {
    final cal = CalendarDao();
    for (final p in _people) {
      if (p.calendarCategoryId != null) {
        await cal.linkCategoryToPerson(p.calendarCategoryId!, p.id);
      }
    }
  }

  Future<void> _seedDefaults() async {
    final now = DateTime.now();
    final seeds = <Person>[
      Person(
        id: _uuid.v4(),
        displayName: 'Beth',
        preferredName: 'Beth',
        relationshipToUser: 'self',
        ageStage: 'adult',
        profileType: 'household_member',
        colourIcon: '👤',
        calendarCategoryId: 'beth',
        livingArrangement: 'lives_with_me',
        livesWithMe: true,
        createdAt: now,
        updatedAt: now,
      ),
      Person(
        id: _uuid.v4(),
        displayName: 'Ant',
        preferredName: 'Ant',
        relationshipToUser: 'partner',
        ageStage: 'adult',
        profileType: 'household_member',
        colourIcon: '👤',
        calendarCategoryId: 'ant',
        livingArrangement: 'lives_with_me',
        livesWithMe: true,
        createdAt: now,
        updatedAt: now,
      ),
      Person(
        id: _uuid.v4(),
        displayName: 'Evander',
        preferredName: 'Evander',
        relationshipToUser: 'child',
        dateOfBirth: now.subtract(const Duration(days: 150)),
        ageStage: ageStageFromDateOfBirth(now.subtract(const Duration(days: 150))),
        profileType: 'child',
        colourIcon: '👶',
        calendarCategoryId: 'evander',
        livingArrangement: 'lives_with_me',
        livesWithMe: true,
        createdAt: now,
        updatedAt: now,
      ),
      Person(
        id: _uuid.v4(),
        displayName: 'Theo',
        preferredName: 'Theo',
        legalName: 'Theodore',
        relationshipToUser: 'partners_child',
        dateOfBirth: now.subtract(const Duration(days: 365 * 8)),
        ageStage: 'child',
        profileType: 'child',
        colourIcon: '🧒',
        livingArrangement: 'international',
        livesWithMe: false,
        residenceLocation: 'UK with mum',
        notes: 'Ant\'s son. Visits / contact across international separation.',
        createdAt: now,
        updatedAt: now,
      ),
      Person(
        id: _uuid.v4(),
        displayName: 'Bella',
        preferredName: 'Bella',
        legalName: 'Annabella',
        relationshipToUser: 'partners_child',
        dateOfBirth: now.subtract(const Duration(days: 365 * 14)),
        ageStage: 'teen',
        profileType: 'child',
        colourIcon: '👧',
        livingArrangement: 'international',
        livesWithMe: false,
        residenceLocation: 'UK with mum',
        notes: 'Ant\'s daughter. Visits / contact across international separation.',
        createdAt: now,
        updatedAt: now,
      ),
      Person(
        id: _uuid.v4(),
        displayName: 'Household pet',
        relationshipToUser: 'pet',
        ageStage: 'pet',
        profileType: 'pet',
        colourIcon: '🐾',
        species: 'Dog',
        breed: 'Add breed in profile',
        livingArrangement: 'lives_with_me',
        livesWithMe: true,
        notes: 'Basic care notes live here.',
        createdAt: now,
        updatedAt: now,
      ),
    ];
    for (final person in seeds) {
      await _dao.insert(person);
    }
    _people = seeds;
    await _syncAllPersonCalendar();
  }

  Future<void> _syncAllPersonCalendar() {
    return _enqueueCalendarSync(() async {
      final snapshot = List<Person>.from(_people);
      for (final person in snapshot) {
        if (!_personNeedsCalendarSync(person)) continue;
        final synced = await _birthdayService.syncPersonCalendar(person: person);
        await _dao.update(synced);
      }
      await _reloadPeopleFromDb();
      await _notifyCalendarChanged();
    });
  }

  bool _personNeedsCalendarSync(Person person) =>
      person.dateOfBirth != null ||
      person.dateOfDeath != null ||
      person.anniversaryDate != null;

  Future<Person> savePerson(
    Person person, {
    BirthdaySyncChoice? birthdayChoice,
    bool awaitBirthday = false,
  }) async {
    var updated = person;
    final exists = _people.any((p) => p.id == person.id);

    await (exists ? _dao.update(updated) : _dao.insert(updated)).timeout(_dbTimeout);

    _mergePerson(updated);
    notifyListeners();

    if (_personNeedsCalendarSync(updated)) {
      await _finishSaveCalendar(updated, birthdayChoice);
      updated = personById(person.id) ?? updated;
    }

    return updated;
  }

  Future<void> _finishSaveCalendar(Person person, BirthdaySyncChoice? birthdayChoice) {
    return _enqueueCalendarSync(() async {
      try {
        var updated = person;
        final needsPrompt = await _birthdayService.needsBirthdayConflictPrompt(updated);
        if (!needsPrompt || birthdayChoice != null) {
          updated = await _birthdayService.syncPersonCalendar(
            person: updated,
            conflictChoice: birthdayChoice,
          );
        } else if (updated.dateOfDeath != null || updated.anniversaryDate != null) {
          updated = await _birthdayService.syncMemorialAndAnniversary(updated);
        }
        await _dao.update(updated);
        await _reloadPeopleFromDb();
        await _notifyCalendarChanged();
      } catch (e, st) {
        debugPrint('Calendar sync failed (person still saved): $e\n$st');
      }
    });
  }

  Future<void> _refreshFromDb({required bool allowSeed}) async {
    _people = await _dao.getAll();
    if (allowSeed && _people.isEmpty) {
      await _seedDefaults();
    } else {
      await _migrateBlendedFamilySeedIfNeeded();
    }
  }

  Future<void> _migrateBlendedFamilySeedIfNeeded() async {
    var changed = false;
    final updated = <Person>[];
    for (final p in _people) {
      final name = (p.preferredName ?? p.displayName).toLowerCase();
      final isTheo = name == 'theo' || name == 'theodore';
      final isBella = name == 'bella' || name == 'annabella';
      if ((isTheo || isBella) &&
          p.relationshipToUser == 'child' &&
          p.livingArrangement == 'lives_with_me' &&
          (p.residenceLocation == null || p.residenceLocation!.isEmpty)) {
        final fixed = p.copyWith(
          relationshipToUser: 'partners_child',
          livingArrangement: 'international',
          livesWithMe: false,
          residenceLocation: 'UK with mum',
          legalName: isTheo
              ? (p.legalName ?? 'Theodore')
              : (p.legalName ?? 'Annabella'),
          notes: p.notes ??
              (isTheo
                  ? 'Ant\'s son. Visits / contact across international separation.'
                  : 'Ant\'s daughter. Visits / contact across international separation.'),
          updatedAt: DateTime.now(),
        );
        await _dao.update(fixed);
        updated.add(fixed);
        changed = true;
      } else {
        updated.add(p);
      }
    }
    if (changed) {
      _people = updated;
      await _syncAllPersonCalendar();
    }
  }

  Future<void> removePerson(String id, {bool exportFirst = false}) async {
    if (exportFirst) {
      await exportPersonData(id);
    }
    final person = personById(id);
    if (person != null) {
      await _calendarDao.deletePersonCalendarEvents(id);
      for (final eventId in [
        person.calendarBirthdayEventId,
        person.calendarMemorialEventId,
        person.calendarAnniversaryEventId,
      ]) {
        if (eventId != null) {
          await _calendarDao.deleteEvent(eventId);
        }
      }
    }
    await _dao.delete(id);
    _people = _people.where((p) => p.id != id).toList();
    notifyListeners();
    await _notifyCalendarChanged();
  }

  Future<String> exportPersonData(String id) async {
    final person = await _dao.getById(id);
    if (person == null) return '{}';
    return jsonEncode(person.toMap());
  }

  Person? personById(String id) {
    try {
      return _people.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  void _mergePerson(Person person) {
    final idx = _people.indexWhere((p) => p.id == person.id);
    if (idx >= 0) {
      _people[idx] = person;
    } else {
      _people = [..._people, person];
    }
  }

  Future<void> _reloadPeopleFromDb() async {
    _people = await _dao.getAll();
    notifyListeners();
  }

  Future<void> _enqueueCalendarSync(Future<void> Function() action) {
    final run = _syncChain.then((_) => action());
    _syncChain = run.catchError((_) {});
    return run;
  }

  Future<void> _notifyCalendarChanged() async {
    final callback = onCalendarEventsChanged;
    if (callback == null) return;
    try {
      await callback();
    } catch (e) {
      debugPrint('Calendar refresh callback failed: $e');
    }
  }
}
