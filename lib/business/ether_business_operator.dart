import 'business_decision_engine.dart';
import 'business_permission.dart';
import 'business_research_engine.dart';
import 'business_state.dart';
import 'business_task.dart';
import 'content/content_business_engine.dart';
import 'content/content_objective.dart';
import 'ether_business_engine.dart';
import 'low_capital_business_strategy.dart';

class EtherBusinessOperator {
  final EtherBusinessEngine business;
  final EtherBusinessResearchEngine research;
  final EtherLowCapitalBusinessStrategy lowCapital;
  final EtherBusinessDecisionEngine decisionEngine;
  final ContentBusinessEngine contentBusiness;
  final BusinessState state;

  EtherBusinessOperator({
    EtherBusinessEngine? business,
    EtherBusinessResearchEngine? research,
    EtherLowCapitalBusinessStrategy? lowCapital,
    EtherBusinessDecisionEngine? decisionEngine,
    ContentBusinessEngine? contentBusiness,
    BusinessState? state,
  }) : business = business ?? EtherBusinessEngine(),
       research = research ?? EtherBusinessResearchEngine(),
       lowCapital = lowCapital ?? EtherLowCapitalBusinessStrategy(),
       decisionEngine = decisionEngine ?? EtherBusinessDecisionEngine(),
       contentBusiness = contentBusiness ?? ContentBusinessEngine(),
       state = state ?? BusinessState();

  Future<String> start(String goal) async {
    final input = goal.trim();

    if (input.isEmpty) {
      return 'ETHER BUSINESS OPERATOR\nNo business goal provided.';
    }

    // Low-capital requests must be handled before the general
    // decision engine because they represent a specialized
    // business strategy rather than a normal business operation.
    if (_isLowCapitalRequest(input.toLowerCase())) {
      return runLowCapital(input);
    }

    final decision = decisionEngine.decide(goal: input, state: state);

    switch (decision.type) {
      case BusinessDecisionType.finance:
        return _financialBoundary(input, decision);

      case BusinessDecisionType.research:
        return _runResearch(input, decision);

      case BusinessDecisionType.content:
        return _runContent(input, decision);

      case BusinessDecisionType.product:
        return _runProductWorkflow(input, decision);

      case BusinessDecisionType.marketing:
        return _runMarketing(input, decision);

      case BusinessDecisionType.customer:
        return _runCustomer(input, decision);

      case BusinessDecisionType.calculator:
        return _calculatorBoundary(input, decision);
      case BusinessDecisionType.general:
        return _runGeneral(input, decision);
    }
  }

  Future<String> _runResearch(String goal, BusinessDecision decision) async {
    final report = research.createReport();

    state.addGoal(goal);
    state.addPendingAction('Complete business research');

    return [
      'ETHER BUSINESS OPERATOR',
      '',
      decision.toString(),
      '',
      'RESEARCH EXECUTION',
      'Business goal analyzed',
      'Market research completed',
      'Product opportunities evaluated',
      '',
      report,
    ].join('\n');
  }

  Future<String> _runContent(String goal, BusinessDecision decision) async {
    state.addGoal(goal);

    final objective = ContentObjective(goal: goal);

    final result = contentBusiness.executePreparation(objective);

    state.addPendingAction('Review prepared content publishing');

    return [
      'ETHER BUSINESS OPERATOR',
      '',
      decision.toString(),
      '',
      'CONTENT BUSINESS WORKFLOW',
      'Content business objective analyzed',
      'Content strategy prepared',
      'Content opportunities researched',
      'Scripts prepared',
      'Short-form repurposing prepared',
      'Publishing package prepared',
      '',
      'NICHE:',
      result.strategy.niche,
      '',
      'CONTENT IDEAS: ${result.opportunities.length}',
      'SCRIPTS PREPARED: ${result.generatedScripts.length}',
      'SHORT-FORM VERSIONS: ${result.repurposedShorts.length}',
      '',
      'NEXT STAGE: ${result.nextStage.name}',
      '',
      'PUBLISHING BOUNDARY',
      'Publishing requires an authorized platform integration.',
      'Final publishing remains approval-gated.',
      '',
      'FINANCIAL SAFETY',
      'Purchases, subscriptions, paid advertising, and other financial commitments require your approval.',
    ].join('\\n');
  }

  Future<String> _runProductWorkflow(
    String goal,
    BusinessDecision decision,
  ) async {
    final task = business.createTask(
      id: 'operator_${business.tasks.length + 1}',
      goal: goal,
      permission: BusinessPermission.autonomous,
    );

    final executionResult = await business.execute(task);
    final researchReport = research.createReport();

    state.addGoal(goal);

    final best = research.selectBestProduct();
    if (best != null) {
      state.addProduct(best.product);
    }

    return [
      'ETHER BUSINESS OPERATOR',
      '',
      decision.toString(),
      '',
      'AUTONOMOUS WORKFLOW',
      'Business goal analyzed',
      'Market defined',
      'Products researched',
      'Products evaluated',
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

  Future<String> _runMarketing(String goal, BusinessDecision decision) async {
    state.addGoal(goal);

    return [
      'ETHER BUSINESS OPERATOR',
      '',
      decision.toString(),
      '',
      'MARKETING WORKFLOW',
      'Marketing objective analyzed',
      'Organic content strategy prepared',
      'Audience strategy prepared',
      'Promotion strategy prepared',
      '',
      'No paid advertising or financial commitment was made.',
      'Financial actions require your approval.',
    ].join('\n');
  }

  Future<String> _runCustomer(String goal, BusinessDecision decision) async {
    state.addGoal(goal);

    return [
      'ETHER BUSINESS OPERATOR',
      '',
      decision.toString(),
      '',
      'CUSTOMER WORKFLOW',
      'Customer objective analyzed',
      'Customer-facing strategy prepared',
      'Sales/support action prepared',
      '',
      'No financial transaction was performed.',
    ].join('\n');
  }

  /// Calculator requests are informational only.
  ///
  /// The actual calculation is intentionally NOT performed here.
  /// FEK-3/business logic must not duplicate FEK-2's CalculatorSkill.
  /// The coordinator/autonomy layer can hand the original request
  /// to FEK-2, where the CalculatorSkill performs the calculation.
  Future<String> _calculatorBoundary(
    String goal,
    BusinessDecision decision,
  ) async {
    state.addGoal(goal);

    return [
      'ETHER BUSINESS OPERATOR',
      '',
      decision.toString(),
      '',
      'CALCULATOR REQUEST',
      'This is an informational calculation.',
      'No financial transaction or business commitment is authorized.',
      'FEK-2 CalculatorSkill is responsible for performing the calculation.',
      '',
      'CALCULATOR HANDOFF',
      goal,
    ].join('\n');
  }

  Future<String> _runGeneral(String goal, BusinessDecision decision) async {
    state.addGoal(goal);

    final task = business.createTask(
      id: 'operator_${business.tasks.length + 1}',
      goal: goal,
    );

    final result = await business.execute(task);

    return [
      'ETHER BUSINESS OPERATOR',
      '',
      decision.toString(),
      '',
      result,
    ].join('\n');
  }

  String _financialBoundary(String goal, BusinessDecision decision) {
    final task = business.createTask(
      id: 'financial_${business.tasks.length + 1}',
      goal: goal,
      permission: BusinessPermission.financial,
    );

    task.waitForApproval();

    return [
      'ETHER BUSINESS OPERATOR',
      '',
      decision.toString(),
      '',
      'FINANCIAL SAFETY BOUNDARY',
      'ETHER prepared the financial action.',
      'ETHER will NOT spend money, purchase products, pay for advertising,',
      'subscribe to services, withdraw funds, or make financial commitments',
      'without your approval.',
      '',
      'ACTION REQUIRING APPROVAL:',
      goal,
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

  Future<String> runLowCapital(String goal) async {
    return _runLowCapitalStrategy(goal);
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

    return [
      'ETHER BUSINESS OPERATOR',
      'LOW-CAPITAL BUSINESS ANALYSIS',
      '',
      'Goal: $goal',
      '',
      report,
      '',
      'AUTONOMOUS POLICY',
      'ETHER may research and prepare suitable opportunities autonomously.',
      'ETHER must not spend money automatically.',
      '',
      'FINANCIAL SAFETY',
      'Purchases, subscriptions, advertising payments, inventory purchases,',
      'and other financial commitments require your approval.',
    ].join('\n');
  }

  BusinessTask createFinancialAction({required String goal}) {
    return business.createTask(
      id: 'financial_${business.tasks.length + 1}',
      goal: goal,
      permission: BusinessPermission.financial,
    );
  }
}
