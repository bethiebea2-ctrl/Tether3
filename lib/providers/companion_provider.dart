import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/tasks/task_repository.dart';
import '../core/tasks/task_status.dart';
import '../core/tasks/task_priority.dart';
import '../models/colour_mood.dart';
import '../providers/calendar_provider.dart';
import '../providers/dashboard_provider.dart';
import '../services/api_service.dart';
import '../services/speech_output_service.dart';
import '../services/voice_input_service.dart';
import '../utils/constants.dart';

enum CompanionAvatarState { idle, listening, thinking, speaking, minimised }

class CompanionMessage {
  final String role; // user | assistant
  final String content;
  final DateTime at;

  const CompanionMessage({
    required this.role,
    required this.content,
    required this.at,
  });
}

class CompanionProvider extends ChangeNotifier {
  static const _instanceKey = 'companion_instance_id';
  static const _ttsKey = 'companion_tts_enabled';

  final VoiceInputService _voice = VoiceInputService();
  final SpeechOutputService _tts = SpeechOutputService();

  String _instanceId = 'viva';
  bool _ttsEnabled = true;
  bool _loaded = false;
  bool _sending = false;
  CompanionAvatarState _avatarState = CompanionAvatarState.idle;
  final List<CompanionMessage> _messages = [];
  String _partialTranscript = '';
  String? _greeting;

  String get instanceId => _instanceId;
  bool get ttsEnabled => _ttsEnabled;
  bool get isLoaded => _loaded;
  bool get isSending => _sending;
  bool get isListening => _voice.isListening;
  CompanionAvatarState get avatarState => _avatarState;
  List<CompanionMessage> get messages => List.unmodifiable(_messages);
  String get partialTranscript => _partialTranscript;
  String? get greeting => _greeting;

  Map<String, dynamic>? get instance => InstanceRegistry.getById(_instanceId);

  String get instanceName => instance?['name'] as String? ?? 'Viva';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _instanceId = prefs.getString(_instanceKey) ?? 'viva';
    _ttsEnabled = prefs.getBool(_ttsKey) ?? true;
    _greeting = _buildGreeting();
    _loaded = true;
    notifyListeners();
  }

  Future<void> setInstanceId(String id) async {
    _instanceId = id;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_instanceKey, id);
    notifyListeners();
  }

  Future<void> setTtsEnabled(bool value) async {
    _ttsEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_ttsKey, value);
    if (!value) await _tts.stop();
    notifyListeners();
  }

  Future<void> openSession({
    required DashboardProvider dashboard,
    required CalendarProvider calendar,
  }) async {
    if (!_loaded) await load();
    await TaskRepository().load();
    _greeting = _buildGreeting(mood: dashboard.mood);
    _syncAvatarToMood(dashboard.mood);
    if (_messages.isEmpty) {
      final history = await ApiService.getConversation(_instanceId);
      for (final m in history.take(40)) {
        _messages.add(CompanionMessage(
          role: m['role'] ?? 'assistant',
          content: m['content'] ?? '',
          at: DateTime.now(),
        ));
      }
    }
    notifyListeners();
  }

  void _syncAvatarToMood(ColourMood mood) {
    if (mood == ColourMood.sparkle) {
      _avatarState = CompanionAvatarState.minimised;
    } else if (mood == ColourMood.red || mood == ColourMood.black) {
      _avatarState = CompanionAvatarState.idle;
    } else {
      _avatarState = CompanionAvatarState.idle;
    }
  }

  String _buildGreeting({ColourMood? mood}) {
    final hour = DateTime.now().hour;
    final timePart = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';
    if (mood == ColourMood.red || mood == ColourMood.black) {
      return '$timePart. I\'m here — no rush.';
    }
    if (mood == ColourMood.sparkle) {
      return 'I\'m here if you need me.';
    }
    return '$timePart. How are you today?';
  }

  String buildLifeContext({
    required CalendarProvider calendar,
    required DashboardProvider dashboard,
  }) {
    final now = DateTime.now();
    final todayEvents = calendar.allEvents.where((e) {
      final d = e.startTime;
      return d.year == now.year && d.month == now.month && d.day == now.day;
    }).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    final tasks = TaskRepository().getTasks();
    final urgent = tasks
        .where((t) =>
            t.status == TaskStatus.pending &&
            (t.priority == TaskPriority.high || t.isOverdue))
        .take(5)
        .map((t) => t.title)
        .toList();
    final bare = tasks
        .where((t) => t.status == TaskStatus.pending && t.layer == 'bare_minimum')
        .take(5)
        .map((t) => t.title)
        .toList();
    final snoozed = tasks
        .where((t) => t.status == TaskStatus.snoozed)
        .take(3)
        .map((t) => t.title)
        .toList();

    final eventLines = todayEvents.isEmpty
        ? 'No events on the calendar today.'
        : todayEvents
            .take(6)
            .map((e) {
              final time = e.isAllDay
                  ? 'all day'
                  : '${e.startTime.hour.toString().padLeft(2, '0')}:${e.startTime.minute.toString().padLeft(2, '0')}';
              return '- $time · ${e.title}';
            })
            .join('\n');

    return '''
[Companion context — use only this data; do not invent events or tasks. Silence is fine. Do not access D4/crisis/debrief content.]
Colour mood: ${dashboard.mood.id}
Capacity: ${dashboard.capacity.round()}%
Today's calendar:
$eventLines
Urgent tasks: ${urgent.isEmpty ? 'none' : urgent.join('; ')}
Bare minimums: ${bare.isEmpty ? 'none' : bare.join('; ')}
Snoozed: ${snoozed.isEmpty ? 'none' : snoozed.join('; ')}
'''.trim();
  }

  Future<void> sendText(
    String text, {
    required CalendarProvider calendar,
    required DashboardProvider dashboard,
  }) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || _sending) return;

    _messages.add(CompanionMessage(
      role: 'user',
      content: trimmed,
      at: DateTime.now(),
    ));
    _partialTranscript = '';
    _sending = true;
    _avatarState = CompanionAvatarState.thinking;
    notifyListeners();

    final contextBlock = buildLifeContext(calendar: calendar, dashboard: dashboard);
    final input = '$contextBlock\n\nBeth: $trimmed';

    final result = await ApiService.sendMessage(
      instanceId: _instanceId,
      input: input,
    );

    final reply = _extractReply(result);
    _messages.add(CompanionMessage(
      role: 'assistant',
      content: reply,
      at: DateTime.now(),
    ));
    _sending = false;
    _avatarState = CompanionAvatarState.speaking;
    notifyListeners();

    await _tts.speak(reply, enabled: _ttsEnabled);
    _avatarState = dashboard.mood == ColourMood.sparkle
        ? CompanionAvatarState.minimised
        : CompanionAvatarState.idle;
    notifyListeners();
  }

  String _extractReply(Map<String, dynamic> result) {
    final status = result['status'] as String? ?? '';
    if (status == 'processed' || status == 'accepted') {
      return result['response'] as String? ?? '(no response)';
    }
    if (status == 'complete') {
      return result['message'] as String? ?? result['response'] as String? ?? '(no response)';
    }
    if (status == 'error' || status == 'rejected' || status == 'network_error') {
      return result['response'] as String? ??
          result['message'] as String? ??
          'I couldn\'t reach the server just now.';
    }
    return result['response'] as String? ?? result['message'] as String? ?? '(no response)';
  }

  Future<void> startListening({
    required CalendarProvider calendar,
    required DashboardProvider dashboard,
  }) async {
    if (dashboard.mood == ColourMood.sparkle) {
      _avatarState = CompanionAvatarState.minimised;
      notifyListeners();
    } else {
      _avatarState = CompanionAvatarState.listening;
      notifyListeners();
    }

    final ok = await _voice.startListening(
      onResult: (words, isFinal) {
        _partialTranscript = words;
        notifyListeners();
        if (isFinal) {
          _avatarState = CompanionAvatarState.idle;
          notifyListeners();
          if (words.trim().isNotEmpty) {
            sendText(words, calendar: calendar, dashboard: dashboard);
          }
        }
      },
      onError: (_) {
        _avatarState = CompanionAvatarState.idle;
        notifyListeners();
      },
    );
    if (!ok) {
      _avatarState = CompanionAvatarState.idle;
      notifyListeners();
    }
  }

  Future<void> stopListening() async {
    await _voice.stop();
    _avatarState = CompanionAvatarState.idle;
    notifyListeners();
  }

  Future<void> stopSpeaking() async {
    await _tts.stop();
    _avatarState = CompanionAvatarState.idle;
    notifyListeners();
  }
}
