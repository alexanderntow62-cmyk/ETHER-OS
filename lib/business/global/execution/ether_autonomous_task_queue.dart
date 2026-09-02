enum EtherAutonomousTaskStatus { pending, running, completed, failed, blocked }

class EtherAutonomousTask {
  final String id;
  final String businessId;
  final String title;
  final String description;
  final String phase;
  final bool requiresFinancialApproval;

  EtherAutonomousTaskStatus status;

  EtherAutonomousTask({
    required this.id,
    required this.businessId,
    required this.title,
    required this.description,
    required this.phase,
    this.requiresFinancialApproval = false,
    this.status = EtherAutonomousTaskStatus.pending,
  });
}

class EtherAutonomousTaskQueue {
  final List<EtherAutonomousTask> _tasks = [];

  void add(EtherAutonomousTask task) {
    _tasks.add(task);
  }

  void addAll(Iterable<EtherAutonomousTask> tasks) {
    _tasks.addAll(tasks);
  }

  List<EtherAutonomousTask> get tasks => List.unmodifiable(_tasks);

  List<EtherAutonomousTask> get pendingTasks => List.unmodifiable(
    _tasks.where((task) => task.status == EtherAutonomousTaskStatus.pending),
  );

  EtherAutonomousTask? nextTask() {
    for (final task in _tasks) {
      if (task.status == EtherAutonomousTaskStatus.pending) {
        return task;
      }
    }

    return null;
  }

  void start(String taskId) {
    final task = _find(taskId);

    if (task == null || task.status != EtherAutonomousTaskStatus.pending) {
      return;
    }

    if (task.requiresFinancialApproval) {
      task.status = EtherAutonomousTaskStatus.blocked;
      return;
    }

    task.status = EtherAutonomousTaskStatus.running;
  }

  void complete(String taskId) {
    final task = _find(taskId);

    if (task == null) {
      return;
    }

    task.status = EtherAutonomousTaskStatus.completed;
  }

  void fail(String taskId) {
    final task = _find(taskId);

    if (task == null) {
      return;
    }

    task.status = EtherAutonomousTaskStatus.failed;
  }

  EtherAutonomousTask? _find(String taskId) {
    for (final task in _tasks) {
      if (task.id == taskId) {
        return task;
      }
    }

    return null;
  }
}
