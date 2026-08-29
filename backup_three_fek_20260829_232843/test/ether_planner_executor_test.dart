import 'package:flutter_test/flutter_test.dart';

import '../lib/agent/ether_planner.dart';
import '../lib/agent/ether_executor.dart';
import '../lib/agent/ether_task.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ETHER Planner', () {
    test('creates no tasks for empty goal', () {
      final planner = EtherPlanner();
      final plan = planner.createPlan('');

      expect(plan.goal, '');
      expect(plan.tasks, isEmpty);
    });

    test('creates a task for a normal goal', () {
      final planner = EtherPlanner();
      final plan = planner.createPlan('calculate 25 times 4');

      expect(plan.tasks, isNotEmpty);
      expect(plan.tasks.length, 1);
      expect(plan.tasks.first.goal, 'calculate 25 times 4');
      expect(plan.tasks.first.status, EtherTaskStatus.pending);
    });

    test('decomposes profit calculation into multiple tasks', () {
      final planner = EtherPlanner();
      final plan = planner.createPlan(
        'calculate profit and margin for cost 50 selling price 100',
      );

      expect(plan.tasks.length, 4);
      expect(plan.tasks[0].id, 'task_1');
      expect(plan.tasks[1].id, 'task_2');
      expect(plan.tasks[2].id, 'task_3');
      expect(plan.tasks[3].id, 'task_4');
    });
  });

  group('ETHER Executor', () {
    test('executes a pending task and changes its status', () async {
      final planner = EtherPlanner();
      final executor = EtherExecutor();

      final plan = planner.createPlan('calculate 25 times 4');

      final result = await executor.execute(plan);

      expect(result.tasks.length, 1);
      expect(
        result.tasks.first.status,
        anyOf(
          EtherTaskStatus.completed,
          EtherTaskStatus.failed,
        ),
      );
      expect(result.tasks.first.result, isNotEmpty);
    });

    test('does not execute an already completed task', () async {
      final planner = EtherPlanner();
      final executor = EtherExecutor();

      final plan = planner.createPlan('calculate 25 times 4');
      plan.tasks.first.complete('100');

      final result = await executor.execute(plan);

      expect(result.tasks.first.status, EtherTaskStatus.completed);
      expect(result.tasks.first.result, '100');
    });
  });
}
