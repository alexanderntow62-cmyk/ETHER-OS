import 'content_objective.dart';
import 'content_plan.dart';

class ContentStrategy {
  final String niche;
  final String audience;
  final String positioning;
  final List<String> contentPillars;
  final List<String> formats;

  const ContentStrategy({
    required this.niche,
    required this.audience,
    required this.positioning,
    required this.contentPillars,
    required this.formats,
  });
}

class ContentStrategyEngine {
  ContentStrategy createStrategy(ContentObjective objective) {
    final lower = objective.goal.toLowerCase();

    String niche = 'general educational content';

    if (lower.contains('ai') || lower.contains('artificial intelligence')) {
      niche = 'AI tools, automation, and practical AI education';
    } else if (lower.contains('money') || lower.contains('finance')) {
      niche = 'personal finance and money education';
    } else if (lower.contains('tech')) {
      niche = 'technology and useful digital tools';
    } else if (lower.contains('anime')) {
      niche = 'anime entertainment and analysis';
    } else if (lower.contains('business')) {
      niche = 'business, entrepreneurship, and opportunities';
    }

    return ContentStrategy(
      niche: niche,
      audience: 'People interested in $niche',
      positioning: 'Useful, repeatable, easy-to-consume faceless content.',
      contentPillars: const [
        'Educational',
        'Trending topics',
        'Lists and comparisons',
        'How-to content',
        'News and updates',
      ],
      formats: const [
        'Short videos',
        'Long-form videos',
        'Lists',
        'Explainers',
        'Tutorials',
      ],
    );
  }

  ContentPlan createPlan(ContentObjective objective) {
    final steps = <ContentPlanStep>[
      const ContentPlanStep(
        id: 'content_01',
        title: 'Research niche',
        description:
            'Research audience demand, competitors, trends, and content opportunities.',
      ),
      const ContentPlanStep(
        id: 'content_02',
        title: 'Build channel strategy',
        description:
            'Define positioning, audience, content pillars, and publishing strategy.',
      ),
      const ContentPlanStep(
        id: 'content_03',
        title: 'Generate content ideas',
        description: 'Create a prioritized backlog of video ideas.',
      ),
      const ContentPlanStep(
        id: 'content_04',
        title: 'Write scripts',
        description:
            'Generate structured scripts suitable for faceless production.',
      ),
      const ContentPlanStep(
        id: 'content_05',
        title: 'Create voiceover',
        description:
            'Prepare narration using an available text-to-speech capability.',
      ),
      const ContentPlanStep(
        id: 'content_06',
        title: 'Create visual assets',
        description:
            'Prepare images, footage, captions, graphics, and other media assets.',
      ),
      const ContentPlanStep(
        id: 'content_07',
        title: 'Assemble video',
        description:
            'Combine narration, visuals, music, captions, and metadata into a video.',
      ),
      const ContentPlanStep(
        id: 'content_08',
        title: 'Repurpose',
        description:
            'Convert long-form content into short-form versions for TikTok and other platforms.',
      ),
      const ContentPlanStep(
        id: 'content_09',
        title: 'Prepare publishing',
        description:
            'Prepare titles, descriptions, hashtags, thumbnails, and publishing metadata.',
      ),
      const ContentPlanStep(
        id: 'content_10',
        title: 'Publish',
        description: 'Publish through an authorized platform integration.',
        permission: ContentPermission.approvalRequired,
      ),
      const ContentPlanStep(
        id: 'content_11',
        title: 'Measure',
        description:
            'Track views, watch time, retention, engagement, clicks, and conversions.',
      ),
      const ContentPlanStep(
        id: 'content_12',
        title: 'Learn and improve',
        description:
            'Use performance data to improve future topics, hooks, titles, and formats.',
      ),
      const ContentPlanStep(
        id: 'content_13',
        title: 'Financial actions',
        description:
            'Purchases, paid services, advertisements, subscriptions, and other financial commitments require explicit user approval.',
        permission: ContentPermission.financial,
      ),
    ];

    return ContentPlan(objective: objective, steps: steps);
  }
}
