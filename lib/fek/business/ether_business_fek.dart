import '../../business/ether_business_engine.dart';
import '../../business/ether_business_operator.dart';

/// FEK-3: Business & Autonomous Operations
///
/// Handles ETHER's business-operation layer:
/// - business workflows
/// - business operations
/// - autonomous business tasks
/// - long-running business processes
///
/// Financial actions remain protected by the business permission boundary.
class EtherBusinessFEK {
  final EtherBusinessEngine business;
  final EtherBusinessOperator operator;

  factory EtherBusinessFEK({
    EtherBusinessEngine? business,
    EtherBusinessOperator? operator,
  }) {
    final sharedBusiness = business ?? EtherBusinessEngine();

    return EtherBusinessFEK._(
      business: sharedBusiness,
      operator: operator ??
          EtherBusinessOperator(
            business: sharedBusiness,
          ),
    );
  }

  EtherBusinessFEK._({
    required this.business,
    required this.operator,
  });

  Future<String> start(String request) async {
    return operator.start(request);
  }
}
