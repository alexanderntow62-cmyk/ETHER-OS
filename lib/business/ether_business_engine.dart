import 'business_permission.dart';
import 'business_task.dart';
import 'business_planner.dart';
import 'business_approval_queue.dart';
import 'business_execution_gate.dart';
import 'integrations/business_integration_registry.dart';
import 'integrations/business_integration_result.dart';
import 'integrations/business_integration_action_policy.dart';

class EtherBusinessEngine {
  final List<BusinessTask> _tasks = [];

  final EtherBusinessPlanner planner;
  final BusinessApprovalQueue approvalQueue;
  final BusinessExecutionGate executionGate;
  final BusinessIntegrationRegistry integrations;
  final BusinessIntegrationActionPolicy integrationActionPolicy;

  EtherBusinessEngine({
    EtherBusinessPlanner? planner,
    BusinessApprovalQueue? approvalQueue,
    BusinessExecutionGate? executionGate,
    BusinessIntegrationRegistry? integrations,
    BusinessIntegrationActionPolicy? integrationActionPolicy,
  })  : planner = planner ?? EtherBusinessPlanner(),
        approvalQueue = approvalQueue ?? BusinessApprovalQueue(),
        executionGate = executionGate ?? BusinessExecutionGate(),
        integrations =
            integrations ?? BusinessIntegrationRegistry(),
        integrationActionPolicy =
            integrationActionPolicy ??
                const BusinessIntegrationActionPolicy();

  List<BusinessTask> get tasks => List.unmodifiable(_tasks);

  BusinessTask createTask({
    required String id,
    required String goal,
    BusinessPermission permission = BusinessPermission.autonomous,
  }) {
    final task = BusinessTask(
      id: id,
      goal: goal,
      permission: permission,
    );

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

  Future<BusinessIntegrationResult> executeIntegration({
    required BusinessTask task,
    required String integrationId,
    required String action,
    Map<String, dynamic> parameters = const {},
  }) async {
    if (!integrations.contains(integrationId)) {
      return BusinessIntegrationResult.failure(
        integration: integrationId,
        action: action,
        message: 'Integration "$integrationId" is not registered.',
      );
    }

    // Fail closed: an integration may only execute actions
    // that it explicitly declares as supported capabilities.
    if (!integrations.supportsAction(
      integrationId: integrationId,
      action: action,
    )) {
      return BusinessIntegrationResult.failure(
        integration: integrationId,
        action: action,
        message:
            'ACTION NOT SUPPORTED. '
            'Integration "$integrationId" does not declare action "$action".',
      );
    }

    final risk = integrationActionPolicy.classify(
      integrationId: integrationId,
      action: action,
    );

    if (risk == BusinessIntegrationActionRisk.financial ||
        task.permission == BusinessPermission.financial) {
      task.waitForApproval();
      approvalQueue.add(task);

      return BusinessIntegrationResult.failure(
        integration: integrationId,
        action: action,
        message:
            'FINANCIAL EXECUTION BLOCKED. '
            'User approval is required before this integration action.',
      );
    }

    if (risk == BusinessIntegrationActionRisk.approvalRequired ||
        task.permission == BusinessPermission.approvalRequired) {
      task.waitForApproval();
      approvalQueue.add(task);

      return BusinessIntegrationResult.failure(
        integration: integrationId,
        action: action,
        message:
            'APPROVAL REQUIRED. '
            'This integration action requires user approval.',
      );
    }

    if (task.status != BusinessTaskStatus.approved) {
      return BusinessIntegrationResult.failure(
        integration: integrationId,
        action: action,
        message:
            'EXECUTION BLOCKED. '
            'The business task has not been approved for execution.',
      );
    }

    return integrations.execute(
      integrationId: integrationId,
      action: action,
      parameters: parameters,
    );
  }

  bool approveTask(BusinessTask task) {
    if (!approvalQueue.approve(task)) {
      return false;
    }

    task.approve();
    return true;
  }

  bool rejectTask(
    BusinessTask task, {
    String reason = 'Rejected by user.',
  }) {
    return approvalQueue.reject(
      task,
      reason: reason,
    );
  }

  int get pendingApprovalCount => approvalQueue.pendingCount;

  void clearTasks() {
    _tasks.clear();
    approvalQueue.clear();
  }
}
