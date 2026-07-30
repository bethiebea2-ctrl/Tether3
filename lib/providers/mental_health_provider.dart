import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../database/mental_health_dao.dart';
import '../models/mental_health_models.dart';

class MentalHealthProvider extends ChangeNotifier {
  static const _prefsKeyHideDashboard = 'mental_health_hide_dashboard';

  final MentalHealthDao _dao = MentalHealthDao();
  final _uuid = const Uuid();

  CrisisPlan? _crisisPlan;
  List<WorryLog> _worryLogs = [];
  List<TrustedContact> _contacts = [];
  bool _loaded = false;
  bool hideFromDashboard = false;

  CrisisPlan? get crisisPlan => _crisisPlan;
  List<WorryLog> get worryLogs => List.unmodifiable(_worryLogs);
  List<TrustedContact> get contacts => List.unmodifiable(_contacts);
  bool get isLoaded => _loaded;
  /// Alias used by screens that check `loaded`.
  bool get loaded => _loaded;

  Future<void> load() async {
    _crisisPlan = await _dao.getCrisisPlan();
    _worryLogs = await _dao.getWorryLogs();
    _contacts = await _dao.getTrustedContacts();
    final prefs = await SharedPreferences.getInstance();
    hideFromDashboard = prefs.getBool(_prefsKeyHideDashboard) ?? false;
    _loaded = true;
    notifyListeners();
  }

  Future<void> setHideFromDashboard(bool value) async {
    hideFromDashboard = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKeyHideDashboard, value);
    notifyListeners();
  }

  Future<void> saveCrisisPlan({
    required String warningSigns,
    required String copingStrategies,
    required String peopleToContact,
    required String professionalHelp,
    required String makeEnvironmentSafe,
    required String reasonsToStay,
  }) async {
    final plan = CrisisPlan(
      id: _crisisPlan?.id ?? _uuid.v4(),
      warningSigns: warningSigns,
      copingStrategies: copingStrategies,
      peopleToContact: peopleToContact,
      professionalHelp: professionalHelp,
      makeEnvironmentSafe: makeEnvironmentSafe,
      reasonsToStay: reasonsToStay,
      updatedAt: DateTime.now(),
    );
    await _dao.upsertCrisisPlan(plan);
    _crisisPlan = plan;
    notifyListeners();
  }

  Future<void> addWorry(String content) async {
    final log = WorryLog(
      id: _uuid.v4(),
      content: content,
      createdAt: DateTime.now(),
    );
    await _dao.insertWorryLog(log);
    _worryLogs = [log, ..._worryLogs];
    notifyListeners();
  }

  Future<void> deleteWorry(String id) async {
    await _dao.deleteWorryLog(id);
    _worryLogs = _worryLogs.where((w) => w.id != id).toList();
    notifyListeners();
  }

  Future<void> addContact({
    required String name,
    String? phone,
    String? notes,
  }) async {
    final contact = TrustedContact(
      id: _uuid.v4(),
      name: name,
      phone: phone,
      notes: notes,
    );
    await _dao.upsertTrustedContact(contact);
    _contacts = [..._contacts, contact]
      ..sort((a, b) => a.name.compareTo(b.name));
    notifyListeners();
  }

  Future<void> deleteContact(String id) async {
    await _dao.deleteTrustedContact(id);
    _contacts = _contacts.where((c) => c.id != id).toList();
    notifyListeners();
  }
}
