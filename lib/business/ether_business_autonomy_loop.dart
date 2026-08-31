import '../agent/ether_plan.dart';
import '../agent/ether_task.dart';
import 'business_decision_engine.dart';
import 'business_permission.dart';
import 'business_planner.dart';
import 'business_state.dart';

enum BusinessLoopStage {
  observe,
  decide,
  plan,
  execute,
  measure,
  learn,
  waitingApproval,
  completed,
  failed,
}

class BusinessLoopResult {
  final BusinessLoopStage stage;
  final String output;
  final EtherPlan? plan;

  const BusinessLoopResult({
    required this.stage,
    required this.output,
    this.plan,
  });

  @override
  String toString() {
    return [
      'ETHER BUSINESS AUTONOMY LOOP',
      '',
      'STAGE: ${stage.name.toUpperCase()}',
      '',
      output,
    ].join('\n');
  }
}

class EtherBusinessAutonomyLoop {
  final EtherBusinessDecisionEngine decisionEngine;
  final EtherBusinessPlanner planner;

  EtherBusinessAutonomyLoop({
    EtherBusinessDecisionEngine? decisionEngine,
    EtherBusinessPlanner? planner,
  }) : decisionEngine = decisionEngine ?? EtherBusinessDecisionEngine(),
       planner = planner ?? EtherBusinessPlanner();

  Future<BusinessLoopResult> run({
    required String goal,
    required BusinessState state,
  }) async {
    final input = goal.trim();

    if (input.isEmpty) {
      return const BusinessLoopResult(
        stage: BusinessLoopStage.failed,
        output: 'No business goal was provided.',
      );
    }

    // ============================================================
    // FEK-3: OBSERVE
    // ============================================================

    final observation = observe(input, state);

    // ============================================================
    // FEK-3: DECIDE
    // ============================================================

    final decision = decisionEngine.decide(goal: input, state: state);

    // ============================================================
    // FINANCIAL SAFETY BOUNDARY
    // ============================================================

    if (decision.requiresApproval) {
      return BusinessLoopResult(
        stage: BusinessLoopStage.waitingApproval,
        output: [
          'OBSERVE',
          observation,
          '',
          'DECIDE',
          'Type: ${decision.type.name}',
          'Action: ${decision.action}',
          '',
          'STOPPED AT FINANCIAL BOUNDARY',
          '',
          'APPROVAL REQUIRED',
          decision.reason,
          '',
          'ETHER will not perform the financial action automatically.',
          '',
          'No purchases, payments, subscriptions, or financial commitments were made.',
        ].join('\n'),
      );
    }

    // ============================================================
    // FEK-3: PLAN
    // ============================================================

    // Calculator requests are informational. FEK-3 creates the
    // permitted calculator task for FEK-2, but does not expose
    // its internal planning workflow to the user.
    if (decision.type == BusinessDecisionType.calculator) {
      final plan = EtherPlan(
        goal: input,
        tasks: [
          EtherTask(
            id: 'calculator_1',
            goal: input,
            type: EtherTaskType.calculator,
          ),
        ],
      );

      state.addGoal(input);

      return BusinessLoopResult(
        stage: BusinessLoopStage.plan,
        plan: plan,
        output: '',
      );
    }

    final businessPlan = planner.createPlan(input);

    if (businessPlan.steps.isEmpty) {
      return BusinessLoopResult(
        stage: BusinessLoopStage.failed,
        output: [
          'OBSERVE',
          observation,
          '',
          'DECIDE',
          'Type: ${decision.type.name}',
          'Action: ${decision.action}',
          '',
          'PLAN',
          'FEK-3 could not produce a business plan.',
        ].join('\n'),
      );
    }

    // ============================================================
    // FEK-3 → FEK-2
    // ============================================================

    final tasks = <EtherTask>[];

    for (final step in businessPlan.steps) {
      if (step.permission == BusinessPermission.financial) {
        continue;
      }

      tasks.add(
        EtherTask(
          id: step.id,
          goal: '${step.title}: ${step.description}',
          type: _taskTypeForStep(step),
        ),
      );
    }

    if (tasks.isEmpty) {
      return BusinessLoopResult(
        stage: BusinessLoopStage.waitingApproval,
        output: [
          'OBSERVE',
          observation,
          '',
          'DECIDE',
          'Type: ${decision.type.name}',
          'Action: ${decision.action}',
          '',
          'PLAN',
          'Business plan contains only restricted financial actions.',
          '',
          'STOPPED AT FINANCIAL BOUNDARY',
          'User approval is required before financial actions can proceed.',
        ].join('\n'),
      );
    }

    final plan = EtherPlan(goal: input, tasks: tasks);

    state.addGoal(input);
    state.addPendingAction('Review results of business cycle: $input');

    // ============================================================
    // FEK-3 → FEK-2 PLAN HANDOFF BOUNDARY
    // ============================================================
    // FEK-3 owns OBSERVE → DECIDE → PLAN.
    // FEK-3 does NOT execute the plan.
    //
    // The coordinator hands this exact plan to FEK-2.
    // FEK-3 must return the plan at this boundary.

    return BusinessLoopResult(
      stage: BusinessLoopStage.plan,
      plan: plan,
      output: [
        'OBSERVE',
        observation,
        '',
        'DECIDE',
        'Type: ${decision.type.name}',
        'Action: ${decision.action}',
        '',
        'PLAN',
        'FEK-3 created the authoritative business plan.',
        'Business plan steps: ${businessPlan.steps.length}',
        'Executable FEK-2 tasks: ${tasks.length}',
        'FEK-3 does not execute business tasks.',
        'FEK-3 → FEK-2',
        'FEK-2 receives the exact executable plan.',
      ].join('\n'),
    );
  }

  EtherTaskType _taskTypeForStep(BusinessPlanStep step) {
    final text = '${step.title} ${step.description}'.toLowerCase();

    if (_containsAny(text, ['research', 'market', 'competitor', 'demand'])) {
      return EtherTaskType.research;
    }

    if (_containsAny(text, [
      'product',
      'supplier',
      'inventory',
      'pricing',
      'margin',
    ])) {
      return EtherTaskType.product;
    }

    if (_containsAny(text, [
      'marketing',
      'promotion',
      'audience',
      'advertising',
      'content',
    ])) {
      return EtherTaskType.marketing;
    }

    if (_containsAny(text, ['customer', 'sales', 'support', 'client'])) {
      return EtherTaskType.customer;
    }

    return EtherTaskType.general;
  }

  bool _containsAny(String input, List<String> terms) {
    return terms.any(input.contains);
  }

  String observe(String goal, BusinessState state) {
    return [
      'Goal: $goal',
      'Pending actions: ${state.pendingActions.length}',
      'Products: ${state.products.length}',
      'Customers: ${state.customers.length}',
      'Suppliers: ${state.suppliers.length}',
      'Revenue: ${state.revenue}',
      'Expenses: ${state.expenses}',
      'Profit: ${state.profit}',
      'Business state observed.',
    ].join('\n');
  }

  String measure(EtherPlan plan) {
    if (plan.tasks.isEmpty) {
      return 'No tasks were executed.';
    }

    final failed = plan.tasks
        .where((task) => task.status == EtherTaskStatus.failed)
        .length;

    final completed = plan.tasks
        .where((task) => task.status == EtherTaskStatus.completed)
        .length;

    return [
      'Tasks: ${plan.tasks.length}',
      'Completed: $completed',
      'Failed: $failed',
      'Plan complete: ${plan.isComplete}',
    ].join('\n');
  }

  String learn({
    required String goal,
    required BusinessDecision decision,
    required String measurement,
    required BusinessState state,
  }) {
    final reviewAction = 'Review results of business cycle: $goal';

    state.addPendingAction(reviewAction);

    return [
      'Business cycle learned.',
      'Goal: $goal',
      'Decision: ${decision.type.name}',
      'Measurement: $measurement',
      'Pending action created: $reviewAction',
    ].join('\n');
  }
}
