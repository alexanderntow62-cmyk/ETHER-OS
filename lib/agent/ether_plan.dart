import 'ether_task.dart';

class EtherPlan {
  final String goal;
  final List<EtherTask> tasks;

  EtherPlan({required this.goal, required this.tasks});

  bool get isComplete =>
      tasks.isNotEmpty &&
      tasks.every((task) => task.status == EtherTaskStatus.completed);

  bool get hasFailed =>
      tasks.any((task) => task.status == EtherTaskStatus.failed);
}
