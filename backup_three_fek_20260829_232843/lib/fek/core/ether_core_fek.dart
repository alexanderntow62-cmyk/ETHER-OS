import '../../ai/brain/ether_brain.dart';

/// FEK-1: Core Intelligence
///
/// Handles ETHER's cognitive layer:
/// - conversation
/// - memory
/// - identity
/// - context
/// - basic reasoning
///
/// This layer does not expose planning or execution details to the user.
class EtherCoreFEK {
  final EtherBrain brain;

  EtherCoreFEK({EtherBrain? brain}) : brain = brain ?? EtherBrain();

  Future<void> initialize() async {
    await brain.initialize();
  }

  Future<String> process(String message) async {
    return brain.think(message);
  }
}
