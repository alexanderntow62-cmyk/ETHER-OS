import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../lib/agent/ether_plan.dart';
import '../lib/agent/ether_task.dart';
import '../lib/ai/brain/ether_brain.dart';
import '../lib/fek/action/business/ether_business_executor.dart';
import '../lib/fek/action/ether_action_fek.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  group('FEK-2 Business Executor', () {
    test('executes a permitted research task', () async {
      final executor = EtherBusinessExecutor();

      final task = EtherTask(
        id: 'research_1',
        goal: 'research the dropshipping market',
      );

      final result = await executor.execute(task);

      expect(result, isNotNull);
      expect(result, contains('FEK-2 BUSINESS EXECUTOR'));
      expect(result, contains('RESEARCH'));
    });

    test('executes a permitted product task without spending money', () async {
      final executor = EtherBusinessExecutor();

      final task = EtherTask(
        id: 'product_1',
        goal: 'find products for my dropshipping store',
      );

      final result = await executor.execute(task);

      expect(result, isNotNull);
      expect(result, contains('PRODUCT'));
      expect(
        result,
        contains('No purchase or financial commitment performed.'),
      );
    });

    test(
      'executes a permitted marketing task without paid advertising',
      () async {
        final executor = EtherBusinessExecutor();

        final task = EtherTask(
          id: 'marketing_1',
          goal: 'create a marketing campaign',
        );

        final result = await executor.execute(task);

        expect(result, isNotNull);
        expect(result, contains('MARKETING'));
        expect(result, contains('No paid advertising'));
      },
    );

    test('blocks financial execution', () async {
      final executor = EtherBusinessExecutor();

      final task = EtherTask(id: 'finance_1', goal: 'pay for advertising');

      final result = await executor.execute(task);

      expect(result, isNotNull);
      expect(result, contains('FEK-2 BLOCKED'));
      expect(result, contains('user approval'));
    });

    test('FEK-2 marks permitted business tasks completed', () async {
      final brain = EtherBrain();
      final action = EtherActionFEK(brain: brain);

      final plan = EtherPlan(
        goal: 'start a dropshipping business',
        tasks: [
          EtherTask(id: 'business_1', goal: 'research the dropshipping market'),
        ],
      );

      final result = await action.execute(plan);

      expect(result.tasks.first.status, EtherTaskStatus.completed);
      expect(result.tasks.first.result, contains('FEK-2 BUSINESS EXECUTOR'));
    });

    test(
      'FEK-2 marks financial tasks failed instead of executing them',
      () async {
        final brain = EtherBrain();
        final action = EtherActionFEK(brain: brain);

        final plan = EtherPlan(
          goal: 'pay for advertising',
          tasks: [EtherTask(id: 'finance_1', goal: 'pay for advertising')],
        );

        final result = await action.execute(plan);

        expect(result.tasks.first.status, EtherTaskStatus.failed);
        expect(result.tasks.first.result, contains('FEK-2 BLOCKED'));
      },
    );
  });
}
