import 'models/ether_business_opportunity.dart';

class EtherBusinessScorer {
  const EtherBusinessScorer();

  double score(EtherBusinessOpportunity opportunity) {
    var score = opportunity.overallScore;

    // Zero-capital opportunities are preferred because ETHER
    // must be able to begin autonomously without spending
    // the user's money.
    if (opportunity.zeroCapital) {
      score += 1.0;
    }

    // Global scalability is valuable because the objective is
    // to build businesses that can eventually serve markets
    // beyond Ghana.
    if (opportunity.globallyScalable) {
      score += 0.5;
    }

    // Financial approval is not a reason to reject a business.
    // It simply means financial actions must stop at the
    // approval boundary.
    return score;
  }

  List<EtherBusinessOpportunity> rank(
    List<EtherBusinessOpportunity> opportunities,
  ) {
    final ranked = List<EtherBusinessOpportunity>.from(opportunities);

    ranked.sort((a, b) => score(b).compareTo(score(a)));

    return ranked;
  }

  EtherBusinessOpportunity? best(List<EtherBusinessOpportunity> opportunities) {
    final ranked = rank(opportunities);

    return ranked.isEmpty ? null : ranked.first;
  }
}
