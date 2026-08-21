import 'business_market_profile.dart';

class BusinessOpportunityCandidate {
  final String name;
  final String description;
  final BusinessMarketProfile profile;
  final int score;
  final List<String> reasons;

  const BusinessOpportunityCandidate({
    required this.name,
    required this.description,
    required this.profile,
    required this.score,
    required this.reasons,
  });

  String get summary {
    return [
      name,
      description,
      profile.summary,
      'OPPORTUNITY SCORE: $score/100',
      ...reasons.map((reason) => '- $reason'),
    ].join('\n');
  }
}

class EtherBusinessOpportunityEngine {
  List<BusinessOpportunityCandidate> generate({
    required BusinessMarket market,
    required CapitalRequirement capital,
  }) {
    final candidates = <BusinessOpportunityCandidate>[
      BusinessOpportunityCandidate(
        name: 'Digital Business Services',
        description:
            'Provide digital services to Ghanaian and international customers.',
        profile: BusinessMarketProfile(
          market: market,
          businessType: BusinessType.service,
          customerType: CustomerType.both,
          capitalRequirement: CapitalRequirement.zero,
        ),
        score: 90,
        reasons: const [
          'Can be delivered remotely.',
          'Can target Ghanaian customers.',
          'Can target international customers.',
          'Does not require physical inventory.',
          'ETHER can prepare much of the business workflow autonomously.',
        ],
      ),
      BusinessOpportunityCandidate(
        name: 'Organic Affiliate Business',
        description:
            'Build content-driven affiliate opportunities without purchasing inventory.',
        profile: BusinessMarketProfile(
          market: market,
          businessType: BusinessType.digital,
          customerType: CustomerType.b2c,
          capitalRequirement: CapitalRequirement.zero,
        ),
        score: 84,
        reasons: const [
          'No inventory required.',
          'Can target international audiences.',
          'Can target Ghanaian audiences.',
          'Organic marketing can begin without paid advertising.',
        ],
      ),
      BusinessOpportunityCandidate(
        name: 'Print-on-Demand Business',
        description:
            'Sell custom products fulfilled by a third-party provider.',
        profile: BusinessMarketProfile(
          market: market,
          businessType: BusinessType.product,
          customerType: CustomerType.b2c,
          capitalRequirement: CapitalRequirement.low,
        ),
        score: 76,
        reasons: const [
          'No physical inventory needs to be held.',
          'Can target international customers.',
          'Can target Ghanaian customers.',
          'Some platform or transaction costs may require approval.',
        ],
      ),
      BusinessOpportunityCandidate(
        name: 'Dropshipping Business',
        description:
            'Sell products while fulfillment is handled by a supplier.',
        profile: BusinessMarketProfile(
          market: market,
          businessType: BusinessType.product,
          customerType: CustomerType.b2c,
          capitalRequirement: CapitalRequirement.low,
        ),
        score: 72,
        reasons: const [
          'No inventory storage is required.',
          'Can target Ghanaian and international customers.',
          'Store, supplier, advertising, and subscription costs may require approval.',
        ],
      ),
    ];

    final filtered = candidates.where((candidate) {
      return candidate.profile.capitalRequirement.index <= capital.index;
    }).toList();

    filtered.sort((a, b) => b.score.compareTo(a.score));
    return filtered;
  }

  String createReport({
    BusinessMarket market = BusinessMarket.both,
    CapitalRequirement capital = CapitalRequirement.zero,
  }) {
    final opportunities = generate(
      market: market,
      capital: capital,
    );

    if (opportunities.isEmpty) {
      return [
        'ETHER BUSINESS OPPORTUNITY ENGINE',
        '',
        'No opportunity satisfies the requested capital limit.',
        '',
        'FINANCIAL BOUNDARY',
        'ETHER will not spend personal money automatically.',
      ].join('\n');
    }

    return [
      'ETHER BUSINESS OPPORTUNITY ENGINE',
      '',
      'SEARCH TARGET',
      'Market: ${market.name.toUpperCase()}',
      'Maximum capital: ${capital.name.toUpperCase()}',
      '',
      'OPPORTUNITIES',
      '',
      ...opportunities.map((opportunity) => opportunity.summary),
      '',
      'AUTONOMOUS POLICY',
      'ETHER may research, plan, prepare, analyze, and execute non-financial business work autonomously.',
      '',
      'FINANCIAL BOUNDARY',
      'Purchases, payments, subscriptions, advertising spend, inventory purchases, and financial commitments require explicit user approval.',
    ].join('\n');
  }
}
