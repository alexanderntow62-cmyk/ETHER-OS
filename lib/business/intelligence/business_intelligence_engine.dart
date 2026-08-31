import '../business_research_engine.dart';

class BusinessIntelligenceInsight {
  final String product;
  final int opportunityScore;
  final String classification;
  final String recommendation;
  final List<String> strengths;
  final List<String> risks;

  const BusinessIntelligenceInsight({
    required this.product,
    required this.opportunityScore,
    required this.classification,
    required this.recommendation,
    required this.strengths,
    required this.risks,
  });

  String get summary {
    return [
      '$product',
      'Opportunity: $opportunityScore/100',
      'Classification: $classification',
      'Recommendation: $recommendation',
      if (strengths.isNotEmpty) 'Strengths: ${strengths.join(', ')}',
      if (risks.isNotEmpty) 'Risks: ${risks.join(', ')}',
    ].join('\n');
  }
}

class EtherBusinessIntelligenceReport {
  final List<BusinessIntelligenceInsight> insights;
  final BusinessIntelligenceInsight? bestOpportunity;

  const EtherBusinessIntelligenceReport({
    required this.insights,
    required this.bestOpportunity,
  });

  String get summary {
    final lines = <String>[
      'ETHER BUSINESS INTELLIGENCE',
      '',
      'OPPORTUNITIES ANALYZED: ${insights.length}',
      '',
    ];

    for (final insight in insights) {
      lines.add(insight.summary);
      lines.add('');
    }

    if (bestOpportunity != null) {
      lines.add('TOP OPPORTUNITY');
      lines.add(bestOpportunity!.product);
      lines.add(
        'Opportunity Score: ${bestOpportunity!.opportunityScore}/100',
      );
      lines.add(
        'Classification: ${bestOpportunity!.classification}',
      );
      lines.add(
        'Recommendation: ${bestOpportunity!.recommendation}',
      );
    } else {
      lines.add('TOP OPPORTUNITY');
      lines.add('No suitable opportunity identified.');
    }

    return lines.join('\n');
  }
}

class EtherBusinessIntelligenceEngine {
  const EtherBusinessIntelligenceEngine();

  EtherBusinessIntelligenceReport analyze(
    List<BusinessResearchResult> products,
  ) {
    final insights = products
        .map(_analyzeProduct)
        .toList()
      ..sort(
        (a, b) => b.opportunityScore.compareTo(a.opportunityScore),
      );

    return EtherBusinessIntelligenceReport(
      insights: insights,
      bestOpportunity: insights.isEmpty ? null : insights.first,
    );
  }

  BusinessIntelligenceReport analyzeResearchEngine(
    EtherBusinessResearchEngine research,
  ) {
    return analyze(research.researchProducts());
  }

  BusinessIntelligenceInsight _analyzeProduct(
    BusinessResearchResult product,
  ) {
    final strengths = <String>[];
    final risks = <String>[];

    if (product.demandScore >= 80) {
      strengths.add('strong demand');
    } else if (product.demandScore >= 70) {
      strengths.add('healthy demand');
    } else {
      risks.add('weaker demand');
    }

    if (product.competitionScore <= 55) {
      strengths.add('manageable competition');
    } else if (product.competitionScore >= 70) {
      risks.add('high competition');
    } else {
      risks.add('moderate competition');
    }

    if (product.estimatedMargin >= 60) {
      strengths.add('strong margin');
    } else if (product.estimatedMargin < 30) {
      risks.add('low margin');
    }

    final classification = _classification(product.opportunityScore);

    final recommendation = switch (classification) {
      'HIGH OPPORTUNITY' =>
        'Prioritize research and prepare a business plan.',
      'MODERATE OPPORTUNITY' =>
        'Continue validation before committing resources.',
      _ =>
        'Do not prioritize until stronger evidence is available.',
    };

    return BusinessIntelligenceInsight(
      product: product.product,
      opportunityScore: product.opportunityScore,
      classification: classification,
      recommendation: recommendation,
      strengths: strengths,
      risks: risks,
    );
  }

  String _classification(int score) {
    if (score >= 75) {
      return 'HIGH OPPORTUNITY';
    }

    if (score >= 60) {
      return 'MODERATE OPPORTUNITY';
    }

    return 'LOW OPPORTUNITY';
  }
}

typedef BusinessIntelligenceReport = EtherBusinessIntelligenceReport;
