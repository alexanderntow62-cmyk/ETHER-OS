import 'business_approval_queue.dart';
import 'business_task.dart';

class BusinessApprovalController {
  final BusinessApprovalQueue queue;

  BusinessApprovalController({BusinessApprovalQueue? queue})
      : queue = queue ?? BusinessApprovalQueue();

  List<BusinessTask> get pendingApprovals =>
      queue.items;

  int get pendingCount =>
      queue.pendingCount;

  bool approve(BusinessTask task) {
    return queue.approve(task);
  }

  bool reject(
    BusinessTask task, {
    String reason = 'Rejected by user.',
  }) {
    return queue.reject(task, reason: reason);
  }

  bool isPending(BusinessTask task) {
    return queue.items.contains(task) &&
        task.status == BusinessTaskStatus.waitingApproval;
  }
}
