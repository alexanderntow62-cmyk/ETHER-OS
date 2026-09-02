import 'package:test/test.dart';
import 'package:ether_os/api/v2/models/ether_api_task.dart';
import 'package:ether_os/api/v2/tasks/ether_api_task_registry.dart';
import 'package:ether_os/api/v2/tasks/ether_api_task_service.dart';

void main() {
  test('task starts in created state', () {
    final task = EtherApiTask(id: 'task-1', description: 'Test task');

    expect(task.status, EtherApiTaskStatus.created);
    expect(task.id, 'task-1');
    expect(task.description, 'Test task');
  });

  test('task transitions update timestamps and status', () {
    final task = EtherApiTask(id: 'task-1', description: 'Test task');

    final originalUpdatedAt = task.updatedAt;

    task.transition(EtherApiTaskStatus.running);

    expect(task.status, EtherApiTaskStatus.running);
    expect(
      task.updatedAt.isAfter(originalUpdatedAt) ||
          task.updatedAt.isAtSameMomentAs(originalUpdatedAt),
      true,
    );
  });

  test('task completes with result', () {
    final task = EtherApiTask(id: 'task-1', description: 'Complete task');

    task.complete('done');

    expect(task.status, EtherApiTaskStatus.completed);
    expect(task.result, 'done');
    expect(task.error, isNull);
  });

  test('task fails with error', () {
    final task = EtherApiTask(id: 'task-1', description: 'Fail task');

    task.fail('something went wrong');

    expect(task.status, EtherApiTaskStatus.failed);
    expect(task.error, 'something went wrong');
    expect(task.result, isNull);
  });

  test('task serializes correctly', () {
    final task = EtherApiTask(
      id: 'task-1',
      description: 'Test task',
      result: 'done',
    );

    final json = task.toJson();

    expect(json['id'], 'task-1');
    expect(json['description'], 'Test task');
    expect(json['status'], 'created');
    expect(json['result'], 'done');
    expect(json['created_at'], isA<String>());
    expect(json['updated_at'], isA<String>());
  });

  test('registry creates and retrieves tasks', () {
    final registry = EtherApiTaskRegistry();

    final task = registry.create('Build ETHER');

    expect(registry.get(task.id), same(task));
    expect(registry.all(), contains(same(task)));
  });

  test('registry cancels active task', () {
    final registry = EtherApiTaskRegistry();

    final task = registry.create('Cancel me');

    expect(registry.cancel(task.id), true);
    expect(task.status, EtherApiTaskStatus.cancelled);
  });

  test('registry cannot cancel completed task', () {
    final registry = EtherApiTaskRegistry();

    final task = registry.create('Already done');

    task.complete('done');

    expect(registry.cancel(task.id), false);
    expect(task.status, EtherApiTaskStatus.completed);
  });

  test('task service executes operation', () async {
    final service = EtherApiTaskService();

    final task = service.create('Execute something');

    final result = await service.execute(task, () async => 'execution-result');

    expect(result.status, EtherApiTaskStatus.completed);
    expect(result.result, 'execution-result');
  });

  test('task service records failed operation', () async {
    final service = EtherApiTaskService();

    final task = service.create('Fail something');

    final result = await service.execute(task, () async {
      throw Exception('execution failed');
    });

    expect(result.status, EtherApiTaskStatus.failed);
    expect(result.error, contains('execution failed'));
  });
}
