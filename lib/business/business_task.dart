import 'business_permission.dart';

enum BusinessTaskStatus { pending, running, completed, waitingApproval, failed }

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

  bool get requiresApproval => permission != BusinessPermission.autonomous;

  void start() {
    status = BusinessTaskStatus.running;
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
