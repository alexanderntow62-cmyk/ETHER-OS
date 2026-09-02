enum EtherBusinessCapitalLevel { zero, low, moderate, high }

enum EtherBusinessScope { ghana, africa, international, global }

class EtherBusinessOpportunity {
  final String id;
  final String name;
  final String description;
  final EtherBusinessCapitalLevel capitalLevel;
  final EtherBusinessScope scope;
  final double demandScore;
  final double competitionScore;
  final double scalabilityScore;
  final double automationScore;
  final double profitPotentialScore;
  final bool requiresFinancialApproval;

  const EtherBusinessOpportunity({
    required this.id,
    required this.name,
    required this.description,
    required this.capitalLevel,
    required this.scope,
    required this.demandScore,
    required this.competitionScore,
    required this.scalabilityScore,
    required this.automationScore,
    required this.profitPotentialScore,
    this.requiresFinancialApproval = true,
  });

  double get overallScore {
    return (demandScore +
            competitionScore +
            scalabilityScore +
            automationScore +
            profitPotentialScore) /
        5;
  }

  bool get zeroCapital => capitalLevel == EtherBusinessCapitalLevel.zero;

  bool get globallyScalable =>
      scope == EtherBusinessScope.global ||
      scope == EtherBusinessScope.international;
}
