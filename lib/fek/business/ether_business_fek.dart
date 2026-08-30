import '../../business/business_state.dart';
import '../../business/ether_business_autonomy_loop.dart';
import '../../business/ether_business_engine.dart';
import '../../business/ether_business_operator.dart';

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

    final sharedAutonomy = autonomy ?? EtherBusinessAutonomyLoop();

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
    return autonomy.run(goal: goal, state: state ?? operator.state);
  }

  Future<String> runAutonomyText({
    required String goal,
    BusinessState? state,
  }) async {
    final result = await runAutonomy(goal: goal, state: state);

    return result.toString();
  }


}
