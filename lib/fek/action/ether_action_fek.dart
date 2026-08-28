import '../../agent/ether_executor.dart';
import '../../agent/ether_plan.dart';
import '../../agent/ether_task.dart';
import '../../ai/brain/ether_brain.dart';
import '../../tools/ether_tool.dart';

/// FEK-2: Action & Execution
///
/// Handles ETHER's ability to execute planned tasks:
/// - skills
/// - tools
/// - task execution
/// - action results
///
/// Action FEK shares ETHER's core Brain, skills, and tools.
/// It does not create a second Brain.
class EtherActionFEK {
  final EtherBrain brain;

  late final EtherExecutor executor;

  EtherActionFEK({
    required this.brain,
  }) {
    executor = EtherExecutor(brain: brain);
  }

  Future<void> initialize() async {
    await brain.initialize();
  }

  void registerTool(EtherTool tool) {
    brain.skills.tools.register(tool);
  }

  Future<EtherPlan> execute(EtherPlan plan) async {
    await initialize();

    for (final task in plan.tasks) {
      if (task.status != EtherTaskStatus.pending) {
        continue;
      }

      final toolResult = await brain.skills.tools.tryHandle(task.goal);

      if (toolResult != null) {
        task.complete(toolResult);
      }
    }

    return executor.execute(plan);
  }

  List<String> get toolNames => brain.skills.toolNames;
}
