import 'business_permission.dart';

class BusinessPlanStep {
  final String id;
  final String title;
  final String description;
  final BusinessPermission permission;

  /// Optional integration this step is intended to use.
  ///
  /// This is planning metadata only. Execution must still pass through
  /// EtherBusinessEngine's integration capability and safety gates.
  final String? integrationId;

  /// Optional integration action this step is intended to perform.
  ///
  /// This must be validated against the integration registry before execution.
  final String? action;

  const BusinessPlanStep({
    required this.id,
    required this.title,
    required this.description,
    this.permission = BusinessPermission.autonomous,
    this.integrationId,
    this.action,
  });
}

class BusinessPlan {
  final String goal;
  final List<BusinessPlanStep> steps;

  const BusinessPlan({required this.goal, required this.steps});
}

class EtherBusinessPlanner {
  BusinessPlan createPlan(String goal) {
    final input = goal.trim();
    final lower = input.toLowerCase();

    if (input.isEmpty) {
      return const BusinessPlan(goal: '', steps: []);
    }

    if (lower.contains('affiliate')) {
      return BusinessPlan(
        goal: input,
        steps: const [
          BusinessPlanStep(
            id: 'affiliate_1',
            title: 'Define target market',
            description: 'Identify the customer segment and problem the affiliate offer should address.',
          ),
          BusinessPlanStep(
            id: 'affiliate_2',
            title: 'Research affiliate products',
            description: 'Identify legitimate affiliate products that solve a clear customer problem.',
          ),
          BusinessPlanStep(
            id: 'affiliate_3',
            title: 'Evaluate products',
            description: 'Compare usefulness, trustworthiness, demand, competition, fulfillment, and affiliate terms.',
          ),
          BusinessPlanStep(
            id: 'affiliate_4',
            title: 'Select product',
            description: 'Choose the strongest product candidate without purchasing inventory.',
          ),
          BusinessPlanStep(
            id: 'affiliate_5',
            title: 'Define customer problem',
            description: 'Document the problem, desired outcome, objections, and reasons the offer may help.',
          ),
          BusinessPlanStep(
            id: 'affiliate_6',
            title: 'Prepare offer',
            description: 'Prepare the product explanation, value proposition, positioning, and call to action.',
          ),
          BusinessPlanStep(
            id: 'affiliate_7',
            title: 'Prepare content strategy',
            description: 'Prepare educational posts, demonstrations, comparisons, tutorials, FAQs, and problem-solving content.',
          ),
          BusinessPlanStep(
            id: 'affiliate_8',
            title: 'Prepare organic acquisition',
            description: 'Prepare organic social media, communities, referrals, and direct-outreach strategies.',
          ),
          BusinessPlanStep(
            id: 'affiliate_9',
            title: 'Prepare conversion workflow',
            description: 'Define the path from audience to content, interest, product explanation, affiliate link, merchant, and purchase.',
          ),
          BusinessPlanStep(
            id: 'affiliate_10',
            title: 'Prepare performance tracking',
            description: 'Define tracking for content, reach, engagement, clicks, conversions, commissions, and customer feedback.',
          ),
          BusinessPlanStep(
            id: 'affiliate_11',
            title: 'Prepare optimization',
            description: 'Define how ETHER can improve products, content, positioning, messaging, and acquisition based on results.',
          ),
          BusinessPlanStep(
            id: 'affiliate_12',
            title: 'Financial actions',
            description: 'Purchases, advertising, subscriptions, inventory, and other financial commitments require your approval.',
            permission: BusinessPermission.financial,
          ),
        ],
      );
    }

    if (lower.contains('dropshipping') || lower.contains('drop shipping')) {
      return BusinessPlan(
        goal: input,
        steps: const [
          BusinessPlanStep(
            id: 'business_1',
            title: 'Define market',
            description: 'Identify the target customer and market.',
          ),
          BusinessPlanStep(
            id: 'business_2',
            title: 'Research products',
            description: 'Identify potentially viable products.',
          ),
          BusinessPlanStep(
            id: 'business_3',
            title: 'Evaluate products',
            description: 'Compare demand, competition, pricing, and margins.',
          ),
          BusinessPlanStep(
            id: 'business_4',
            title: 'Select products',
            description: 'Choose the strongest candidate products.',
          ),
          BusinessPlanStep(
            id: 'business_5',
            title: 'Build pricing strategy',
            description:
                'Calculate target selling prices and expected margins.',
          ),
          BusinessPlanStep(
            id: 'business_6',
            title: 'Prepare store strategy',
            description:
                'Define store structure, product presentation, and positioning.',
          ),
          BusinessPlanStep(
            id: 'business_7',
            title: 'Prepare marketing strategy',
            description: 'Create an organic and paid marketing plan.',
          ),
          BusinessPlanStep(
            id: 'business_8',
            title: 'Prepare launch',
            description: 'Prepare the business for launch.',
          ),
          BusinessPlanStep(
            id: 'business_9',
            title: 'Financial actions',
            description:
                'Any purchase, payment, or financial commitment requires your approval.',
            permission: BusinessPermission.financial,
          ),
        ],
      );
    }

    return BusinessPlan(
      goal: input,
      steps: [
        BusinessPlanStep(
          id: 'business_1',
          title: 'Analyze business goal',
          description: 'Understand the requested business objective.',
        ),
        BusinessPlanStep(
          id: 'business_2',
          title: 'Create strategy',
          description: 'Develop an actionable business strategy.',
        ),
        const BusinessPlanStep(
          id: 'business_3',
          title: 'Financial actions',
          description: 'Financial commitments require your approval.',
          permission: BusinessPermission.financial,
        ),
      ],
    );
  }
}
