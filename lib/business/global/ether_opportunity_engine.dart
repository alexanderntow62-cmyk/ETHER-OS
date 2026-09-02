import 'models/ether_business_opportunity.dart';

class EtherOpportunityEngine {
  const EtherOpportunityEngine();

  List<EtherBusinessOpportunity> discover({
    bool includeGhana = true,
    bool includeInternational = true,
    bool zeroCapitalOnly = true,
  }) {
    final opportunities = <EtherBusinessOpportunity>[
      const EtherBusinessOpportunity(
        id: 'content-repurposing',
        name: 'Faceless Content Repurposing',
        description:
            'Create original short-form content from legally usable source material, '
            'adding original editing, narration, commentary, captions, or other '
            'transformative elements.',
        capitalLevel: EtherBusinessCapitalLevel.zero,
        scope: EtherBusinessScope.global,
        demandScore: 8.0,
        competitionScore: 6.0,
        scalabilityScore: 9.0,
        automationScore: 9.0,
        profitPotentialScore: 8.0,
      ),
      const EtherBusinessOpportunity(
        id: 'digital-services',
        name: 'AI-Assisted Digital Services',
        description:
            'Provide research, writing, design, automation, and other digital '
            'services using ETHER-assisted workflows.',
        capitalLevel: EtherBusinessCapitalLevel.zero,
        scope: EtherBusinessScope.global,
        demandScore: 8.0,
        competitionScore: 6.0,
        scalabilityScore: 7.0,
        automationScore: 8.0,
        profitPotentialScore: 8.0,
      ),
      const EtherBusinessOpportunity(
        id: 'affiliate-content',
        name: 'Affiliate Content Business',
        description:
            'Build useful content around products or services and earn commissions '
            'through legitimate affiliate programs.',
        capitalLevel: EtherBusinessCapitalLevel.zero,
        scope: EtherBusinessScope.global,
        demandScore: 8.0,
        competitionScore: 6.0,
        scalabilityScore: 9.0,
        automationScore: 8.0,
        profitPotentialScore: 8.0,
      ),
      const EtherBusinessOpportunity(
        id: 'ghana-digital-services',
        name: 'Ghana Digital Services',
        description:
            'Provide digital services to Ghanaian businesses while maintaining '
            'the ability to serve international clients.',
        capitalLevel: EtherBusinessCapitalLevel.zero,
        scope: EtherBusinessScope.ghana,
        demandScore: 8.0,
        competitionScore: 7.0,
        scalabilityScore: 7.0,
        automationScore: 8.0,
        profitPotentialScore: 7.0,
      ),
    ];

    return opportunities.where((opportunity) {
      if (zeroCapitalOnly && !opportunity.zeroCapital) {
        return false;
      }

      if (!includeGhana && opportunity.scope == EtherBusinessScope.ghana) {
        return false;
      }

      if (!includeInternational &&
          (opportunity.scope == EtherBusinessScope.international ||
              opportunity.scope == EtherBusinessScope.global)) {
        return false;
      }

      return true;
    }).toList();
  }

  List<EtherBusinessOpportunity> rank(
    List<EtherBusinessOpportunity> opportunities,
  ) {
    final ranked = List<EtherBusinessOpportunity>.from(opportunities);

    ranked.sort((a, b) => b.overallScore.compareTo(a.overallScore));

    return ranked;
  }

  EtherBusinessOpportunity? best({
    bool includeGhana = true,
    bool includeInternational = true,
    bool zeroCapitalOnly = true,
  }) {
    final candidates = discover(
      includeGhana: includeGhana,
      includeInternational: includeInternational,
      zeroCapitalOnly: zeroCapitalOnly,
    );

    final ranked = rank(candidates);

    return ranked.isEmpty ? null : ranked.first;
  }
}
