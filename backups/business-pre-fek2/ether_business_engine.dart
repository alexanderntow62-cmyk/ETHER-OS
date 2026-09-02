import 'business_permission.dart';
import 'business_task.dart';
import 'business_planner.dart';

class EtherBusinessEngine {
  final List<BusinessTask> _tasks = [];
  final EtherBusinessPlanner planner;

  EtherBusinessEngine({EtherBusinessPlanner? planner})
    : planner = planner ?? EtherBusinessPlanner();

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

      return 'APPROVAL REQUIRED\n'
          'ETHER cannot execute financial actions autonomously.\n'
          'Action: ${task.goal}';
    }

    if (task.permission == BusinessPermission.approvalRequired) {
      task.waitForApproval();

      return 'APPROVAL REQUIRED\n'
          'ETHER prepared this business action but needs your approval.\n'
          'Action: ${task.goal}';
    }

    task.start();

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
        task.result = lines.join('\n');
        return task.result;
      }

      lines.add('${step.id} — ${step.title}');
      lines.add('  EXECUTED');
      lines.add('  ${step.description}');
    }

    task.complete(lines.join('\n'));
    return task.result;
  }

  void clearTasks() {
    _tasks.clear();
  }
}
