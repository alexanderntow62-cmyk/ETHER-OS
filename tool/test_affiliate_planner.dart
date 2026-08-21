import '../lib/business/business_planner.dart';

void main() {
  final planner = EtherBusinessPlanner();

  final plan = planner.createPlan(
    'Start an affiliate marketing business with no money',
  );

  print('GOAL: ${plan.goal}');
  print('STEPS: ${plan.steps.length}');

  for (final step in plan.steps) {
    print('${step.id} | ${step.title} | ${step.permission.name}');
  }
}
