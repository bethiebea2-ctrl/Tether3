import 'package:flutter_tts/flutter_tts.dart';

/// Shared text-to-speech for Companion replies and optional Notes confirmations.
class SpeechOutputService {
  static final SpeechOutputService _instance = SpeechOutputService._();
  factory SpeechOutputService() => _instance;
  SpeechOutputService._();

  final FlutterTts _tts = FlutterTts();
  bool _ready = false;
  bool _speaking = false;

  bool get isSpeaking => _speaking;

  Future<void> initialize() async {
    if (_ready) return;
    await _tts.setLanguage('en-AU');
    await _tts.setSpeechRate(0.45);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    _tts.setCompletionHandler(() => _speaking = false);
    _tts.setCancelHandler(() => _speaking = false);
    _tts.setErrorHandler((_) => _speaking = false);
    _ready = true;
  }

  /// Speaks [text] when [enabled] is true (accessibility / companion prefs).
  Future<void> speak(String text, {required bool enabled}) async {
    final trimmed = text.trim();
    if (!enabled || trimmed.isEmpty) return;
    await initialize();
    await stop();
    _speaking = true;
    await _tts.speak(trimmed);
  }

  Future<void> stop() async {
    _speaking = false;
    await _tts.stop();
  }
}
