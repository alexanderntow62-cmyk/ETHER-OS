import 'package:flutter_test/flutter_test.dart';
import '../lib/business/ether_business_engine.dart';
import '../lib/business/business_permission.dart';
import '../lib/business/business_task.dart';

void main() {
  test('ETHER engine exposes pending approval and approval workflow', () async {
    final engine = EtherBusinessEngine();

    final task = engine.createTask(
      id: 'engine_approval_1',
      goal: 'Prepare a customer campaign',
      permission: BusinessPermission.approvalRequired,
    );

    final result = await engine.execute(task);

    expect(result, contains('APPROVAL REQUIRED'));
    expect(task.status, BusinessTaskStatus.waitingApproval);
    expect(engine.pendingApprovalCount, 1);

    final approved = engine.approveTask(task);

    expect(approved, isTrue);
    expect(task.status, BusinessTaskStatus.approved);
    expect(engine.pendingApprovalCount, 0);
  });

  test('ETHER engine rejects queued tasks through its approval API', () async {
    final engine = EtherBusinessEngine();

    final task = engine.createTask(
      id: 'engine_rejection_1',
      goal: 'Launch an advertising campaign',
      permission: BusinessPermission.approvalRequired,
    );

    await engine.execute(task);

    expect(engine.pendingApprovalCount, 1);

    final rejected = engine.rejectTask(
      task,
      reason: 'User rejected this campaign.',
    );

    expect(rejected, isTrue);
    expect(task.status, BusinessTaskStatus.failed);
    expect(task.result, contains('User rejected this campaign.'));
    expect(engine.pendingApprovalCount, 0);
  });

  test('ETHER engine never executes a financial task automatically', () async {
    final engine = EtherBusinessEngine();

    final task = engine.createTask(
      id: 'engine_financial_1',
      goal: 'Spend money on advertising',
      permission: BusinessPermission.financial,
    );

    final result = await engine.execute(task);

    expect(result, contains('APPROVAL REQUIRED'));
    expect(task.status, BusinessTaskStatus.waitingApproval);
    expect(engine.pendingApprovalCount, 1);
  });
}
