import 'business_decision_engine.dart';
import 'business_state.dart';
import 'ether_business_operator.dart';

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

  const BusinessLoopResult({
    required this.stage,
    required this.output,
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
  final EtherBusinessOperator operator;
  final EtherBusinessDecisionEngine decisionEngine;

  EtherBusinessAutonomyLoop({
    EtherBusinessOperator? operator,
    EtherBusinessDecisionEngine? decisionEngine,
  })  : operator = operator ?? EtherBusinessOperator(),
        decisionEngine =
            decisionEngine ?? EtherBusinessDecisionEngine();

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

    // OBSERVE
    final observation = _observe(input, state);

    // DECIDE
    final decision = decisionEngine.decide(
      goal: input,
      state: state,
    );

    // FINANCIAL ACTIONS STOP HERE.
    if (decision.requiresApproval) {
      return BusinessLoopResult(
        stage: BusinessLoopStage.waitingApproval,
        output: [
          'OBSERVE',
          observation,
          '',
          'DECISION',
          decision.action,
          '',
          'APPROVAL REQUIRED',
          decision.reason,
          '',
          'ETHER will not perform the financial action automatically.',
        ].join('\n'),
      );
    }

    // PLAN + EXECUTE
    final execution = await operator.start(input);

    // MEASURE
    final measurement = _measure(execution);

    // LEARN
    final learning = _learn(
      input,
      decision,
      measurement,
    );

    return BusinessLoopResult(
      stage: BusinessLoopStage.completed,
      output: [
        'OBSERVE',
        observation,
        '',
        'DECIDE',
        'Type: ${decision.type.name}',
        'Action: ${decision.action}',
        '',
        'PLAN + EXECUTE',
        execution,
        '',
        'MEASURE',
        measurement,
        '',
        'LEARN',
        learning,
      ].join('\n'),
    );
  }

  String _observe(String goal, BusinessState state) {
    final pending = state.pendingActions.length;

    return [
      'Goal: $goal',
      'Pending actions: $pending',
      'Business state observed.',
    ].join('\n');
  }

  String _measure(String execution) {
    if (execution.trim().isEmpty) {
      return 'No measurable execution result was produced.';
    }

    if (execution.contains('APPROVAL REQUIRED')) {
      return 'Execution stopped at the approval boundary.';
    }

    return 'Business action completed and produced an execution result.';
  }

  String _learn(
    String goal,
    BusinessDecision decision,
    String measurement,
  ) {
    return [
      'Recorded business cycle:',
      'Goal: $goal',
      'Decision: ${decision.type.name}',
      'Measurement: $measurement',
    ].join('\n');
  }
}
