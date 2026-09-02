import '../../../agent/ether_task.dart';
import '../../../ai/brain/ether_brain.dart';
import '../business/ether_business_executor.dart';
import 'ether_execution_guard.dart';
import 'ether_execution_result.dart';

/// FEK-2 canonical execution engine.
///
/// FEK-3 decides WHAT should happen.
/// FEK-2 decides HOW a permitted task is executed.
///
/// Execution order:
///
///   Guard
///     ↓
///   Business Executor
///     ↓
///   Local Skills
///     ↓
///   ETHER Brain
///
/// Financial actions never pass the guard automatically.
class EtherExecutionEngine {
  final EtherBrain brain;
  final EtherBusinessExecutor businessExecutor;
  final EtherExecutionGuard guard;

  EtherExecutionEngine({
    EtherBrain? brain,
    EtherBusinessExecutor? businessExecutor,
    EtherExecutionGuard? guard,
  }) : brain = brain ?? EtherBrain(),
       businessExecutor = businessExecutor ?? EtherBusinessExecutor(),
       guard = guard ?? const EtherExecutionGuard();

  Future<void> initialize() async {
    await brain.initialize();
  }

  /// Execute exactly one pending task.
  ///
  /// This method does not mutate task state. The FEK-2 gateway owns
  /// task lifecycle state so that execution results remain explicit.
  Future<EtherExecutionResult> execute(EtherTask task) async {
    // FEK-2 Action owns the task lifecycle.
    // Action FEK transitions the task from pending → running
    // before handing it to this execution engine.
    //
    // Therefore the engine must not reject a task simply because
    // its status is already running.

    // ==========================================================
    // HARD FINANCIAL SAFETY BOUNDARY
    // ==========================================================

    if (guard.isFinancial(task)) {
      return EtherExecutionResult.blocked(guard.blockMessage());
    }

    try {
      // ========================================================
      // TYPED SKILL EXECUTION
      // ========================================================
      //
      // Explicit calculator tasks must reach the calculator skill
      // before generic business keyword matching. This prevents
      // words such as "profit", "margin", or "sell" from causing
      // a calculator request to be misclassified as business work.

      if (task.type == EtherTaskType.calculator) {
        final skillResult = await brain.skills.tryHandle(task.goal);

        if (skillResult != null) {
          return EtherExecutionResult.completed(skillResult);
        }
      }

      // ========================================================
      // BUSINESS EXECUTION
      // ========================================================

      final businessResult = await businessExecutor.execute(task);

      if (businessResult != null) {
        return EtherExecutionResult.completed(businessResult);
      }

      // ========================================================
      // LOCAL ETHER SKILLS
      // ========================================================

      final skillResult = await brain.skills.tryHandle(task.goal);

      if (skillResult != null) {
        return EtherExecutionResult.completed(skillResult);
      }

      // ========================================================
      // ETHER REASONING FALLBACK
      // ========================================================

      final result = await brain.think(task.goal);

      return EtherExecutionResult.completed(result);
    } catch (error) {
      return EtherExecutionResult.failed(error.toString());
    }
  }
}
