import '../fek/ether_fek_coordinator.dart';

/// ETHER's top-level agent.
///
/// The agent is intentionally thin:
/// - FEKCoordinator owns routing.
/// - Core FEK owns intelligence and memory.
/// - Action FEK owns planning/execution.
/// - Business FEK owns autonomous business operations.
///
/// This prevents duplicate brains, planners, executors, and business
/// engines from being created at the top level.
class EtherAgent {
  final EtherFEKCoordinator fek;

  bool _initialized = false;

  EtherAgent({
    EtherFEKCoordinator? fek,
  }) : fek = fek ?? EtherFEKCoordinator();

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    await fek.initialize();
    _initialized = true;
  }

  Future<String> run(String goal) async {
    await initialize();

    final input = goal.trim();

    if (input.isEmpty) {
      return 'ETHER is ready. What can I help you with?';
    }

    return fek.process(input);
  }
}
