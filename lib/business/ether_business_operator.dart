import 'business_permission.dart';
import 'business_research_engine.dart';
import 'business_task.dart';
import 'ether_business_engine.dart';
import 'low_capital_business_strategy.dart';
import 'business_opportunity_engine.dart';
import 'business_mission_engine.dart';

class EtherBusinessOperator {
  final EtherBusinessEngine business;
  final EtherBusinessResearchEngine research;
  final EtherLowCapitalBusinessStrategy lowCapital;
  final EtherBusinessOpportunityEngine opportunities;
  final BusinessMissionEngine missionEngine;

  EtherBusinessOperator({
    EtherBusinessEngine? business,
    EtherBusinessResearchEngine? research,
    EtherLowCapitalBusinessStrategy? lowCapital,
    EtherBusinessOpportunityEngine? opportunities,
    BusinessMissionEngine? missionEngine,
  })  : business = business ?? EtherBusinessEngine(),
        research = research ?? EtherBusinessResearchEngine(),
        lowCapital = lowCapital ?? EtherLowCapitalBusinessStrategy(),
        opportunities =
            opportunities ?? EtherBusinessOpportunityEngine(),
        missionEngine = missionEngine ?? BusinessMissionEngine();

  Future<String> start(String goal) async {
    final input = goal.trim();

    if (input.isEmpty) {
      return 'ETHER BUSINESS OPERATOR\nNo business goal provided.';
    }

    final lower = input.toLowerCase();

    if (_isLowCapitalRequest(lower)) {
      return _runLowCapitalStrategy(input);
    }

    if (_isDropshippingRequest(lower)) {
      return _runDropshippingWorkflow(input);
    }

    if (_isGeneralBusinessRequest(lower)) {
      return _runAutonomousBusinessDiscovery(input);
    }

    final task = business.createTask(
      id: 'operator_${business.tasks.length + 1}',
      goal: input,
    );

    final planResult = await business.execute(task);

    if (task.status == BusinessTaskStatus.waitingApproval) {
      return [
        'ETHER BUSINESS OPERATOR',
        '',
        planResult,
      ].join('\n');
    }

    final researchReport = research.createReport();

    return _buildReport(
      goal: input,
      researchReport: researchReport,
    );
  }

  bool _isDropshippingRequest(String input) {
    return input.contains('dropshipping') ||
        input.contains('drop shipping');
  }

  bool _isGeneralBusinessRequest(String input) {
    const terms = [
      'start a business',
      'start business',
      'build a business',
      'build my business',
      'create a business',
      'run a business',
      'make money',
      'business for me',
      'find me a business',
      'find a business',
      'start something',
      'business opportunity',
      'business idea',
    ];

    return terms.any(input.contains);
  }

  Future<String> _runAutonomousBusinessDiscovery(String goal) async {
    final report = opportunities.createReport(
      market: BusinessMarket.both,
      capital: CapitalRequirement.zero,
    );

    final candidates = opportunities.generate(
      market: BusinessMarket.both,
      capital: CapitalRequirement.zero,
    );

    if (candidates.isEmpty) {
      return [
        'ETHER BUSINESS OPERATOR',
        '',
        'Goal: $goal',
        '',
        'No suitable zero-capital opportunity was found.',
        '',
        'ETHER will continue researching opportunities.',
        '',
        'FINANCIAL BOUNDARY',
        'ETHER cannot spend personal money automatically.',
      ].join('\n');
    }

    final selected = candidates.first;

    final task = business.createTask(
      id: 'operator_${business.tasks.length + 1}',
      goal: 'Execute autonomous preparation for ${selected.name}',
    );

    final execution = await business.execute(task);

    final mission = missionEngine.createMission(
      id: 'mission_${business.tasks.length}',
      goal: goal,
      businessName: selected.name,
    );

    final stageResults = <String>[];

    for (final step in mission.steps) {
      final result = missionEngine.executeBusinessStage(
        mission: mission,
        step: step,
      );

      stageResults.add(result);

      if (step.requiresApproval) {
        break;
      }
    }

    final missionPreparation = stageResults.join('\n\n');

    return [
      'ETHER BUSINESS OPERATOR',
      '',
      'AUTONOMOUS BUSINESS DISCOVERY',
      '',
      'Goal: $goal',
      '',
      'TARGET MARKETS',
      'Ghana: YES',
      'International: YES',
      '',
      'SELECTED OPPORTUNITY',
      selected.name,
      '',
      selected.description,
      '',
      'OPPORTUNITY SCORE: ${selected.score}/100',
      '',
      'ETHER AUTONOMOUS CAPABILITIES',
      'Research opportunities',
      'Analyze markets',
      'Evaluate customers',
      'Develop business strategy',
      'Prepare product/service positioning',
      'Prepare marketing strategy',
      'Prepare launch strategy',
      'Prepare operational workflows',
      'Analyze pricing and profitability',
      'Track business tasks',
      '',
      'SELECTED OPPORTUNITY ANALYSIS',
      ...selected.reasons.map((reason) => '- $reason'),
      '',
      'BUSINESS EXECUTION',
      execution,
      '',
      missionPreparation,
      '',
      report,
      '',
      'FINANCIAL BOUNDARY',
      'ETHER may perform non-financial business work autonomously.',
      'Purchases, payments, subscriptions, advertising spend, inventory purchases, and other financial commitments require your explicit approval.',
      'ETHER will never use your personal money without authorization.',
    ].join('\n');
  }

  bool _isLowCapitalRequest(String input) {
    const terms = [
      'no money',
      'without money',
      'little money',
      'little or no money',
      'low capital',
      'low-capital',
      'zero capital',
      'zero-capital',
      'no upfront',
      'without upfront',
      'start with nothing',
      'cheap business',
      'free business',
    ];

    return terms.any(input.contains);
  }

  Future<String> _runLowCapitalStrategy(String goal) async {
    const opportunities = [
      BusinessOpportunity(
        name: 'Organic Affiliate Marketing',
        capital: CapitalRequirement.zero,
        requiresInventory: false,
        directToCustomer: false,
        requiresPaidAdvertising: false,
        requiresSubscription: false,
        estimatedUpfrontCost: 0,
      ),
      BusinessOpportunity(
        name: 'Direct-to-Customer Dropshipping',
        capital: CapitalRequirement.low,
        requiresInventory: false,
        directToCustomer: true,
        requiresPaidAdvertising: false,
        requiresSubscription: true,
        estimatedUpfrontCost: 15,
      ),
      BusinessOpportunity(
        name: 'Print-on-Demand',
        capital: CapitalRequirement.low,
        requiresInventory: false,
        directToCustomer: true,
        requiresPaidAdvertising: false,
        requiresSubscription: false,
        estimatedUpfrontCost: 0,
      ),
      BusinessOpportunity(
        name: 'Inventory Retail Store',
        capital: CapitalRequirement.high,
        requiresInventory: true,
        directToCustomer: true,
        requiresPaidAdvertising: true,
        requiresSubscription: true,
        estimatedUpfrontCost: 500,
      ),
    ];

    final report = lowCapital.createReport(opportunities);

    final candidates = opportunities
        .where((opportunity) =>
            opportunity.capital == CapitalRequirement.zero)
        .toList();

    final selected = candidates.isNotEmpty
        ? candidates.first
        : opportunities.first;

    final mission = missionEngine.createMission(
      id: 'low_capital_mission_${DateTime.now().millisecondsSinceEpoch}',
      goal: goal,
      businessName: selected.name,
    );

    final stageResults = <String>[];

    for (final step in mission.steps) {
      final result = missionEngine.executeBusinessStage(
        mission: mission,
        step: step,
      );

      stageResults.add(result);

      if (step.requiresApproval) {
        break;
      }
    }

    final missionPreparation = stageResults.join('\n\n');
    final executionPackage = missionEngine.buildExecutionPackage(mission: mission);

    return [
      'ETHER BUSINESS OPERATOR',
      '',
      'Goal: $goal',
      '',
      report,
      '',
      'BUSINESS MISSION',
      'EXECUTION PACKAGE',
      executionPackage,
      missionPreparation,
      '',
      'AUTONOMOUS POLICY',
      'ETHER may research and prepare suitable opportunities autonomously.',
      'ETHER must not spend money automatically.',
      '',
      'FINANCIAL SAFETY',
      'Purchases, subscriptions, advertising payments, inventory purchases, '
          'and financial commitments require your approval.',
    ].join('\n');
  }

  Future<String> _runDropshippingWorkflow(String goal) async {
    final task = business.createTask(
      id: 'operator_${business.tasks.length + 1}',
      goal: goal,
    );

    final executionResult = await business.execute(task);

    final researchReport = research.createReport();

    return [
      'ETHER BUSINESS OPERATOR',
      '',
      'Goal: $goal',
      '',
      'AUTONOMOUS WORKFLOW',
      'Business goal analyzed',
      'Business plan prepared',
      'Product research completed',
      'Product evaluation completed',
      'Product recommendation completed',
      '',
      executionResult,
      '',
      researchReport,
      '',
      'FINANCIAL BOUNDARY',
      'No purchases, payments, subscriptions, or financial commitments were made.',
      'Any financial action requires your approval.',
    ].join('\n');
  }

  String _buildReport({
    required String goal,
    required String researchReport,
  }) {
    return [
      'ETHER BUSINESS OPERATOR',
      '',
      'Goal: $goal',
      '',
      'AUTONOMOUS WORKFLOW',
      'Business goal analyzed',
      'Business plan prepared',
      'Product research completed',
      'Product evaluation completed',
      'Product recommendation completed',
      '',
      researchReport,
      '',
      'FINANCIAL BOUNDARY',
      'No purchases, payments, subscriptions, or financial commitments were made.',
      'Any financial action requires your approval.',
    ].join('\n');
  }

  BusinessTask createFinancialAction({
    required String goal,
  }) {
    return business.createTask(
      id: 'financial_${business.tasks.length + 1}',
      goal: goal,
      permission: BusinessPermission.financial,
    );
  }
}
