import '../../../agent/ether_task.dart';
import '../../../ai/brain/ether_brain.dart';
import '../business/ether_business_executor.dart';
import 'ether_execution_guard.dart';
import 'ether_execution_result.dart';

/// FEK-2 execution engine.
///
/// Responsibility:
///   1. Enforce the safety boundary.
///   2. Dispatch business tasks.
///   3. Dispatch local ETHER skills.
///   4. Fall back to ETHER reasoning.
///
/// FEK-3 decides WHAT should happen.
/// FEK-2 decides HOW the permitted task is executed.
///
/// Financial actions never pass this engine automatically.
class EtherExecutionEngine {
  final EtherBrain brain;
  final EtherBusinessExecutor businessExecutor;
  final EtherExecutionGuard guard;

  EtherExecutionEngine({
    EtherBrain? brain,
    EtherBusinessExecutor? businessExecutor,
    EtherExecutionGuard? guard,
  })  : brain = brain ?? EtherBrain(),
        businessExecutor =
            businessExecutor ?? EtherBusinessExecutor(),
        guard = guard ?? const EtherExecutionGuard();

  Future<void> initialize() async {
    await brain.initialize();
  }

  Future<EtherExecutionResult> execute(EtherTask task) async {
    if (task.status != EtherTaskStatus.pending) {
      return EtherExecutionResult.failed(
        'Task ${task.id} is not pending.',
      );
    }

    // HARD SAFETY BOUNDARY.
    if (guard.isFinancial(task)) {
      return EtherExecutionResult.blocked(
        guard.blockMessage(),
      );
    }

    try {
      task.start();

      // Business execution gets priority over generic skills.
      final isBusiness = _isBusinessTask(task);

      if (isBusiness) {
        final businessResult =
            await businessExecutor.execute(task);

        if (businessResult != null) {
          return EtherExecutionResult.completed(
            businessResult,
          );
        }
      }

      // Try a local ETHER skill.
      final skillResult =
          await brain.skills.tryHandle(task.goal);

      if (skillResult != null) {
        return EtherExecutionResult.completed(
          skillResult,
        );
      }

      // Final permitted fallback: ETHER reasoning.
      final result = await brain.think(task.goal);

      return EtherExecutionResult.completed(result);
    } catch (error) {
      return EtherExecutionResult.failed(
        error.toString(),
      );
    }
  }

  bool _isBusinessTask(EtherTask task) {
    if (task.isFinancial) {
      return true;
    }

    switch (task.type) {
      case EtherTaskType.research:
      case EtherTaskType.product:
      case EtherTaskType.marketing:
      case EtherTaskType.customer:
      case EtherTaskType.finance:
        return true;

      case EtherTaskType.general:
      case EtherTaskType.calculator:
      case EtherTaskType.system:
        return _containsBusinessLanguage(
          task.goal.toLowerCase(),
        );
    }
  }

  bool _containsBusinessLanguage(String input) {
    const terms = [
      'business',
      'dropshipping',
      'drop shipping',
      'product research',
      'market research',
      'supplier',
      'inventory',
      'ecommerce',
      'e-commerce',
      'online store',
      'marketing',
      'campaign',
      'customer',
      'customers',
      'sales',
      'client',
      'clients',
      'youtube',
      'content',
    ];

    return terms.any(input.contains);
  }
}
