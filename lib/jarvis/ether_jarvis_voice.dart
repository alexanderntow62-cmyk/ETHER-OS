import '../ai/ether_voice.dart';
import 'ether_jarvis_controller.dart';

/// Voice interface for ETHER.
///
/// Pipeline:
/// microphone -> speech recognition -> ETHER controller -> response -> TTS
///
/// This layer does not bypass FEK safety controls.
class EtherJarvisVoice {
  final EtherJarvisController jarvis;
  final EtherVoice voice;

  bool _running = false;

  EtherJarvisVoice({
    EtherJarvisController? jarvis,
    EtherVoice? voice,
  })  : jarvis = jarvis ?? EtherJarvisController(),
        voice = voice ?? EtherVoice();

  bool get isRunning => _running;
  bool get isListening => voice.isListening;

  Future<bool> initialize() async {
    await jarvis.initialize();
    return voice.initialize();
  }

  Future<void> listenOnce({
    required void Function(String text)? onUserText,
    required void Function(String response)? onEtherResponse,
    void Function(String status)? onStatus,
  }) async {
    if (_running) return;

    _running = true;

    try {
      final available = await initialize();

      if (!available) {
        const response =
            'Voice recognition is unavailable on this device.';
        await voice.speak(response);
        onEtherResponse?.call(response);
        return;
      }

      await voice.startListening(
        onResult: (text, finalResult) async {
          if (text.trim().isEmpty) return;

          onUserText?.call(text);

          if (!finalResult) return;

          await voice.stopListening();

          final response = await jarvis.execute(text);

          onEtherResponse?.call(response);

          await voice.speak(response);
        },
      );

      onStatus?.call('LISTENING');
    } finally {
      _running = false;
    }
  }

  Future<void> stop() async {
    await voice.stopListening();
    _running = false;
  }

  Future<void> speak(String text) {
    return voice.speak(text);
  }

  Future<void> stopSpeaking() {
    return voice.stopSpeaking();
  }
}
