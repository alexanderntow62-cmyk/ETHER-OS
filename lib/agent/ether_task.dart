enum EtherTaskStatus { pending, running, completed, failed }

enum EtherTaskType {
  general,
  calculator,
  system,
  research,
  product,
  marketing,
  customer,
  finance,
}

class EtherTask {
  final String id;
  final String goal;
  final EtherTaskType type;

  EtherTaskStatus status;
  String result;

  EtherTask({
    required this.id,
    required this.goal,
    this.type = EtherTaskType.general,
    this.status = EtherTaskStatus.pending,
    this.result = '',
  });

  bool get isFinancial => type == EtherTaskType.finance;

  void start() {
    status = EtherTaskStatus.running;
  }

  void complete(String output) {
    status = EtherTaskStatus.completed;
    result = output;
  }

  void fail(String error) {
    status = EtherTaskStatus.failed;
    result = error;
  }
}
