import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ether_os/agent/ether_plan.dart';
import 'package:ether_os/agent/ether_task.dart';
import 'package:ether_os/ai/brain/ether_brain.dart';
import 'package:ether_os/fek/action/ether_action_fek.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  group('FEK-2 Skill and Tool Dispatch', () {
    test(
      'FEK-2 can execute a calculator task through the existing skill engine',
      () async {
        final brain = EtherBrain();
        final action = EtherActionFEK(brain: brain);

        final plan = EtherPlan(
          goal: 'calculate 25 times 4',
          tasks: [EtherTask(id: 'calc_1', goal: 'calculate 25 times 4')],
        );

        final result = await action.execute(plan);

        expect(result.tasks.first.status, EtherTaskStatus.completed);

        expect(result.tasks.first.result, contains('100'));
      },
    );

    test('FEK-2 exposes registered tool names', () {
      final brain = EtherBrain();
      final action = EtherActionFEK(brain: brain);

      expect(action.toolNames, isA<List<String>>());
    });

    test('FEK-2 does not execute financial business tasks', () async {
      final brain = EtherBrain();
      final action = EtherActionFEK(brain: brain);

      final plan = EtherPlan(
        goal: 'pay for advertising',
        tasks: [EtherTask(id: 'finance_1', goal: 'pay for advertising')],
      );

      final result = await action.execute(plan);

      expect(result.tasks.first.status, EtherTaskStatus.failed);

      expect(result.tasks.first.result.toLowerCase(), contains('approval'));
    });
  });
}
