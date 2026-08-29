import 'ether_ai.dart';
import 'brain/ether_brain.dart';

class LocalEtherAI implements EtherAI {
  final EtherBrain _brain;
  bool _initialized = false;

  LocalEtherAI({EtherBrain? brain}) : _brain = brain ?? EtherBrain();

  @override
  Future<String> respond(String message) async {
    if (!_initialized) {
      await _brain.initialize();
      _initialized = true;
    }

    return _brain.think(message);
  }
}
