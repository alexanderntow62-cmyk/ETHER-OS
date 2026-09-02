import '../models/ether_api_task.dart';
import 'ether_api_task_registry.dart';

class EtherApiTaskService {
  final EtherApiTaskRegistry registry;

  EtherApiTaskService({EtherApiTaskRegistry? registry})
    : registry = registry ?? EtherApiTaskRegistry();

  EtherApiTask create(String description) {
    return registry.create(description);
  }

  EtherApiTask? get(String id) {
    return registry.get(id);
  }

  List<EtherApiTask> all() {
    return registry.all();
  }

  bool cancel(String id) {
    return registry.cancel(id);
  }

  Future<EtherApiTask> execute(
    EtherApiTask task,
    Future<dynamic> Function() operation,
  ) async {
    if (task.status == EtherApiTaskStatus.cancelled) {
      return task;
    }

    task.transition(EtherApiTaskStatus.queued);

    try {
      task.transition(EtherApiTaskStatus.running);

      final result = await operation();

      if (task.status != EtherApiTaskStatus.cancelled) {
        task.complete(result);
      }

      return task;
    } catch (error) {
      if (task.status != EtherApiTaskStatus.cancelled) {
        task.fail(error.toString());
      }

      return task;
    }
  }
}
