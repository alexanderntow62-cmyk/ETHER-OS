import '../lib/business/business_control_center.dart';
import '../lib/business/business_task.dart';

Future<void> main() async {
  final control = BusinessControlCenter();

  final task = control.operator.createFinancialAction(
    goal: 'Purchase inventory',
  );

  final result = await control.operator.business.execute(task);

  print(result);
  print('');
  print('TASK STATUS: ${task.status.name}');
  print('ENGINE QUEUE: ${control.operator.business.approvalQueue.pendingCount}');
  print('CONTROL QUEUE: ${control.approvalQueue.pendingCount}');
  print(
    'SAME QUEUE: '
    '${identical(control.operator.business.approvalQueue, control.approvalQueue)}',
  );
  print(
    'TASK VISIBLE TO CONTROL CENTER: '
    '${control.approvalQueue.items.contains(task)}',
  );
}
