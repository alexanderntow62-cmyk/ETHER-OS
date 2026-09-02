import 'ether_business_scorer.dart';
import 'ether_opportunity_engine.dart';
import 'models/ether_business_opportunity.dart';

class EtherZeroCapitalEngine {
  final EtherOpportunityEngine opportunityEngine;
  final EtherBusinessScorer scorer;

  const EtherZeroCapitalEngine({
    this.opportunityEngine = const EtherOpportunityEngine(),
    this.scorer = const EtherBusinessScorer(),
  });

  List<EtherBusinessOpportunity> findBusinesses() {
    final opportunities = opportunityEngine.discover(
      includeGhana: true,
      includeInternational: true,
      zeroCapitalOnly: true,
    );

    return scorer.rank(opportunities);
  }

  EtherBusinessOpportunity? bestBusiness() {
    return scorer.best(findBusinesses());
  }

  bool qualifies(EtherBusinessOpportunity opportunity) {
    return opportunity.zeroCapital &&
        (opportunity.globallyScalable ||
            opportunity.scope == EtherBusinessScope.ghana);
  }
}
