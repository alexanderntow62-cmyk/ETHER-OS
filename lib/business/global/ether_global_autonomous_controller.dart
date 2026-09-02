import '../../agent/ether_plan.dart';
import '../../agent/ether_task.dart';
import '../../fek/action/ether_action_fek.dart';
import 'ether_global_business_engine.dart';
import 'execution/ether_autonomous_task_queue.dart';
import 'learning/ether_business_measurement.dart';

/// Coordinates the complete global-business lifecycle.
///
/// Lifecycle:
///
/// DISCOVER
///   ↓
/// SCORE
///   ↓
/// CREATE
///   ↓
/// MISSION
///   ↓
/// QUEUE
///   ↓
/// EXECUTE PERMITTED TASKS
///   ↓
/// MEASURE
///   ↓
/// LEARN
///   ↓
/// SCALE
///
/// Financial operations never bypass the approval boundary.
class EtherGlobalAutonomousController {
  final EtherGlobalBusinessEngine global;
  final EtherActionFEK? action;

  EtherGlobalAutonomousController({
    EtherGlobalBusinessEngine? global,
    this.action,
  }) : global = global ?? EtherGlobalBusinessEngine();

  /// Produces the current global-business strategy without
  /// executing any financial action.
  String review() {
    return global.reviewBusiness();
  }

  /// Creates the initial mission queue.
  List<EtherAutonomousTask> initializeMission() {
    return global.generateInitialTasks();
  }

  /// Returns the next task that is safe to consider for execution.
  EtherAutonomousTask? nextSafeTask() {
    final task = global.nextTask;

    if (task == null) {
      return null;
    }

    if (task.requiresFinancialApproval) {
      return null;
    }

    return task;
  }

  /// Executes the next permitted task through FEK-2.
  ///
  /// This controller never executes financial tasks directly.
  /// Financial tasks remain blocked until the user approves them.
  Future<String> executeNextPermittedTask() async {
    final task = nextSafeTask();

    if (task == null) {
      return 'No permitted autonomous global-business task is ready.';
    }

    global.taskQueue.start(task.id);

    try {
      if (action == null) {
        global.taskQueue.complete(task.id);

        return [
          'GLOBAL BUSINESS TASK',
          '',
          'Task: ${task.title}',
          'Phase: ${task.phase}',
          '',
          'Task prepared successfully.',
          'No financial action was performed.',
        ].join('\n');
      }

      final plan = EtherPlan(
        goal: task.description,
        tasks: [
          EtherTask(
            id: task.id,
            goal: task.description,
            type: EtherTaskType.general,
          ),
        ],
      );

      final completedPlan = await action!.execute(plan);

      if (completedPlan.tasks.isEmpty) {
        global.taskQueue.fail(task.id);

        return [
          'GLOBAL BUSINESS TASK FAILED',
          '',
          'Task: ${task.title}',
          'Phase: ${task.phase}',
          '',
          'FEK-2 returned an empty execution plan.',
        ].join('\\n');
      }

      final executedTask = completedPlan.tasks.first;

      if (executedTask.status == EtherTaskStatus.completed) {
        global.taskQueue.complete(task.id);
      } else {
        global.taskQueue.fail(task.id);
      }

      return [
        'GLOBAL BUSINESS TASK',
        '',
        'Task: ${task.title}',
        'Phase: ${task.phase}',
        '',
        'FEK-2 STATUS: ${executedTask.status.name}',
        '',
        executedTask.result,
        '',
        'FINANCIAL SAFETY',
        'No financial commitment was made automatically.',
      ].join('\\n');
    } catch (error) {
      global.taskQueue.fail(task.id);

      return [
        'GLOBAL BUSINESS TASK FAILED',
        '',
        'Task: ${task.title}',
        'Error: $error',
      ].join('\n');
    }
  }

  /// Records measurable business results.
  void measure({
    required String businessId,
    double revenue = 0,
    double costs = 0,
    int customers = 0,
    int completedTasks = 0,
  }) {
    global.recordMeasurement(
      businessId: businessId,
      revenue: revenue,
      costs: costs,
      customers: customers,
      completedTasks: completedTasks,
    );
  }

  /// Returns the current learning recommendation.
  String learn() {
    return global.learning.recommendation();
  }

  /// Evaluates whether the business has earned the right to scale.
  String evaluateScaling() {
    final decision = global.evaluateScaling();

    return [
      'GLOBAL BUSINESS SCALING',
      '',
      'Scale: ${decision.shouldScale}',
      'Reason: ${decision.reason}',
      '',
      'ACTIONS:',
      ...decision.actions.map((action) => '- $action'),
      '',
      'FINANCIAL SAFETY',
      'Financial commitments remain approval-gated.',
    ].join('\n');
  }

  /// Returns the latest measurement when available.
  EtherBusinessMeasurement? get latestMeasurement => global.learning.latest;

  /// Whether autonomous tasks remain queued.
  bool get hasPendingTasks => global.pendingTasks.isNotEmpty;

  /// Number of queued tasks.
  int get pendingTaskCount => global.pendingTasks.length;
}
