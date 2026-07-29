import 'package:speech_to_text/speech_to_text.dart' as stt;

/// Shared speech-to-text wrapper for Notes and Companion.
class VoiceInputService {
  static final VoiceInputService _instance = VoiceInputService._();
  factory VoiceInputService() => _instance;
  VoiceInputService._();

  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _initialized = false;
  bool _isListening = false;
  void Function(String error)? _onError;

  bool get isListening => _isListening;
  bool get isAvailable => _initialized;

  Future<bool> initialize({void Function(String error)? onError}) async {
    _onError = onError ?? _onError;
    if (_initialized) return true;
    _initialized = await _speech.initialize(
      onError: (e) {
        _isListening = false;
        _onError?.call(e.errorMsg);
      },
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          _isListening = false;
        }
      },
    );
    return _initialized;
  }

  Future<bool> startListening({
    required void Function(String words, bool isFinal) onResult,
    void Function(String error)? onError,
    Duration listenFor = const Duration(seconds: 30),
    Duration pauseFor = const Duration(seconds: 2),
    bool continuous = false,
  }) async {
    if (onError != null) _onError = onError;
    final ok = await initialize(onError: onError);
    if (!ok) return false;

    _isListening = true;
    await _speech.listen(
      onResult: (result) {
        onResult(result.recognizedWords, result.finalResult);
        if (result.finalResult && !continuous) {
          _isListening = false;
        }
      },
      listenOptions: stt.SpeechListenOptions(
        listenFor: continuous ? const Duration(minutes: 5) : listenFor,
        pauseFor: continuous ? const Duration(seconds: 8) : pauseFor,
        partialResults: true,
        cancelOnError: true,
        listenMode: continuous
            ? stt.ListenMode.dictation
            : stt.ListenMode.confirmation,
      ),
    );
    return true;
  }

  Future<void> stop() async {
    _isListening = false;
    await _speech.stop();
  }

  Future<void> cancel() async {
    _isListening = false;
    await _speech.cancel();
  }
}
