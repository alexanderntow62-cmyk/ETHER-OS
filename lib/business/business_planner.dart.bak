import 'business_permission.dart';

class BusinessPlanStep {
  final String id;
  final String title;
  final String description;
  final BusinessPermission permission;

  const BusinessPlanStep({
    required this.id,
    required this.title,
    required this.description,
    this.permission = BusinessPermission.autonomous,
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
