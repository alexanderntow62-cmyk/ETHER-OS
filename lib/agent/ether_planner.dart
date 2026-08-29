import 'ether_plan.dart';
import 'ether_task.dart';

class EtherPlanner {
  EtherPlan createPlan(String goal) {
    final input = goal.trim();

    if (input.isEmpty) {
      return EtherPlan(goal: input, tasks: []);
    }

    final lower = input.toLowerCase();

    // ------------------------------------------------------------
    // FINANCE
    // ------------------------------------------------------------
    if (_containsAny(lower, [
      'pay',
      'payment',
      'purchase',
      'buy',
      'subscription',
      'advertising budget',
      'spend money',
      'spend',
      'withdraw',
      'charge',
      'order',
    ])) {
      return EtherPlan(
        goal: input,
        tasks: [
          EtherTask(id: 'task_1', goal: input, type: EtherTaskType.finance),
        ],
      );
    }

    // ------------------------------------------------------------
    // CALCULATOR / PROFIT
    // ------------------------------------------------------------
    if (_containsAny(lower, [
      'calculate',
      'calculator',
      'profit',
      'profitable',
      'margin',
    ])) {
      final numbers = RegExp(r'\d+(?:\.\d+)?')
          .allMatches(input)
          .map((match) => double.parse(match.group(0)!))
          .toList();

      if ((lower.contains('profit') ||
              lower.contains('profitable') ||
              lower.contains('margin')) &&
          numbers.length >= 2) {
        final cost = numbers[0];
        final sellingPrice = numbers[1];
        final profit = sellingPrice - cost;
        final margin = sellingPrice == 0 ? 0 : (profit / sellingPrice) * 100;

        return EtherPlan(
          goal: input,
          tasks: [
            EtherTask(
              id: 'task_1',
              goal: 'Product cost is $cost and selling price is $sellingPrice.',
              type: EtherTaskType.calculator,
            ),
            EtherTask(
              id: 'task_2',
              goal: 'Calculate $sellingPrice minus $cost.',
              type: EtherTaskType.calculator,
            ),
            EtherTask(
              id: 'task_3',
              goal: 'Calculate ($profit / $sellingPrice) times 100.',
              type: EtherTaskType.calculator,
            ),
            EtherTask(
              id: 'task_4',
              goal:
                  'Profit is $profit and profit margin is ${margin.toStringAsFixed(2)}%.',
              type: EtherTaskType.calculator,
            ),
          ],
        );
      }

      return EtherPlan(
        goal: input,
        tasks: [
          EtherTask(id: 'task_1', goal: input, type: EtherTaskType.calculator),
        ],
      );
    }

    // ------------------------------------------------------------
    // RESEARCH
    // ------------------------------------------------------------
    if (_containsAny(lower, [
      'research',
      'market research',
      'competitor',
      'competition',
      'find opportunities',
      'analyze market',
    ])) {
      return EtherPlan(
        goal: input,
        tasks: [
          EtherTask(id: 'task_1', goal: input, type: EtherTaskType.research),
        ],
      );
    }

    // ------------------------------------------------------------
    // PRODUCT
    // ------------------------------------------------------------
    if (_containsAny(lower, [
      'dropshipping',
      'product selection',
      'select products',
      'evaluate products',
      'supplier',
      'inventory',
      'online store',
      'ecommerce',
      'e-commerce',
    ])) {
      return EtherPlan(
        goal: input,
        tasks: [
          EtherTask(id: 'task_1', goal: input, type: EtherTaskType.product),
        ],
      );
    }

    // ------------------------------------------------------------
    // MARKETING
    // ------------------------------------------------------------
    if (_containsAny(lower, [
      'marketing',
      'promotion',
      'promote',
      'content',
      'youtube',
      'social media',
      'advertising',
      'campaign',
    ])) {
      return EtherPlan(
        goal: input,
        tasks: [
          EtherTask(id: 'task_1', goal: input, type: EtherTaskType.marketing),
        ],
      );
    }

    // ------------------------------------------------------------
    // CUSTOMER
    // ------------------------------------------------------------
    if (_containsAny(lower, [
      'customer',
      'customers',
      'sales',
      'sell',
      'support',
      'client',
      'clients',
    ])) {
      return EtherPlan(
        goal: input,
        tasks: [
          EtherTask(id: 'task_1', goal: input, type: EtherTaskType.customer),
        ],
      );
    }

    // ------------------------------------------------------------
    // GENERAL
    // ------------------------------------------------------------
    return EtherPlan(
      goal: input,
      tasks: [
        EtherTask(id: 'task_1', goal: input, type: EtherTaskType.general),
      ],
    );
  }

  bool _containsAny(String input, List<String> terms) {
    return terms.any(input.contains);
  }
}
