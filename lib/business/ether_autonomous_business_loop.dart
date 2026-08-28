import '../agent/ether_plan.dart';
import '../agent/ether_task.dart';
import '../ai/brain/ether_brain.dart';
import '../fek/action/ether_action_fek.dart';
import 'business_permission.dart';
import 'business_planner.dart';

/// Autonomous business execution loop.
///
/// FEK-3 creates the business plan.
/// FEK-2 executes permitted individual steps.
/// Results are collected and fed back into the loop.
///
/// Financial actions are NEVER executed automatically.
class EtherAutonomousBusinessLoop {
  final EtherBusinessPlanner planner;
  final EtherActionFEK action;
  final EtherBrain brain;

  EtherAutonomousBusinessLoop({
    required this.brain,
    EtherBusinessPlanner? planner,
    EtherActionFEK? action,
  }) : planner = planner ?? EtherBusinessPlanner(),
       action = action ?? EtherActionFEK(brain: brain);

  Future<String> run(String goal) async {
    final input = goal.trim();

    if (input.isEmpty) {
      return 'AUTONOMOUS BUSINESS LOOP\nNo business goal provided.';
    }

    final plan = planner.createPlan(input);

    if (plan.steps.isEmpty) {
      return 'AUTONOMOUS BUSINESS LOOP\nNo executable business plan could be created.';
    }

    final output = <String>[
      'AUTONOMOUS BUSINESS LOOP',
      '',
      'Goal: ${plan.goal}',
      '',
      'LOOP STARTED',
    ];

    var executedSteps = 0;

    for (final step in plan.steps) {
      output.add('');
      output.add('${step.id} — ${step.title}');

      // Hard financial boundary.
      if (step.permission == BusinessPermission.financial) {
        output.add('STATUS: WAITING FOR APPROVAL');
        output.add('PERMISSION: FINANCIAL');
        output.add('ACTION: ${step.description}');
        output.add('');
        output.add('AUTONOMOUS LOOP PAUSED');
        output.add(
          'ETHER completed all permitted preparation up to this point.',
        );
        output.add('Financial actions require your approval.');
        output.add('Financial actions performed: 0');
        output.add('Approval bypassed: NO');

        return output.join('\n');
      }

      output.add('STATUS: EXECUTING');

      final task = EtherTask(id: step.id, goal: step.description);

      final executionPlan = EtherPlan(goal: step.description, tasks: [task]);

      try {
        final completedPlan = await action.execute(executionPlan);
        final completedTask = completedPlan.tasks.first;

        if (completedTask.status == EtherTaskStatus.failed) {
          output.add('STATUS: FAILED');
          output.add(
            'RESULT: ${completedTask.result.trim().isEmpty ? 'Unknown execution error.' : completedTask.result.trim()}',
          );
          output.add('');
          output.add('AUTONOMOUS LOOP STOPPED');
          output.add('Reason: execution failure.');

          return output.join('\n');
        }

        output.add('STATUS: COMPLETED');

        if (completedTask.result.trim().isNotEmpty) {
          output.add('RESULT: ${completedTask.result.trim()}');
        }

        executedSteps++;
      } catch (error) {
        output.add('STATUS: FAILED');
        output.add('RESULT: $error');
        output.add('');
        output.add('AUTONOMOUS LOOP STOPPED');
        output.add('Reason: execution exception.');

        return output.join('\n');
      }
    }

    output.add('');
    output.add('LOOP COMPLETE');
    output.add('Completed steps: $executedSteps/${plan.steps.length}');
    output.add('Financial actions performed: 0');
    output.add('Approval bypassed: NO');

    return output.join('\n');
  }
}
