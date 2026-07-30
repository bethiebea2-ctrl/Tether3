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
  final BirthdayCalendarService _birthdayService = BirthdayCalendarService();
  final _uuid = const Uuid();
  List<Person> _people = [];
  bool _loaded = false;
  bool _loadRunning = false;
  String? _loadError;

  static const Duration _dbTimeout = Duration(seconds: 15);

  List<Person> get people => List.unmodifiable(_people);
  bool get isLoaded => _loaded;
  String? get loadError => _loadError;

  List<Person> get partners =>
      _people.where((p) => p.relationshipToUser == 'partner' && !p.isContact).toList();

  List<Person> get pets =>
      _people.where((p) => p.isPet && !p.isContact).toList();

  List<Person> get householdPeople =>
      _people.where((p) => !p.isPet && p.relationshipToUser != 'partner' && !p.isContact).toList();

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
      _people.where((p) => p.isContact && !p.isPet).toList();

  List<Person> get children => _people
      .where((p) =>
          !p.isContact &&
          (p.ageStage == 'baby' ||
              p.ageStage == 'toddler' ||
              p.ageStage == 'child' ||
              p.ageStage == 'teen'))
      .toList();

  List<Person> get schoolAged =>
      _people.where((p) => !p.isContact && (p.ageStage == 'child' || p.ageStage == 'teen')).toList();

  Future<void>? _loadFuture;

  Future<void> load() {
    return _loadFuture ??= _loadInternal().whenComplete(() => _loadFuture = null);
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
      // Ant's children from a previous relationship — live in the UK with his ex.
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
    for (final p in seeds.where((p) => p.dateOfBirth != null)) {
      unawaited(_syncBirthdayInBackground(p));
    }
  }

  Future<void> _syncBirthdayInBackground(Person person) async {
    try {
      final synced = await _birthdayService.syncBirthday(person: person);
      await _dao.update(synced);
      _people = _people.map((p) => p.id == synced.id ? synced : p).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Background birthday sync: $e');
    }
  }

  Future<Person> savePerson(
    Person person, {
    BirthdaySyncChoice? birthdayChoice,
  }) async {
    var updated = person;
    final exists = _people.any((p) => p.id == person.id);

    await (exists ? _dao.update(updated) : _dao.insert(updated)).timeout(_dbTimeout);

    if (!_people.any((p) => p.id == updated.id)) {
      _people = [..._people, updated];
    } else {
      _people = _people.map((p) => p.id == updated.id ? updated : p).toList();
    }
    notifyListeners();

    if (updated.dateOfBirth != null) {
      unawaited(_finishSaveBirthday(updated, birthdayChoice));
    }

    return updated;
  }

  Future<void> _finishSaveBirthday(Person person, BirthdaySyncChoice? birthdayChoice) async {
    try {
      var updated = person;
      final needsPrompt = await _birthdayService.needsBirthdayConflictPrompt(updated);
      if (!needsPrompt || birthdayChoice != null) {
        updated = await _birthdayService.syncBirthday(
          person: updated,
          conflictChoice: birthdayChoice,
        );
        await _dao.update(updated);
        _people = _people.map((p) => p.id == updated.id ? updated : p).toList();
        notifyListeners();
      }
    } catch (e, st) {
      debugPrint('Birthday calendar sync failed (person still saved): $e\n$st');
    }
  }

  Future<void> _refreshFromDb({required bool allowSeed}) async {
    _people = await _dao.getAll();
    if (allowSeed && _people.isEmpty) {
      await _seedDefaults();
    } else {
      await _migrateBlendedFamilySeedIfNeeded();
    }
  }

  /// One-time correction for older seeds that listed Theo/Bella as co-resident children.
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
    }
  }

  Future<void> removePerson(String id, {bool exportFirst = false}) async {
    if (exportFirst) {
      await exportPersonData(id);
    }
    await _dao.delete(id);
    _people = _people.where((p) => p.id != id).toList();
    notifyListeners();
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
}
