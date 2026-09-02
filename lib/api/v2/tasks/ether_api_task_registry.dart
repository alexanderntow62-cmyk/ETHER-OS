import '../models/ether_api_task.dart';

class EtherApiTaskRegistry {
  final Map<String, EtherApiTask> _tasks = {};

  EtherApiTask create(String description) {
    final id = 'task-${DateTime.now().microsecondsSinceEpoch}';

    final task = EtherApiTask(id: id, description: description);

    _tasks[id] = task;
    return task;
  }

  EtherApiTask? get(String id) {
    return _tasks[id];
  }

  List<EtherApiTask> all() {
    return List.unmodifiable(_tasks.values.toList());
  }

  bool cancel(String id) {
    final task = _tasks[id];

    if (task == null) {
      return false;
    }

    if (task.status == EtherApiTaskStatus.completed ||
        task.status == EtherApiTaskStatus.failed ||
        task.status == EtherApiTaskStatus.cancelled) {
      return false;
    }

    task.transition(EtherApiTaskStatus.cancelled);
    return true;
  }

  void clear() {
    _tasks.clear();
  }
}
