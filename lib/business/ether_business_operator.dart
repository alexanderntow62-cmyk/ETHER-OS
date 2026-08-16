import 'business_permission.dart';
import 'business_research_engine.dart';
import 'business_task.dart';
import 'ether_business_engine.dart';
import 'low_capital_business_strategy.dart';

class EtherBusinessOperator {
  final EtherBusinessEngine business;
  final EtherBusinessResearchEngine research;
  final EtherLowCapitalBusinessStrategy lowCapital;

  EtherBusinessOperator({
    EtherBusinessEngine? business,
    EtherBusinessResearchEngine? research,
    EtherLowCapitalBusinessStrategy? lowCapital,
  }) : business = business ?? EtherBusinessEngine(),
       research = research ?? EtherBusinessResearchEngine(),
       lowCapital = lowCapital ?? EtherLowCapitalBusinessStrategy();

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

    return _buildReport(goal: input, researchReport: researchReport);
  }

  bool _isDropshippingRequest(String input) {
    return input.contains('dropshipping') || input.contains('drop shipping');
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

    return [
      'ETHER BUSINESS OPERATOR',
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
      'Purchases, subscriptions, advertising payments, inventory purchases, '
          'and other financial commitments require your approval.',
    ].join('\n');
  }

  String _buildReport({required String goal, required String researchReport}) {
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

  BusinessTask createFinancialAction({required String goal}) {
    return business.createTask(
      id: 'financial_${business.tasks.length + 1}',
      goal: goal,
      permission: BusinessPermission.financial,
    );
  }
}
