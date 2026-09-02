import 'ether_zero_capital_engine.dart';
import 'models/ether_business_opportunity.dart';

class EtherCreatedBusiness {
  final EtherBusinessOpportunity opportunity;
  final String mission;
  final List<String> objectives;

  const EtherCreatedBusiness({
    required this.opportunity,
    required this.mission,
    required this.objectives,
  });
}

class EtherBusinessCreator {
  final EtherZeroCapitalEngine zeroCapitalEngine;

  const EtherBusinessCreator({
    this.zeroCapitalEngine = const EtherZeroCapitalEngine(),
  });

  EtherCreatedBusiness? createBestBusiness() {
    final opportunity = zeroCapitalEngine.bestBusiness();

    if (opportunity == null) {
      return null;
    }

    return createFromOpportunity(opportunity);
  }

  EtherCreatedBusiness createFromOpportunity(
    EtherBusinessOpportunity opportunity,
  ) {
    return EtherCreatedBusiness(
      opportunity: opportunity,
      mission:
          'Build, validate, operate, measure, and scale ${opportunity.name} '
          'while minimizing upfront capital and keeping financial commitments '
          'behind user approval.',
      objectives: [
        'Validate demand.',
        'Define the target market.',
        'Create the initial offer.',
        'Establish a repeatable acquisition process.',
        'Deliver value to customers.',
        'Measure business performance.',
        'Improve the business using measured results.',
        'Scale successful operations internationally.',
      ],
    );
  }
}
