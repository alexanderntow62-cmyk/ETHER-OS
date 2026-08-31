import '../business_decision_engine.dart';
import '../business_research_engine.dart';
import '../business_state.dart';
import 'business_intelligence_engine.dart';

/// FEK-3 business intelligence coordinator.
///
/// Responsibilities:
/// - obtain research evidence
/// - convert research into business intelligence
/// - expose the highest-value opportunity
/// - never perform purchases, payments, subscriptions, or other
///   financial commitments
class EtherBusinessIntelligenceCoordinator {
  final EtherBusinessResearchEngine research;
  final EtherBusinessIntelligenceEngine intelligence;

  EtherBusinessIntelligenceCoordinator({
    EtherBusinessResearchEngine? research,
    EtherBusinessIntelligenceEngine? intelligence,
  })  : research = research ?? EtherBusinessResearchEngine(),
        intelligence =
            intelligence ?? const EtherBusinessIntelligenceEngine();

  EtherBusinessIntelligenceReport analyze({
    required String goal,
    BusinessState? state,
  }) {
    final products = research.researchProducts();
    return intelligence.analyze(products);
  }

  String createAnalysis({
    required String goal,
    BusinessState? state,
  }) {
    final report = analyze(goal: goal, state: state);

    return [
      'FEK-3 BUSINESS INTELLIGENCE',
      '',
      'Goal: ${goal.trim()}',
      '',
      report.summary,
      '',
      'AUTONOMOUS POLICY',
      'Intelligence is informational and planning-only.',
      'No purchases, payments, subscriptions, advertising payments,',
      'inventory purchases, withdrawals, or other financial commitments',
      'are performed by the intelligence layer.',
    ].join('\n');
  }

  BusinessIntelligenceInsight? bestOpportunity({
    required String goal,
    BusinessState? state,
  }) {
    return analyze(goal: goal, state: state).bestOpportunity;
  }

  bool requiresFinancialApproval(BusinessDecision decision) {
    return decision.requiresApproval;
  }
}
