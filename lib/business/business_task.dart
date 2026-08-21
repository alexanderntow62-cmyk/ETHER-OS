import 'business_permission.dart';

enum BusinessTaskStatus {
  pending,
  running,
  completed,
  waitingApproval,
  approved,
  failed,
}

class BusinessTask {
  final String id;
  final String goal;
  final BusinessPermission permission;

  BusinessTaskStatus status;
  String result;

  BusinessTask({
    required this.id,
    required this.goal,
    this.permission = BusinessPermission.autonomous,
    this.status = BusinessTaskStatus.pending,
    this.result = '',
  });

  bool get requiresApproval =>
      permission != BusinessPermission.autonomous ||
      status == BusinessTaskStatus.waitingApproval;

  bool get isApproved => status == BusinessTaskStatus.approved;

  void start() {
    status = BusinessTaskStatus.running;
  }

  void approve() {
    result = 'APPROVED FOR EXECUTION\n'
        'Action authorized by user: $goal\n'
        'No financial transaction was performed automatically.';
    status = BusinessTaskStatus.approved;
  }

  void complete(String value) {
    result = value;
    status = BusinessTaskStatus.completed;
  }

  void waitForApproval() {
    status = BusinessTaskStatus.waitingApproval;
  }

  void fail(String error) {
    result = error;
    status = BusinessTaskStatus.failed;
  }
}
