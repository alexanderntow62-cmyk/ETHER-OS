import 'content_business_engine.dart';
import 'content_objective_router.dart';

enum ContentWorkflowStatus { idle, planned, prepared, awaitingPublishing }

class ContentWorkflowResult {
  final ContentWorkflowStatus status;
  final String objective;
  final String report;

  const ContentWorkflowResult({
    required this.status,
    required this.objective,
    required this.report,
  });
}

class ContentWorkflowController {
  final ContentObjectiveRouter router;
  final ContentBusinessEngine engine;

  ContentWorkflowController({
    ContentObjectiveRouter? router,
    ContentBusinessEngine? engine,
  }) : engine = engine ?? ContentBusinessEngine(),
       router = router ?? ContentObjectiveRouter();

  ContentWorkflowResult execute(String objective) {
    final routed = router.route(objective);
    final plan = engine.createPlan(routed);
    final preparation = engine.executePreparation(routed);

    final publishRequired = plan.steps.any(
      (step) =>
          step.id == 'content_10' && engine.requiresPublishingApproval(step),
    );

    return ContentWorkflowResult(
      status: publishRequired
          ? ContentWorkflowStatus.awaitingPublishing
          : ContentWorkflowStatus.prepared,
      objective: objective,
      report: [
        'ETHER CONTENT WORKFLOW',
        '=====================',
        '',
        'OBJECTIVE:',
        objective,
        '',
        'NICHE:',
        preparation.strategy.niche,
        '',
        'AUDIENCE:',
        preparation.strategy.audience,
        '',
        'OPPORTUNITIES:',
        '${preparation.opportunities.length}',
        '',
        'SCRIPTS:',
        '${preparation.generatedScripts.length}',
        '',
        'REPURPOSED SHORTS:',
        '${preparation.repurposedShorts.length}',
        '',
        'PLAN STEPS:',
        '${plan.steps.length}',
        '',
        'STATUS:',
        publishRequired ? 'PREPARED — PUBLISHING GATE' : 'PREPARED',
        '',
        'AUTONOMY:',
        'Research, strategy, planning, scripting, repurposing,',
        'measurement preparation, and learning preparation may',
        'run autonomously.',
        '',
        'PUBLISHING:',
        'Requires an authorized platform integration.',
        '',
        'FINANCIAL SAFETY:',
        'Purchases, paid services, subscriptions, advertising,',
        'and financial commitments require user approval.',
      ].join('\n'),
    );
  }
}
