import 'package:flutter_test/flutter_test.dart';

import '../lib/business/business_execution_gate.dart';
import '../lib/business/business_permission.dart';
import '../lib/business/business_task.dart';

void main() {
  test('cannot execute a task that has not been approved', () {
    final gate = BusinessExecutionGate();

    final task = BusinessTask(
      id: 'gate_pending',
      goal: 'Publish prepared business content',
      permission: BusinessPermission.autonomous,
    );

    final result = gate.execute(task);

    expect(task.status, BusinessTaskStatus.pending);
    expect(result, contains('EXECUTION BLOCKED'));
  });

  test('approved financial task remains blocked from automatic execution', () {
    final gate = BusinessExecutionGate();

    final task = BusinessTask(
      id: 'gate_financial',
      goal: 'Purchase inventory',
      permission: BusinessPermission.financial,
    );

    task.waitForApproval();
    task.approve();

    final result = gate.execute(task);

    expect(task.status, BusinessTaskStatus.approved);
    expect(result, contains('FINANCIAL EXECUTION BLOCKED'));
    expect(result, contains('Purchase inventory'));
  });

  test('approved autonomous task can execute', () {
    final gate = BusinessExecutionGate();

    final task = BusinessTask(
      id: 'gate_autonomous',
      goal: 'Publish prepared business content',
      permission: BusinessPermission.autonomous,
    );

    task.waitForApproval();
    task.approve();

    final result = gate.execute(task);

    expect(task.status, BusinessTaskStatus.completed);
    expect(result, contains('EXECUTION COMPLETED'));
    expect(result, contains('Publish prepared business content'));
  });
}
