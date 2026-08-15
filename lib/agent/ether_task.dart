enum EtherTaskStatus {
  pending,
  running,
  completed,
  failed,
}

class EtherTask {
  final String id;
  final String goal;
  EtherTaskStatus status;
  String result;

  EtherTask({
    required this.id,
    required this.goal,
    this.status = EtherTaskStatus.pending,
    this.result = '',
  });

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
