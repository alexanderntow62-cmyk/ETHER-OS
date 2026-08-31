import '../agent/ether_agent.dart';

/// JARVIS orchestration layer.
///
/// JARVIS does not replace the FEK architecture.
/// It sits above EtherAgent and provides:
/// - conversational session handling
/// - command normalization
/// - user-facing response formatting
/// - activity state
/// - a single entry point for the UI
///
/// Safety and execution remain inside the FEK architecture.
class EtherJarvisController {
  final EtherAgent agent;

  bool _initialized = false;
  bool _busy = false;

  EtherJarvisController({EtherAgent? agent})
      : agent = agent ?? EtherAgent();

  bool get isInitialized => _initialized;
  bool get isBusy => _busy;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    await agent.initialize();
    _initialized = true;
  }

  Future<String> execute(String command) async {
    await initialize();

    final input = command.trim();

    if (input.isEmpty) {
      return 'JARVIS is ready. Awaiting your command.';
    }

    if (_busy) {
      return 'JARVIS is currently processing another command.';
    }

    _busy = true;

    try {
      final response = await agent.run(input);
      return _formatResponse(response);
    } catch (error) {
      return 'JARVIS encountered an execution error: $error';
    } finally {
      _busy = false;
    }
  }

  String _formatResponse(String response) {
    final output = response.trim();

    if (output.isEmpty) {
      return 'Command processed, but no response was returned.';
    }

    return output;
  }

  Future<void> shutdown() async {
    _busy = false;
    _initialized = false;
  }
}
