import 'ether_plan.dart';
import 'ether_task.dart';

class EtherPlanner {
  EtherPlan createPlan(String goal) {
    final input = goal.trim();

    if (input.isEmpty) {
      return EtherPlan(goal: input, tasks: []);
    }

    final lower = input.toLowerCase();
    final tasks = <EtherTask>[];

    if (lower.contains('profit') ||
        lower.contains('profitable') ||
        lower.contains('margin')) {
      final numbers = RegExp(r'\d+(?:\.\d+)?')
          .allMatches(input)
          .map((match) => double.parse(match.group(0)!))
          .toList();

      if (numbers.length >= 2) {
        final cost = numbers[0];
        final sellingPrice = numbers[1];
        final profit = sellingPrice - cost;
        final margin = sellingPrice == 0 ? 0 : (profit / sellingPrice) * 100;

        tasks.add(
          EtherTask(
            id: 'task_1',
            goal: 'Product cost is $cost and selling price is $sellingPrice.',
          ),
        );

        tasks.add(
          EtherTask(id: 'task_2', goal: 'Calculate $sellingPrice minus $cost.'),
        );

        tasks.add(
          EtherTask(
            id: 'task_3',
            goal: 'Calculate ($profit / $sellingPrice) times 100.',
          ),
        );

        tasks.add(
          EtherTask(
            id: 'task_4',
            goal:
                'Profit is $profit and profit margin is ${margin.toStringAsFixed(2)}%.',
          ),
        );
      } else {
        tasks.add(
          EtherTask(
            id: 'task_1',
            goal: 'Identify the product cost and selling price.',
          ),
        );

        tasks.add(
          EtherTask(id: 'task_2', goal: 'Calculate the expected profit.'),
        );

        tasks.add(
          EtherTask(id: 'task_3', goal: 'Calculate the profit margin.'),
        );
      }
    } else {
      tasks.add(EtherTask(id: 'task_1', goal: input));
    }

    return EtherPlan(goal: input, tasks: tasks);
  }
}
