import '../../agent/ether_plan.dart';
import '../../agent/ether_task.dart';
import '../../ai/brain/ether_brain.dart';
import 'business/ether_business_executor.dart';
import 'execution/ether_execution_engine.dart';
import '../ether_fek.dart';

/// FEK-2: Action & Execution.
///
/// FEK-2 is the only layer permitted to execute tasks.
///
/// Public architecture:
///
///   FEK-3 PLAN
///        ↓
///   FEK-2 ACTION
///        ↓
///   EtherExecutionEngine
///        ↓
///   Guard → Business → Skills → Brain
///
/// Financial tasks are blocked before executable capabilities
/// are allowed to run.
class EtherActionFEK implements EtherFek {
  final EtherBrain brain;
  final EtherBusinessExecutor businessExecutor;
  final EtherExecutionEngine executionEngine;

  EtherActionFEK({
    EtherBrain? brain,
    EtherBusinessExecutor? businessExecutor,
    EtherExecutionEngine? executionEngine,
  }) : brain = brain ?? EtherBrain(),
       businessExecutor = businessExecutor ?? EtherBusinessExecutor(),
       executionEngine =
           executionEngine ??
           EtherExecutionEngine(
             brain: brain,
             businessExecutor: businessExecutor,
           );

  @override
  EtherFekType get type => EtherFekType.action;

  @override
  String get name => 'ACTION FEK';

  @override
  bool canHandle(String input) => input.trim().isNotEmpty;

  /// Canonical FEK-2 plan execution entry point.
  ///
  /// FEK-2 owns task lifecycle state.
  /// The execution engine owns capability dispatch.
  Future<EtherPlan> execute(EtherPlan plan) async {
    await executionEngine.initialize();

    for (final task in plan.tasks) {
      if (task.status != EtherTaskStatus.pending) {
        continue;
      }

      task.start();

      final result = await executionEngine.execute(task);

      if (result.isCompleted) {
        task.complete(result.output);
      } else {
        task.fail(result.output);
      }
    }

    return plan;
  }

  /// Backwards-compatible alias.
  Future<EtherPlan> executePlan(EtherPlan plan) {
    return execute(plan);
  }

  /// Names of execution capabilities exposed by FEK-2.
  List<String> get toolNames => const [
    'calculator',
    'research',
    'business',
    'product',
    'marketing',
    'customer',
    'content',
    'system',
  ];

  @override
  Future<String> handle(String input) async {
    final goal = input.trim();

    if (goal.isEmpty) {
      return 'ACTION FEK\nNo action provided.';
    }

    final plan = EtherPlan(
      goal: goal,
      tasks: [EtherTask(id: 'action_1', goal: goal)],
    );

    final result = await execute(plan);

    return result.tasks
        .map((task) => '${task.id}: ${task.status.name} ${task.result}')
        .join('\n');
  }
}
