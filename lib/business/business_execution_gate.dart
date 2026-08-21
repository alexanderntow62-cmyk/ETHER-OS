import 'business_permission.dart';
import 'business_task.dart';

class BusinessExecutionGate {
  String execute(
    BusinessTask task, {
    String? executionResult,
  }) {
    if (task.status != BusinessTaskStatus.approved) {
      return 'EXECUTION BLOCKED\n'
          'Task must be approved before execution.\n'
          'Action: ${task.goal}';
    }

    if (task.permission == BusinessPermission.financial) {
      return 'FINANCIAL EXECUTION BLOCKED\n'
          'ETHER will not perform financial transactions automatically.\n'
          'Authorized action: ${task.goal}';
    }

    task.complete(
      executionResult ??
          'EXECUTION COMPLETED\n'
          'Action: ${task.goal}',
    );

    return task.result;
  }
}
