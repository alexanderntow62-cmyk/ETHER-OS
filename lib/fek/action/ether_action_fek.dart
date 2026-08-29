import '../../agent/ether_executor.dart';
import '../../agent/ether_plan.dart';
import '../../agent/ether_task.dart';
import '../../ai/brain/ether_brain.dart';
import '../../tools/ether_tool.dart';
import 'business/ether_business_executor.dart';

/// FEK-2: Action & Execution.
///
/// FEK-3 decides and plans.
/// FEK-2 executes the resulting plan.
///
/// Business tasks are intercepted before the generic Brain/skill
/// executor. Financial tasks are blocked at this boundary.
class EtherActionFEK {
  final EtherBrain brain;

  late final EtherExecutor executor;
  late final EtherBusinessExecutor businessExecutor;

  EtherActionFEK({required this.brain}) {
    executor = EtherExecutor(brain: brain);
    businessExecutor = EtherBusinessExecutor();
  }

  Future<void> initialize() async {
    await brain.initialize();
  }

  void registerTool(EtherTool tool) {
    brain.skills.tools.register(tool);
  }

  Future<EtherPlan> execute(EtherPlan plan) async {
    await initialize();

    final normalTasks = <EtherTask>[];

    for (final task in plan.tasks) {
      if (task.status != EtherTaskStatus.pending) {
        continue;
      }

      // ----------------------------------------------------------
      // FEK-2 BUSINESS GATE
      // ----------------------------------------------------------
      //
      // Business tasks NEVER fall through to EtherExecutor.
      //
      // This check uses both the explicit task type and the goal,
      // so older plans with type == general remain protected.
      if (_isBusinessTask(task)) {
        task.start();

        try {
          final result = await businessExecutor.execute(task);

          if (result == null) {
            task.fail('FEK-2 could not execute business task: ${task.goal}');
          } else if (result.startsWith('FEK-2 BLOCKED')) {
            task.fail(result);
          } else {
            task.complete(result);
          }
        } catch (error) {
          task.fail(error.toString());
        }

        continue;
      }

      // Non-business tasks are allowed to use the normal
      // calculator/system/skill/brain execution pipeline.
      normalTasks.add(task);
    }

    if (normalTasks.isNotEmpty) {
      await executor.execute(EtherPlan(goal: plan.goal, tasks: normalTasks));
    }

    return plan;
  }

  bool _isBusinessTask(EtherTask task) {
    if (task.type == EtherTaskType.research ||
        task.type == EtherTaskType.product ||
        task.type == EtherTaskType.marketing ||
        task.type == EtherTaskType.customer ||
        task.type == EtherTaskType.finance) {
      return true;
    }

    final input = task.goal.trim().toLowerCase();

    // Protect legacy/general tasks by recognizing business intent.
    const businessTerms = [
      'pay',
      'payment',
      'purchase',
      'buy',
      'spend',
      'withdraw',
      'subscribe',
      'subscription',
      'advertising budget',
      'pay for advertising',
      'transfer money',
      'send money',
      'research',
      'competitor',
      'competition',
      'dropshipping',
      'drop shipping',
      'product',
      'supplier',
      'inventory',
      'online store',
      'ecommerce',
      'e-commerce',
      'marketing',
      'promotion',
      'promote',
      'audience',
      'advertising',
      'campaign',
      'customer',
      'customers',
      'support',
      'sales',
      'sell',
      'client',
      'clients',
      'youtube',
      'content',
      'video',
      'article',
      'thumbnail',
    ];

    return businessTerms.any(input.contains);
  }

  List<String> get toolNames => brain.skills.toolNames;
}
