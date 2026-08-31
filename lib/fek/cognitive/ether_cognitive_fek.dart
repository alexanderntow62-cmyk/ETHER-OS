import '../../ai/brain/ether_brain.dart';
import '../../agent/ether_plan.dart';
import '../../agent/ether_planner.dart';
import '../ether_fek.dart';

class EtherCognitiveFEK implements EtherFek {
  final EtherBrain brain;
  final EtherPlanner planner;

  EtherCognitiveFEK({EtherBrain? brain, EtherPlanner? planner})
    : brain = brain ?? EtherBrain(),
      planner = planner ?? EtherPlanner();

  @override
  EtherFekType get type => EtherFekType.cognitive;

  @override
  String get name => 'COGNITIVE FEK';

  @override
  bool canHandle(String input) => input.trim().isNotEmpty;

  @override
  Future<String> handle(String input) async {
    final goal = input.trim();

    if (goal.isEmpty) {
      return 'COGNITIVE FEK\nNo goal provided.';
    }

    await brain.initialize();

    final plan = planner.createPlan(goal);

    if (plan.tasks.isEmpty) {
      return 'COGNITIVE FEK\nNo executable plan could be created.';
    }

    return [
      'COGNITIVE FEK',
      '',
      'GOAL: $goal',
      'TASKS: ${plan.tasks.length}',
      '',
      ...plan.tasks.map((task) => '${task.id} — ${task.goal}'),
    ].join('\n');
  }

  Future<EtherPlan> createPlan(String input) async {
    await brain.initialize();
    return planner.createPlan(input.trim());
  }
}

/// Backwards-compatible class-name alias.
typedef EtherCognitiveFek = EtherCognitiveFEK;
