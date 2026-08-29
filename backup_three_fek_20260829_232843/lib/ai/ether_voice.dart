import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class EtherVoice {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();

  bool _initialized = false;
  String? _localeId;

  bool get isListening => _speech.isListening;

  void _log(String message) {
    debugPrint('ETHER VOICE: $message');
  }

  Future<bool> initialize({
    void Function(String status)? onStatus,
    void Function(dynamic error)? onError,
  }) async {
    if (_initialized) return true;

    final available = await _speech.initialize(
      onStatus: (status) {
        _log('STATUS: $status');
        onStatus?.call(status);
      },
      onError: (error) {
        _log('ERROR: $error');
        onError?.call(error);
      },
      debugLogging: true,
    );

    _log('AVAILABLE: $available');

    if (!available) {
      _log('Speech recognition unavailable.');
      return false;
    }

    final locales = await _speech.locales();

    _log('LOCALES: ${locales.length}');

    for (final locale in locales) {
      _log('LOCALE: ${locale.localeId} / ${locale.name}');
    }

    for (final locale in locales) {
      if (locale.localeId.toLowerCase() == 'en_us' ||
          locale.localeId.toLowerCase() == 'en-us') {
        _localeId = locale.localeId;
        break;
      }
    }

    _localeId ??= locales
        .where((locale) => locale.localeId.toLowerCase().startsWith('en'))
        .map((locale) => locale.localeId)
        .cast<String?>()
        .firstWhere((id) => id != null, orElse: () => null);

    _log('SELECTED LOCALE: $_localeId');

    _initialized = true;
    return true;
  }

  Future<void> startListening({
    required void Function(String text, bool finalResult) onResult,
  }) async {
    if (!_initialized) {
      final available = await initialize();

      if (!available) {
        _log('Cannot start: speech recognition unavailable.');
        return;
      }
    }

    _log('START LISTENING locale=$_localeId');

    await _speech.listen(
      onResult: (result) {
        _log(
          'RESULT: "${result.recognizedWords}" '
          'final=${result.finalResult}',
        );

        onResult(result.recognizedWords, result.finalResult);
      },

      listenOptions: stt.SpeechListenOptions(
        listenFor: const Duration(seconds: 30),
        localeId: _localeId,
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        cancelOnError: false,
        listenMode: stt.ListenMode.confirmation,
      ),
    );

    _log('LISTEN COMMAND SENT');
  }

  Future<void> stopListening() async {
    _log('STOP LISTENING');
    await _speech.stop();
  }

  String _currentText = '';
  bool _isSpeaking = false;
  bool _isPaused = false;

  bool get isSpeaking => _isSpeaking;
  bool get isPaused => _isPaused;

  Future<void> speak(String text) async {
    if (text.trim().isEmpty) return;

    await _tts.stop();

    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.48);
    await _tts.setPitch(1.0);

    _currentText = text;
    _isSpeaking = true;
    _isPaused = false;

    await _tts.speak(_currentText);
  }

  Future<void> pauseSpeaking() async {
    if (!_isSpeaking || _isPaused) return;

    _log('PAUSE SPEAKING');
    await _tts.pause();
    _isPaused = true;
  }

  Future<void> resumeSpeaking() async {
    if (!_isSpeaking || !_isPaused) return;

    _log('RESUME SPEAKING');

    // Android TTS engines do not consistently expose a character
    // position for resuming. Restart the stored response rather than
    // sending an empty utterance.
    await _tts.stop();
    await _tts.speak(_currentText);

    _isPaused = false;
  }

  Future<void> stopSpeaking() async {
    _log('STOP SPEAKING');
    await _tts.stop();

    _currentText = '';
    _isSpeaking = false;
    _isPaused = false;
  }
}
