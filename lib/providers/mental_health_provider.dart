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
  List<PanicEpisodeLog> _panicEpisodes = [];
  bool _loaded = false;
  bool hideFromDashboard = false;

  CrisisPlan? get crisisPlan => _crisisPlan;
  List<WorryLog> get worryLogs => List.unmodifiable(_worryLogs);
  List<TrustedContact> get contacts => List.unmodifiable(_contacts);
  List<PanicEpisodeLog> get panicEpisodes => List.unmodifiable(_panicEpisodes);
  bool get isLoaded => _loaded;
  /// Alias used by screens that check `loaded`.
  bool get loaded => _loaded;

  Future<void> load() async {
    _crisisPlan = await _dao.getCrisisPlan();
    _worryLogs = await _dao.getWorryLogs();
    _contacts = await _dao.getTrustedContacts();
    _panicEpisodes = await _dao.getPanicEpisodes();
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

  Future<void> logPanicEpisode({String? notes}) async {
    final log = PanicEpisodeLog(
      id: _uuid.v4(),
      notes: notes,
      loggedAt: DateTime.now(),
    );
    await _dao.insertPanicEpisode(log);
    _panicEpisodes = [log, ..._panicEpisodes];
    notifyListeners();
  }

  /// Plain-text summary for a counsellor / psychologist appointment.
  String discussWithCounsellorExport() {
    final buf = StringBuffer();
    buf.writeln('Tether — Discuss with counsellor / psychologist');
    buf.writeln('Generated: ${DateTime.now().toIso8601String()}');
    buf.writeln('(On-device notes only — not a clinical assessment.)');
    buf.writeln('');
    buf.writeln('=== Crisis / safety plan ===');
    final plan = _crisisPlan;
    if (plan == null) {
      buf.writeln('(No crisis plan saved yet.)');
    } else {
      buf.writeln('Warning signs: ${plan.warningSigns}');
      buf.writeln('Coping strategies: ${plan.copingStrategies}');
      buf.writeln('People to contact: ${plan.peopleToContact}');
      buf.writeln('Professional help: ${plan.professionalHelp}');
      buf.writeln('Make environment safer: ${plan.makeEnvironmentSafe}');
      buf.writeln('Reasons to stay: ${plan.reasonsToStay}');
    }
    buf.writeln('');
    buf.writeln('=== Recent worry log (up to 20) ===');
    if (_worryLogs.isEmpty) {
      buf.writeln('(None)');
    } else {
      for (final w in _worryLogs.take(20)) {
        buf.writeln('- ${w.createdAt.toIso8601String()}: ${w.content}');
      }
    }
    buf.writeln('');
    buf.writeln('=== Panic episodes logged (up to 20) ===');
    if (_panicEpisodes.isEmpty) {
      buf.writeln('(None)');
    } else {
      for (final p in _panicEpisodes.take(20)) {
        buf.writeln(
          '- ${p.loggedAt.toIso8601String()}'
          '${p.notes != null && p.notes!.isNotEmpty ? ': ${p.notes}' : ''}',
        );
      }
    }
    buf.writeln('');
    buf.writeln('=== Trusted contacts ===');
    if (_contacts.isEmpty) {
      buf.writeln('(None listed)');
    } else {
      for (final c in _contacts) {
        buf.writeln(
          '- ${c.name}'
          '${c.phone != null ? ' · ${c.phone}' : ''}'
          '${c.notes != null ? ' · ${c.notes}' : ''}',
        );
      }
    }
    return buf.toString();
  }
}
