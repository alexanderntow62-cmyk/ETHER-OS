import 'content_autonomy_loop.dart';
import 'content_objective.dart';
import 'content_plan.dart';
import 'content_publishing_engine.dart';

class ContentBusinessEngine {
  final ContentAutonomyLoop autonomyLoop;

  ContentBusinessEngine({ContentAutonomyLoop? autonomyLoop})
    : autonomyLoop = autonomyLoop ?? ContentAutonomyLoop();

  ContentPlan createPlan(ContentObjective objective) {
    return autonomyLoop.strategyEngine.createPlan(objective);
  }

  ContentAutonomyResult executePreparation(ContentObjective objective) {
    return autonomyLoop.run(objective);
  }

  bool requiresFinancialApproval(ContentPlanStep step) {
    return step.permission == ContentPermission.financial;
  }

  bool requiresPublishingApproval(ContentPlanStep step) {
    return step.permission == ContentPermission.approvalRequired;
  }

  PublishingResult preparePublishing(PublishingRequest request) {
    return ContentPublishingEngine().prepare(request);
  }

  String describe(ContentObjective objective) {
    final result = executePreparation(objective);

    return [
      'ETHER CONTENT BUSINESS',
      '======================',
      '',
      'OBJECTIVE:',
      objective.goal,
      '',
      'NICHE:',
      result.strategy.niche,
      '',
      'AUDIENCE:',
      result.strategy.audience,
      '',
      'CONTENT PILLARS:',
      ...result.strategy.contentPillars.map((e) => '- $e'),
      '',
      'CONTENT IDEAS:',
      ...result.opportunities.map(
        (e) => '- ${e.topic} (${e.opportunityScore})',
      ),
      '',
      'SCRIPTS PREPARED: ${result.generatedScripts.length}',
      'SHORT-FORM VERSIONS PREPARED: ${result.repurposedShorts.length}',
      '',
      'NEXT STAGE:',
      result.nextStage.name,
      '',
      'POLICY:',
      'ETHER may perform non-financial preparation autonomously.',
      'Publishing requires an authorized platform integration.',
      'Purchases, subscriptions, advertisements, and other financial actions require user approval.',
    ].join('\n');
  }
}
