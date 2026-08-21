import '../lib/business/ether_business_engine.dart';
import '../lib/business/business_approval_controller.dart';

Future<void> main() async {
  final engine = EtherBusinessEngine();

  final task = engine.createTask(
    id: 'approval_controller_test',
    goal: 'Start an affiliate marketing business with no money',
  );

  await engine.execute(task);

  final controller = BusinessApprovalController(
    queue: engine.approvalQueue,
  );

  print('INITIAL STATUS: ${task.status.name}');
  print('PENDING: ${controller.pendingCount}');
  print('IS PENDING: ${controller.isPending(task)}');

  final approved = controller.approve(task);

  print('APPROVED: $approved');
  print('AFTER APPROVE QUEUE: ${controller.pendingCount}');
  print('STATUS AFTER APPROVE: ${task.status.name}');
}
