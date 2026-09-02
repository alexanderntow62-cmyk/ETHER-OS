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

  bool get isFinancial => permission == BusinessPermission.financial;
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

    if (_isAffiliateYouTubeMission(lower)) {
      return _createAffiliateYouTubePlan(input);
    }

    if (lower.contains('dropshipping') || lower.contains('drop shipping')) {
      return _createDropshippingPlan(input);
    }

    return _createGeneralBusinessPlan(input);
  }

  bool _isAffiliateYouTubeMission(String input) {
    return input.contains('affiliate') ||
        input.contains('youtube') ||
        input.contains('zero-capital') ||
        input.contains('zero capital') ||
        input.contains('organic marketing');
  }

  BusinessPlan _createAffiliateYouTubePlan(String goal) {
    return BusinessPlan(
      goal: goal,
      steps: const [
        BusinessPlanStep(
          id: 'affiliate_01',
          title: 'Select specific niche',
          description:
              'Research and select a legitimate affiliate-marketing niche suitable for organic YouTube distribution and zero-capital operation.',
        ),
        BusinessPlanStep(
          id: 'affiliate_02',
          title: 'Identify target customer',
          description:
              'Define the target audience, customer problem, search intent, needs, and buying context.',
        ),
        BusinessPlanStep(
          id: 'affiliate_03',
          title: 'Create business identity',
          description:
              'Develop the proposed business name, identity, mission, values, and operating concept without claiming that an external account has been created.',
        ),
        BusinessPlanStep(
          id: 'affiliate_04',
          title: 'Create brand positioning',
          description:
              'Define the brand promise, differentiation, audience positioning, trust strategy, and value proposition.',
        ),
        BusinessPlanStep(
          id: 'affiliate_05',
          title: 'Design YouTube channel',
          description:
              'Prepare the proposed YouTube channel structure, visual direction, sections, playlists, and content organization. Do not claim that the channel exists.',
        ),
        BusinessPlanStep(
          id: 'affiliate_06',
          title: 'Create channel description',
          description:
              'Write the proposed YouTube channel description, disclosure language, positioning statement, and audience promise.',
        ),
        BusinessPlanStep(
          id: 'affiliate_07',
          title: 'Define content pillars',
          description:
              'Create the core content pillars covering education, comparisons, reviews, problem solving, and buyer-intent topics.',
        ),
        BusinessPlanStep(
          id: 'affiliate_08',
          title: 'Create 30-day publishing plan',
          description:
              'Build a 30-day organic YouTube publishing schedule with topics, objectives, content formats, and calls to action.',
        ),
        BusinessPlanStep(
          id: 'affiliate_09',
          title: 'Create first 10 videos',
          description:
              'Prepare the first ten video concepts with target keyword or intent, audience problem, angle, format, and CTA.',
        ),
        BusinessPlanStep(
          id: 'affiliate_10',
          title: 'Prepare video #1 script',
          description:
              'Create the complete first-video script including hook, problem, useful information, evidence, recommendation structure, disclosure, and CTA.',
        ),
        BusinessPlanStep(
          id: 'affiliate_11',
          title: 'Prepare title options',
          description:
              'Create multiple honest, search-aware YouTube title options for video #1 without misleading clickbait.',
        ),
        BusinessPlanStep(
          id: 'affiliate_12',
          title: 'Prepare video description',
          description:
              'Write the complete proposed description including summary, useful resources, affiliate disclosure placeholder, and CTA.',
        ),
        BusinessPlanStep(
          id: 'affiliate_13',
          title: 'Prepare CTA',
          description:
              'Design a clear non-misleading call to action encouraging viewers to take the next appropriate step.',
        ),
        BusinessPlanStep(
          id: 'affiliate_14',
          title: 'Prepare thumbnail concept',
          description:
              'Design a proposed thumbnail concept including visual hierarchy, text concept, subject, contrast, and curiosity element.',
        ),
        BusinessPlanStep(
          id: 'affiliate_15',
          title: 'Research affiliate programs',
          description:
              'Research legitimate affiliate programs relevant to the selected niche, including commission model, product relevance, reputation, and application process.',
        ),
        BusinessPlanStep(
          id: 'affiliate_16',
          title: 'Identify affiliate approval requirements',
          description:
              'Document account, identity, website, traffic, geographic, disclosure, tax, payment, and other requirements for legitimate affiliate programs.',
        ),
        BusinessPlanStep(
          id: 'affiliate_17',
          title: 'Identify free tools',
          description:
              'Identify free or already-available tools for research, scripting, design, editing, analytics, organization, and publishing preparation. Avoid paid subscriptions.',
        ),
        BusinessPlanStep(
          id: 'affiliate_18',
          title: 'Create operating task queue',
          description:
              'Create the prioritized queue of research, content, publishing-preparation, measurement, and learning tasks.',
        ),
        BusinessPlanStep(
          id: 'affiliate_19',
          title: 'Create daily operating tasks',
          description:
              'Define repeatable daily tasks for research, content production, audience learning, analytics review, and workflow improvement.',
        ),
        BusinessPlanStep(
          id: 'affiliate_20',
          title: 'Create weekly operating tasks',
          description:
              'Define weekly planning, content review, KPI review, experiment review, and strategy-adjustment tasks.',
        ),
        BusinessPlanStep(
          id: 'affiliate_21',
          title: 'Define KPIs',
          description:
              'Define measurable KPIs including publishing consistency, impressions, click-through rate, watch time, retention, engagement, affiliate clicks, conversions, and revenue when real data exists.',
        ),
        BusinessPlanStep(
          id: 'affiliate_22',
          title: 'Create first business experiment',
          description:
              'Design the first low-risk organic content experiment that requires no financial expenditure.',
        ),
        BusinessPlanStep(
          id: 'affiliate_23',
          title: 'Define experiment hypothesis',
          description:
              'State the first experiment hypothesis in measurable form and identify the variable being tested.',
        ),
        BusinessPlanStep(
          id: 'affiliate_24',
          title: 'Define experiment success criteria',
          description:
              'Define objective thresholds that determine whether the first experiment is successful.',
        ),
        BusinessPlanStep(
          id: 'affiliate_25',
          title: 'Define experiment failure criteria',
          description:
              'Define objective conditions that determine whether the experiment fails or requires a strategy change.',
        ),
        BusinessPlanStep(
          id: 'affiliate_26',
          title: 'Define success response',
          description:
              'Define what ETHER should do after a successful experiment, including replication, refinement, and controlled expansion.',
        ),
        BusinessPlanStep(
          id: 'affiliate_27',
          title: 'Define failure response',
          description:
              'Define what ETHER should do after a failed experiment, including diagnosis, learning, modification, and the next test.',
        ),
        BusinessPlanStep(
          id: 'affiliate_28',
          title: 'Record business decisions',
          description:
              'Prepare business decisions, experiment results, assumptions, and lessons for persistent business memory when persistence is available.',
        ),
        BusinessPlanStep(
          id: 'affiliate_29',
          title: 'Continue non-financial autonomous work',
          description:
              'Continue research, planning, writing, analysis, content preparation, KPI design, and other permitted work without spending money.',
        ),
        BusinessPlanStep(
          id: 'affiliate_30',
          title: 'Prepare blocked external actions',
          description:
              'Identify actions requiring authentication, account creation, human verification, permissions, or unavailable integrations and mark them BLOCKED instead of claiming completion.',
        ),
        BusinessPlanStep(
          id: 'affiliate_finance',
          title: 'Financial actions',
          description:
              'Purchases, payments, paid subscriptions, paid advertising, transfers, and financial commitments require explicit user authorization.',
          permission: BusinessPermission.financial,
        ),
      ],
    );
  }

  BusinessPlan _createDropshippingPlan(String goal) {
    return BusinessPlan(
      goal: goal,
      steps: const [
        BusinessPlanStep(
          id: 'dropship_01',
          title: 'Define market',
          description: 'Identify the target customer and market.',
        ),
        BusinessPlanStep(
          id: 'dropship_02',
          title: 'Research products',
          description: 'Identify potentially viable products.',
        ),
        BusinessPlanStep(
          id: 'dropship_03',
          title: 'Evaluate products',
          description: 'Compare demand, competition, pricing, and margins.',
        ),
        BusinessPlanStep(
          id: 'dropship_04',
          title: 'Select products',
          description: 'Choose the strongest candidate products.',
        ),
        BusinessPlanStep(
          id: 'dropship_05',
          title: 'Build pricing strategy',
          description: 'Calculate target selling prices and expected margins.',
        ),
        BusinessPlanStep(
          id: 'dropship_06',
          title: 'Prepare store strategy',
          description:
              'Define store structure, product presentation, and positioning.',
        ),
        BusinessPlanStep(
          id: 'dropship_07',
          title: 'Prepare marketing strategy',
          description:
              'Create an organic marketing plan and identify any paid activities as approval-required.',
        ),
        BusinessPlanStep(
          id: 'dropship_08',
          title: 'Prepare launch',
          description:
              'Prepare the business for launch without claiming external accounts or services were created.',
        ),
        BusinessPlanStep(
          id: 'dropship_finance',
          title: 'Financial actions',
          description:
              'Any purchase, payment, paid service, paid advertising, or financial commitment requires user approval.',
          permission: BusinessPermission.financial,
        ),
      ],
    );
  }

  BusinessPlan _createGeneralBusinessPlan(String goal) {
    return BusinessPlan(
      goal: goal,
      steps: const [
        BusinessPlanStep(
          id: 'general_01',
          title: 'Analyze business goal',
          description: 'Understand the requested business objective.',
        ),
        BusinessPlanStep(
          id: 'general_02',
          title: 'Identify customer',
          description: 'Define the target customer and their problem.',
        ),
        BusinessPlanStep(
          id: 'general_03',
          title: 'Research market',
          description:
              'Research demand, competition, opportunities, and risks.',
        ),
        BusinessPlanStep(
          id: 'general_04',
          title: 'Create strategy',
          description: 'Develop an actionable business strategy.',
        ),
        BusinessPlanStep(
          id: 'general_05',
          title: 'Define operating workflow',
          description: 'Create daily and weekly operating tasks.',
        ),
        BusinessPlanStep(
          id: 'general_06',
          title: 'Define KPIs',
          description: 'Define measurable performance indicators.',
        ),
        BusinessPlanStep(
          id: 'general_finance',
          title: 'Financial actions',
          description: 'Financial commitments require user approval.',
          permission: BusinessPermission.financial,
        ),
      ],
    );
  }
}
