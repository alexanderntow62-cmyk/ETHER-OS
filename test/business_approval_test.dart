import 'package:flutter_test/flutter_test.dart';
import '../lib/business/business_control_center.dart';
import '../lib/business/business_permission.dart';
import '../lib/business/business_task.dart';

void main() {
  test('financial business task enters approval queue', () async {
    final control = BusinessControlCenter();

    final task = control.operator.createFinancialAction(
      goal: 'Buy product inventory',
    );

    task.waitForApproval();
    control.approvalQueue.add(task);

    expect(task.status, BusinessTaskStatus.waitingApproval);
    expect(control.approvalQueue.pendingCount, 1);
    expect(control.approvalQueue.items, contains(task));
    expect(task.permission, BusinessPermission.financial);
  });

  test('rejecting an approval removes the task and marks it failed', () {
    final control = BusinessControlCenter();

    final task = control.operator.createFinancialAction(
      goal: 'Pay for advertising',
    );

    task.waitForApproval();
    control.approvalQueue.add(task);

    final rejected = control.reject(task);

    expect(rejected, isTrue);
    expect(task.status, BusinessTaskStatus.failed);
    expect(task.result, 'Rejected by user.');
    expect(control.approvalQueue.pendingCount, 0);
  });

  test('approving an approval authorizes the exact task', () async {
    final control = BusinessControlCenter();

    final task = control.operator.createFinancialAction(
      goal: 'Purchase inventory',
    );

    task.waitForApproval();
    control.approvalQueue.add(task);

    final approved = await control.approve(task);

    expect(approved, isTrue);
    expect(control.approvalQueue.pendingCount, 0);
    expect(task.status, BusinessTaskStatus.completed);
    expect(task.result, contains('APPROVED FOR EXECUTION'));
    expect(task.result, contains('Purchase inventory'));
    expect(task.result, contains('No financial transaction was performed'));
  });

  test('cannot approve a task that is not in the approval queue', () async {
    final control = BusinessControlCenter();

    final task = control.operator.createFinancialAction(
      goal: 'Purchase inventory',
    );

    task.waitForApproval();

    final approved = await control.approve(task);

    expect(approved, isFalse);
    expect(task.status, BusinessTaskStatus.waitingApproval);
  });
}
