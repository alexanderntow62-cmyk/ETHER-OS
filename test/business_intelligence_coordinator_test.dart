import 'package:flutter_test/flutter_test.dart';

import 'package:ether_os/business/business_decision_engine.dart';
import 'package:ether_os/business/business_state.dart';
import 'package:ether_os/business/intelligence/business_intelligence_coordinator.dart';

void main() {
  test('coordinator produces intelligence from business research', () {
    final coordinator = EtherBusinessIntelligenceCoordinator();

    final report = coordinator.analyze(
      goal: 'research profitable products',
      state: BusinessState(),
    );

    expect(report.insights, isNotEmpty);
    expect(report.bestOpportunity, isNotNull);
    expect(report.bestOpportunity!.product, 'Portable LED Desk Lamp');
  });

  test('coordinator identifies strongest opportunity', () {
    final coordinator = EtherBusinessIntelligenceCoordinator();

    final best = coordinator.bestOpportunity(
      goal: 'find profitable products',
      state: BusinessState(),
    );

    expect(best, isNotNull);
    expect(best!.opportunityScore, 76);
    expect(best.classification, 'HIGH OPPORTUNITY');
  });

  test('analysis output contains intelligence sections', () {
    final coordinator = EtherBusinessIntelligenceCoordinator();

    final output = coordinator.createAnalysis(
      goal: 'research profitable products',
      state: BusinessState(),
    );

    expect(output, contains('FEK-3 BUSINESS INTELLIGENCE'));
    expect(output, contains('Goal: research profitable products'));
    expect(output, contains('ETHER BUSINESS INTELLIGENCE'));
    expect(output, contains('TOP OPPORTUNITY'));
    expect(output, contains('Portable LED Desk Lamp'));
  });

  test('intelligence never overrides financial approval boundary', () {
    final coordinator = EtherBusinessIntelligenceCoordinator();

    const decision = BusinessDecision(
      type: BusinessDecisionType.finance,
      action: 'Prepare financial action',
      reason: 'Financial commitment',
      requiresApproval: true,
    );

    expect(coordinator.requiresFinancialApproval(decision), isTrue);
  });

  test('empty research remains safe', () {
    final coordinator = EtherBusinessIntelligenceCoordinator();

    final report = coordinator.intelligence.analyze(const []);

    expect(report.insights, isEmpty);
    expect(report.bestOpportunity, isNull);
  });
}
