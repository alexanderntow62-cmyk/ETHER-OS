import 'ether_plan.dart';
import 'ether_task.dart';

class EtherPlanner {
  EtherPlan createPlan(String goal) {
    final input = goal.trim();

    if (input.isEmpty) {
      return EtherPlan(goal: input, tasks: []);
    }

    final lower = input.toLowerCase();

    // Business profit/margin requests should remain as one task.
    // This allows CalculatorSkill to process the original request
    // and return Cost, Selling price, Profit, Margin and Markup.
    if (lower.contains('profit') ||
        lower.contains('profitable') ||
        lower.contains('margin') ||
        lower.contains('markup')) {
      return EtherPlan(
        goal: input,
        tasks: [EtherTask(id: 'task_1', goal: input)],
      );
    }

    if (_looksLikeMultipleCalculations(input)) {
      return _createCalculationPlan(input);
    }

    return EtherPlan(
      goal: input,
      tasks: [EtherTask(id: 'task_1', goal: input)],
    );
  }

  bool _looksLikeMultipleCalculations(String input) {
    final normalized = input.toLowerCase();

    final hasMathOperators = RegExp(
      r'[\d\)]\s*[+\-*/×÷]\s*[\d\(]',
    ).hasMatch(normalized);

    final hasMathWords =
        normalized.contains(' plus ') ||
        normalized.contains(' minus ') ||
        normalized.contains(' times ') ||
        normalized.contains(' divided by ') ||
        normalized.contains(' multiplied by ');

    final separators = RegExp(r',|\band\b').allMatches(normalized).length;

    return (hasMathOperators || hasMathWords) && separators > 0;
  }

  EtherPlan _createCalculationPlan(String input) {
    var text = input.trim();

    text = text.replaceAll(' and ', ',');
    text = text.replaceAll(' AND ', ',');

    final parts = text
        .split(',')
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList();

    final tasks = <EtherTask>[];

    for (var i = 0; i < parts.length; i++) {
      tasks.add(EtherTask(id: 'task_${i + 1}', goal: parts[i]));
    }

    return EtherPlan(goal: input, tasks: tasks);
  }
}
