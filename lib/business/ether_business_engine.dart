import 'business_permission.dart';
import 'business_task.dart';
import 'business_planner.dart';
import 'business_approval_queue.dart';
import 'business_execution_gate.dart';

class EtherBusinessEngine {
  final List<BusinessTask> _tasks = [];
  final EtherBusinessPlanner planner;
final BusinessApprovalQueue approvalQueue;
final BusinessExecutionGate executionGate;

  EtherBusinessEngine({
  EtherBusinessPlanner? planner,
  BusinessApprovalQueue? approvalQueue,
BusinessExecutionGate? executionGate,
})  : planner = planner ?? EtherBusinessPlanner(),
      approvalQueue = approvalQueue ?? BusinessApprovalQueue(),
      executionGate = executionGate ?? BusinessExecutionGate();

  List<BusinessTask> get tasks => List.unmodifiable(_tasks);

  BusinessTask createTask({
    required String id,
    required String goal,
    BusinessPermission permission = BusinessPermission.autonomous,
  }) {
    final task = BusinessTask(id: id, goal: goal, permission: permission);

    _tasks.add(task);
    return task;
  }

  Future<String> execute(BusinessTask task) async {
    if (task.permission == BusinessPermission.financial) {
      task.waitForApproval();
      approvalQueue.add(task);

      return 'APPROVAL REQUIRED\n'
          'ETHER cannot execute financial actions autonomously.\n'
          'Action: ${task.goal}';
    }

    if (task.permission == BusinessPermission.approvalRequired) {
      task.waitForApproval();
      approvalQueue.add(task);

      return 'APPROVAL REQUIRED\n'
          'ETHER prepared this business action but needs your approval.\n'
          'Action: ${task.goal}';
    }

    // Autonomous business work is authorized internally,
    // then passed through the execution gate.
    task.waitForApproval();
    task.approve();

    final plan = planner.createPlan(task.goal);

    if (plan.steps.isEmpty) {
      task.fail('ETHER could not create a business plan.');
      return task.result;
    }

    final lines = <String>[
      'BUSINESS EXECUTION',
      '',
      'Goal: ${plan.goal}',
      '',
      'Autonomous execution:',
    ];

    for (final step in plan.steps) {
      if (step.permission == BusinessPermission.financial) {
        lines.add('');
        lines.add('STOPPED AT FINANCIAL BOUNDARY');
        lines.add('Step: ${step.title}');
        lines.add('Permission: FINANCIAL');
        lines.add('Action: ${step.description}');
        lines.add('');
        lines.add('APPROVAL REQUIRED');
        lines.add(
          'ETHER completed the autonomous preparation '
          'but will not spend money or make financial commitments '
          'without your approval.',
        );

        task.waitForApproval();
        approvalQueue.add(task);
        task.result = lines.join('\n');
        return task.result;
      }

      lines.add('${step.id} — ${step.title}');
      lines.add('  EXECUTED');
      lines.add('  ${step.description}');
    }

    return executionGate.execute(
      task,
      executionResult: lines.join('\n'),
    );
  }

  bool approveTask(BusinessTask task) {
    if (!approvalQueue.approve(task)) {
      return false;
    }

    task.approve();
    return true;
  }

  bool rejectTask(BusinessTask task, {String reason = 'Rejected by user.'}) {
    return approvalQueue.reject(task, reason: reason);
  }

  int get pendingApprovalCount => approvalQueue.pendingCount;

  void clearTasks() {
    _tasks.clear();
    approvalQueue.clear();
  }
}
