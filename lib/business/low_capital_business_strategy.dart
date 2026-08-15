enum CapitalRequirement { zero, low, medium, high }

enum BusinessOpportunityStatus { suitable, reviewRequired, reject }

class BusinessOpportunity {
  final String name;
  final CapitalRequirement capital;
  final bool requiresInventory;
  final bool directToCustomer;
  final bool requiresPaidAdvertising;
  final bool requiresSubscription;
  final double estimatedUpfrontCost;

  const BusinessOpportunity({
    required this.name,
    required this.capital,
    required this.requiresInventory,
    required this.directToCustomer,
    required this.requiresPaidAdvertising,
    required this.requiresSubscription,
    required this.estimatedUpfrontCost,
  });
}

class BusinessOpportunityEvaluation {
  final BusinessOpportunity opportunity;
  final BusinessOpportunityStatus status;
  final int score;
  final List<String> reasons;

  const BusinessOpportunityEvaluation({
    required this.opportunity,
    required this.status,
    required this.score,
    required this.reasons,
  });

  String get summary {
    return [
      opportunity.name,
      'Status: ${status.name.toUpperCase()}',
      'Capital: ${opportunity.capital.name.toUpperCase()}',
      'Score: $score/100',
      'Estimated upfront cost: '
          '\$${opportunity.estimatedUpfrontCost.toStringAsFixed(2)}',
      ...reasons.map((reason) => '- $reason'),
    ].join('\n');
  }
}

class EtherLowCapitalBusinessStrategy {
  BusinessOpportunityEvaluation evaluate(BusinessOpportunity opportunity) {
    var score = 100;
    final reasons = <String>[];

    if (opportunity.requiresInventory) {
      score -= 30;
      reasons.add('Requires inventory.');
    } else {
      reasons.add('No inventory purchase required.');
    }

    if (opportunity.directToCustomer) {
      score += 5;
      reasons.add('Can support direct-to-customer fulfillment.');
    }

    if (opportunity.requiresPaidAdvertising) {
      score -= 20;
      reasons.add('Paid advertising may require upfront capital.');
    } else {
      reasons.add('Can begin without paid advertising.');
    }

    if (opportunity.requiresSubscription) {
      score -= 15;
      reasons.add('Requires a paid subscription.');
    } else {
      reasons.add('No paid subscription required at the planning stage.');
    }

    if (opportunity.estimatedUpfrontCost > 0) {
      score -= (opportunity.estimatedUpfrontCost * 2).round();
    }

    score = score.clamp(0, 100);

    final BusinessOpportunityStatus status;

    if (opportunity.estimatedUpfrontCost == 0 &&
        !opportunity.requiresInventory &&
        !opportunity.requiresPaidAdvertising &&
        !opportunity.requiresSubscription) {
      status = BusinessOpportunityStatus.suitable;
    } else if (opportunity.estimatedUpfrontCost <= 25) {
      status = BusinessOpportunityStatus.reviewRequired;
    } else {
      status = BusinessOpportunityStatus.reject;
    }

    return BusinessOpportunityEvaluation(
      opportunity: opportunity,
      status: status,
      score: score,
      reasons: reasons,
    );
  }

  List<BusinessOpportunityEvaluation> evaluateAll(
    List<BusinessOpportunity> opportunities,
  ) {
    final results = opportunities.map(evaluate).toList();

    results.sort((a, b) => b.score.compareTo(a.score));

    return results;
  }

  String createReport(List<BusinessOpportunity> opportunities) {
    final evaluations = evaluateAll(opportunities);

    if (evaluations.isEmpty) {
      return 'LOW-CAPITAL BUSINESS STRATEGY\n\n'
          'No opportunities found.';
    }

    final lines = <String>[
      'LOW-CAPITAL BUSINESS STRATEGY',
      '',
      'Evaluated opportunities:',
      '',
    ];

    for (final evaluation in evaluations) {
      lines.add(evaluation.summary);
      lines.add('');
    }

    final suitable = evaluations
        .where(
          (evaluation) =>
              evaluation.status == BusinessOpportunityStatus.suitable,
        )
        .toList();

    lines.add('RECOMMENDATION');

    if (suitable.isEmpty) {
      lines.add('No zero-capital opportunity is currently suitable.');
      lines.add('ETHER will not spend money automatically.');
    } else {
      lines.add(
        'Highest-priority low-capital opportunity: '
        '${suitable.first.opportunity.name}',
      );
    }

    lines.add('');
    lines.add('FINANCIAL SAFETY');
    lines.add(
      'Purchases, subscriptions, advertising payments, '
      'inventory purchases, and financial commitments require approval.',
    );

    return lines.join('\n');
  }
}
