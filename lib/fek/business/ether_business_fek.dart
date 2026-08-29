import '../../agent/ether_plan.dart';
import '../../agent/ether_task.dart';
import '../../business/business_decision_engine.dart';
import '../../business/business_state.dart';
import '../../business/ether_business_autonomy_loop.dart';
import '../../business/ether_business_engine.dart';
import '../../business/ether_business_operator.dart';
import '../action/ether_action_fek.dart';

/// FEK-3: Business & Autonomous Operations.
///
/// FEK-3 owns:
/// - observation
/// - decision-making
/// - business planning
/// - measurement
/// - learning
/// - approval boundaries
///
/// FEK-2 owns actual permitted execution.
class EtherBusinessFEK {
  final EtherBusinessEngine business;
  final EtherBusinessOperator operator;
  final EtherBusinessAutonomyLoop autonomy;

  factory EtherBusinessFEK({
    EtherBusinessEngine? business,
    EtherBusinessOperator? operator,
    EtherBusinessAutonomyLoop? autonomy,
  }) {
    final sharedBusiness =
        business ?? operator?.business ?? EtherBusinessEngine();

    final sharedOperator =
        operator ?? EtherBusinessOperator(business: sharedBusiness);

    final sharedAutonomy =
        autonomy ?? EtherBusinessAutonomyLoop();

    return EtherBusinessFEK._(
      business: sharedBusiness,
      operator: sharedOperator,
      autonomy: sharedAutonomy,
    );
  }

  EtherBusinessFEK._({
    required this.business,
    required this.operator,
    required this.autonomy,
  });

  Future<String> start(String request) async {
    return operator.start(request);
  }

  Future<BusinessLoopResult> runAutonomy({
    required String goal,
    BusinessState? state,
  }) async {
    return autonomy.run(
      goal: goal,
      state: state ?? operator.state,
    );
  }

  Future<String> runAutonomyText({
    required String goal,
    BusinessState? state,
  }) async {
    final result = await runAutonomy(
      goal: goal,
      state: state,
    );

    return result.toString();
  }

  /// FEK-3 decides what should happen.
  ///
  /// FEK-2 performs only permitted execution.
  ///
  /// Financial actions are stopped before FEK-2 receives them.
  Future<String> executeWithActionFEK({
    required String goal,
    required EtherActionFEK actionFEK,
    BusinessState? state,
  }) async {
    final businessState = state ?? operator.state;

    final decision = EtherBusinessDecisionEngine().decide(
      goal: goal,
      state: businessState,
    );

    if (decision.requiresApproval) {
      return [
        'ETHER BUSINESS FEK',
        '',
        'APPROVAL REQUIRED',
        decision.reason,
        '',
        'ETHER will not execute the financial action automatically.',
      ].join('\n');
    }

    final plan = EtherPlan(
      goal: goal,
      tasks: [
        EtherTask(
          id: 'business_fek_action',
          goal: goal,
        ),
      ],
    );

    final result = await actionFEK.execute(plan);

    final outputs = result.tasks
        .map((task) => task.result.trim())
        .where((value) => value.isNotEmpty)
        .toList();

    return [
      'ETHER BUSINESS FEK',
      '',
      'FEK-3 DECISION',
      decision.toString(),
      '',
      'FEK-2 EXECUTION',
      outputs.isEmpty
          ? 'FEK-2 completed the permitted execution stage.'
          : outputs.join('\n\n'),
    ].join('\n');
  }

}
