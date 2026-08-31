import '../../agent/ether_executor.dart';
import '../../agent/ether_plan.dart';
import '../../agent/ether_task.dart';
import '../../ai/brain/ether_brain.dart';
import 'business/ether_business_executor.dart';
import '../ether_fek.dart';

/// FEK-2: Action & Execution.
///
/// FEK-2 is the only layer permitted to execute tasks.
///
/// Safety rule:
/// Financial tasks are blocked BEFORE generic skills/tools
/// are allowed to run.
class EtherActionFEK implements EtherFek {
  final EtherBrain brain;
  final EtherBusinessExecutor businessExecutor;

  late final EtherExecutor executor;

  EtherActionFEK({
    EtherBrain? brain,
    EtherBusinessExecutor? businessExecutor,
  })  : brain = brain ?? EtherBrain(),
        businessExecutor =
            businessExecutor ?? EtherBusinessExecutor() {
    executor = EtherExecutor(brain: this.brain);
  }

  @override
  EtherFekType get type => EtherFekType.action;

  @override
  String get name => 'ACTION FEK';

  @override
  bool canHandle(String input) =>
      input.trim().isNotEmpty;

  /// Canonical FEK-2 plan execution entry point.
  ///
  /// Business tasks are handled by the FEK-2 business
  /// executor before generic skills/tools.
  ///
  /// Financial tasks are blocked before any execution.
  Future<EtherPlan> execute(EtherPlan plan) async {
    await brain.initialize();
    await executor.initialize();

    for (final task in plan.tasks) {
      if (task.status != EtherTaskStatus.pending) {
        continue;
      }

      task.start();

      try {
        // --------------------------------------------------------
        // HARD FINANCIAL SAFETY BOUNDARY
        // --------------------------------------------------------

        if (task.isFinancial ||
            _looksFinancial(task.goal)) {
          task.fail(
            'FEK-2 BLOCKED: Financial action requires user approval.',
          );
          continue;
        }

        // --------------------------------------------------------
        // BUSINESS TASKS
        // --------------------------------------------------------

        final isBusinessTask =
            _isBusinessTask(task);

        if (isBusinessTask) {
          final result =
              await businessExecutor.execute(task);

          if (result != null) {
            if (result.startsWith('FEK-2 BLOCKED')) {
              task.fail(result);
            } else {
              task.complete(result);
            }

            continue;
          }
        }

        // --------------------------------------------------------
        // NORMAL ETHER EXECUTION
        // --------------------------------------------------------

        final skillResult =
            await brain.skills.tryHandle(task.goal);

        if (skillResult != null) {
          task.complete(skillResult);
          continue;
        }

        final result =
            await brain.think(task.goal);

        task.complete(result);
      } catch (error) {
        task.fail(error.toString());
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
      tasks: [
        EtherTask(
          id: 'action_1',
          goal: goal,
        ),
      ],
    );

    final result = await execute(plan);

    return result.tasks
        .map(
          (task) =>
              '${task.id}: ${task.status.name} ${task.result}',
        )
        .join('\n');
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

  bool _looksFinancial(String input) {
    final lower = input.toLowerCase();

    const terms = [
      'pay',
      'payment',
      'purchase',
      'buy',
      'spend',
      'withdraw',
      'subscription',
      'subscribe',
      'advertising budget',
      'paid advertising',
      'pay for advertising',
      'transfer money',
      'send money',
      'charge',
      'order',
    ];

    return terms.any(lower.contains);
  }
}
