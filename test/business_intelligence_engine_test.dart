import 'package:flutter_test/flutter_test.dart';

import 'package:ether_os/business/business_research_engine.dart';
import 'package:ether_os/business/intelligence/business_intelligence_engine.dart';

void main() {
  test('business intelligence ranks the strongest opportunity first', () {
    final research = EtherBusinessResearchEngine();
    const intelligence = EtherBusinessIntelligenceEngine();

    final report = intelligence.analyze(research.researchProducts());

    expect(report.insights, isNotEmpty);
    expect(report.bestOpportunity, isNotNull);
    expect(report.bestOpportunity!.product, 'Portable LED Desk Lamp');
    expect(report.bestOpportunity!.opportunityScore, 76);
  });

  test('high opportunity products are classified correctly', () {
    const intelligence = EtherBusinessIntelligenceEngine();

    final report = intelligence.analyze([
      const BusinessResearchResult(
        product: 'Test Product',
        estimatedCost: 10,
        estimatedSellingPrice: 30,
        estimatedProfit: 20,
        estimatedMargin: 66.67,
        demandScore: 90,
        competitionScore: 40,
        opportunityScore: 90,
      ),
    ]);

    expect(report.bestOpportunity!.classification, 'HIGH OPPORTUNITY');
    expect(report.bestOpportunity!.recommendation, contains('Prioritize'));
  });

  test('moderate opportunities are classified correctly', () {
    const intelligence = EtherBusinessIntelligenceEngine();

    final report = intelligence.analyze([
      const BusinessResearchResult(
        product: 'Moderate Product',
        estimatedCost: 10,
        estimatedSellingPrice: 20,
        estimatedProfit: 10,
        estimatedMargin: 50,
        demandScore: 70,
        competitionScore: 60,
        opportunityScore: 65,
      ),
    ]);

    expect(report.bestOpportunity!.classification, 'MODERATE OPPORTUNITY');
  });

  test('low opportunities are classified correctly', () {
    const intelligence = EtherBusinessIntelligenceEngine();

    final report = intelligence.analyze([
      const BusinessResearchResult(
        product: 'Weak Product',
        estimatedCost: 15,
        estimatedSellingPrice: 20,
        estimatedProfit: 5,
        estimatedMargin: 25,
        demandScore: 50,
        competitionScore: 80,
        opportunityScore: 40,
      ),
    ]);

    expect(report.bestOpportunity!.classification, 'LOW OPPORTUNITY');
  });

  test('empty research produces no opportunity', () {
    const intelligence = EtherBusinessIntelligenceEngine();

    final report = intelligence.analyze([]);

    expect(report.insights, isEmpty);
    expect(report.bestOpportunity, isNull);
    expect(report.summary, contains('No suitable opportunity identified.'));
  });

  test('intelligence report contains expected sections', () {
    final research = EtherBusinessResearchEngine();
    const intelligence = EtherBusinessIntelligenceEngine();

    final report = intelligence.analyze(research.researchProducts());

    expect(report.summary, contains('ETHER BUSINESS INTELLIGENCE'));
    expect(report.summary, contains('OPPORTUNITIES ANALYZED'));
    expect(report.summary, contains('TOP OPPORTUNITY'));
    expect(report.summary, contains('Portable LED Desk Lamp'));
  });
}
