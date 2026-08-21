import 'package:flutter_test/flutter_test.dart';
import '../lib/business/business_approval_queue.dart';
import '../lib/business/business_execution_gate.dart';
import '../lib/business/business_permission.dart';
import '../lib/business/business_task.dart';

void main() {
  test('ETHER completes an approved non-financial task', () {
    final queue = BusinessApprovalQueue();
    final gate = BusinessExecutionGate();

    final task = BusinessTask(
      id: 'approval_test_1',
      goal: 'Prepare a customer outreach campaign',
      permission: BusinessPermission.approvalRequired,
    );

    task.waitForApproval();
    queue.add(task);

    expect(task.status, BusinessTaskStatus.waitingApproval);
    expect(queue.pendingCount, 1);

    final approved = queue.approve(task);
    expect(approved, isTrue);
    expect(queue.pendingCount, 0);

    task.approve();

    expect(task.status, BusinessTaskStatus.approved);

    final result = gate.execute(
      task,
      executionResult: 'Customer outreach campaign prepared.',
    );

    expect(result, contains('Customer outreach campaign prepared.'));
    expect(task.status, BusinessTaskStatus.completed);
  });

  test('ETHER blocks financial execution even after approval', () {
    final queue = BusinessApprovalQueue();
    final gate = BusinessExecutionGate();

    final task = BusinessTask(
      id: 'financial_test_1',
      goal: 'Purchase advertising',
      permission: BusinessPermission.financial,
    );

    task.waitForApproval();
    queue.add(task);

    expect(task.status, BusinessTaskStatus.waitingApproval);
    expect(queue.pendingCount, 1);

    final approved = queue.approve(task);
    expect(approved, isTrue);
    expect(queue.pendingCount, 0);

    task.approve();

    expect(task.status, BusinessTaskStatus.approved);

    final result = gate.execute(
      task,
      executionResult: 'This must never execute.',
    );

    expect(result, contains('FINANCIAL EXECUTION BLOCKED'));
    expect(task.status, BusinessTaskStatus.approved);
    expect(result, isNot(contains('This must never execute.')));
  });

  test('ETHER rejects a task that is not approved', () {
    final gate = BusinessExecutionGate();

    final task = BusinessTask(
      id: 'blocked_test_1',
      goal: 'Publish business campaign',
      permission: BusinessPermission.approvalRequired,
    );

    task.waitForApproval();

    final result = gate.execute(
      task,
      executionResult: 'Should not execute.',
    );

    expect(result, contains('EXECUTION BLOCKED'));
    expect(task.status, BusinessTaskStatus.waitingApproval);
  });
}
