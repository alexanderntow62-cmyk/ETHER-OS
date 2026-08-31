import 'content_analytics_engine.dart';
import 'content_objective.dart';
import 'content_repurposing_engine.dart';
import 'content_research_engine.dart';
import 'content_script_engine.dart';
import 'content_strategy_engine.dart';

enum ContentLoopStage {
  observe,
  research,
  decide,
  plan,
  produce,
  repurpose,
  preparePublish,
  measure,
  learn,
}

class ContentAutonomyResult {
  final ContentObjective objective;
  final ContentStrategy strategy;
  final List<ContentResearchItem> opportunities;
  final List<String> generatedScripts;
  final List<String> repurposedShorts;
  final ContentLoopStage nextStage;

  const ContentAutonomyResult({
    required this.objective,
    required this.strategy,
    required this.opportunities,
    required this.generatedScripts,
    required this.repurposedShorts,
    required this.nextStage,
  });
}

class ContentAutonomyLoop {
  final ContentStrategyEngine strategyEngine;
  final ContentResearchEngine researchEngine;
  final ContentScriptEngine scriptEngine;
  final ContentRepurposingEngine repurposingEngine;
  final ContentAnalyticsEngine analyticsEngine;

  ContentAutonomyLoop({
    ContentStrategyEngine? strategyEngine,
    ContentResearchEngine? researchEngine,
    ContentScriptEngine? scriptEngine,
    ContentRepurposingEngine? repurposingEngine,
    ContentAnalyticsEngine? analyticsEngine,
  }) : strategyEngine = strategyEngine ?? ContentStrategyEngine(),
       researchEngine = researchEngine ?? ContentResearchEngine(),
       scriptEngine = scriptEngine ?? ContentScriptEngine(),
       repurposingEngine = repurposingEngine ?? ContentRepurposingEngine(),
       analyticsEngine = analyticsEngine ?? ContentAnalyticsEngine();

  ContentAutonomyResult run(ContentObjective objective) {
    final strategy = strategyEngine.createStrategy(objective);

    final opportunities = researchEngine.generateOpportunities(strategy.niche);

    final scripts = <String>[];
    final shorts = <String>[];

    for (final opportunity in opportunities.take(3)) {
      final script = scriptEngine.createScript(topic: opportunity.topic);

      scripts.add(script.fullText);

      if (objective.repurposeContent) {
        final repurposed = repurposingEngine.repurpose(script.title);

        shorts.addAll(repurposed.shortTitles);
      }
    }

    return ContentAutonomyResult(
      objective: objective,
      strategy: strategy,
      opportunities: opportunities,
      generatedScripts: scripts,
      repurposedShorts: shorts,
      nextStage: ContentLoopStage.preparePublish,
    );
  }
}
