import '../ai/ether_voice.dart';
import 'ether_jarvis_controller.dart';

/// JARVIS voice orchestration.
///
/// Pipeline:
/// microphone -> speech recognition -> JARVIS -> FEK -> response -> TTS
///
/// FEK safety boundaries remain inside the existing agent/execution layers.
class EtherJarvisVoice {
  final EtherJarvisController jarvis;
  final EtherVoice voice;

  bool _running = false;

  EtherJarvisVoice({EtherJarvisController? jarvis, EtherVoice? voice})
    : jarvis = jarvis ?? EtherJarvisController(),
      voice = voice ?? EtherVoice();

  bool get isRunning => _running;
  bool get isListening => voice.isListening;
  bool get isSpeaking => voice.isSpeaking;
  bool get isPaused => voice.isPaused;

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
      onStatus?.call('READY');

      final available = await initialize();

      if (!available) {
        const response = 'Voice recognition is unavailable on this device.';

        onStatus?.call('UNAVAILABLE');
        onEtherResponse?.call(response);
        await speak(response, onStatus: onStatus);
        return;
      }

      onStatus?.call('LISTENING');

      await voice.startListening(
        onResult: (text, finalResult) async {
          if (text.trim().isEmpty) return;

          onUserText?.call(text);

          if (!finalResult) return;

          await voice.stopListening();

          onStatus?.call('PROCESSING');

          try {
            final response = await jarvis.execute(text);

            onEtherResponse?.call(response);

            onStatus?.call('SPEAKING');

            await speak(response, onStatus: onStatus);
          } catch (error) {
            final response =
                'ETHER encountered an error while processing your command.';

            onEtherResponse?.call(response);
            onStatus?.call('ERROR');

            await speak('$response Error: $error', onStatus: onStatus);
          }
        },
      );
    } catch (error) {
      onStatus?.call('ERROR');
      rethrow;
    } finally {
      _running = false;

      if (!voice.isSpeaking) {
        onStatus?.call('READY');
      }
    }
  }

  Future<void> stop() async {
    await voice.stopListening();
    _running = false;
  }

  Future<void> speak(
    String text, {
    void Function(String status)? onStatus,
  }) async {
    if (text.trim().isEmpty) return;

    onStatus?.call('SPEAKING');

    await voice.speak(text);

    onStatus?.call('READY');
  }

  Future<void> stopSpeaking() async {
    await voice.stopSpeaking();
  }
}
