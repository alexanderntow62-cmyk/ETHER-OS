import 'package:speech_to_text/speech_to_text.dart' as stt;

class EtherVoice {
  final stt.SpeechToText _speech = stt.SpeechToText();

  bool get isListening => _speech.isListening;

  Future<bool> initialize({
    void Function(String status)? onStatus,
    void Function(dynamic error)? onError,
  }) async {
    return _speech.initialize(
      onStatus: onStatus,
      onError: onError,
    );
  }

  Future<void> startListening({
    required void Function(String text, bool finalResult) onResult,
  }) async {
    await _speech.listen(
      onResult: (result) {
        onResult(
          result.recognizedWords,
          result.finalResult,
        );
      },
    );
  }

  Future<void> stopListening() async {
    await _speech.stop();
  }
}
