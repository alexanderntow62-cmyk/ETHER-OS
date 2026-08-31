import 'package:flutter_test/flutter_test.dart';
import 'package:ether_os/business/content/content_business_engine.dart';
import 'package:ether_os/business/content/content_objective.dart';

void main() {
  test('faceless YouTube and TikTok objective creates content workflow', () {
    const objective = ContentObjective(
      goal:
          'Create a faceless YouTube channel about AI tools and turn every video into TikToks',
    );

    final engine = ContentBusinessEngine();
    final result = engine.executePreparation(objective);

    expect(objective.isFaceless, isTrue);
    expect(objective.usesYouTube, isTrue);
    expect(objective.usesTikTok, isTrue);
    expect(result.opportunities, isNotEmpty);
    expect(result.generatedScripts, isNotEmpty);
    expect(result.repurposedShorts, isNotEmpty);
  });

  test('publishing remains gated', () {
    const objective = ContentObjective(
      goal: 'Create a faceless technology channel',
    );

    final engine = ContentBusinessEngine();
    final plan = engine.createPlan(objective);

    final publishStep = plan.steps.firstWhere(
      (step) => step.id == 'content_10',
    );

    expect(engine.requiresPublishingApproval(publishStep), isTrue);
  });

  test('financial activity remains gated', () {
    const objective = ContentObjective(
      goal: 'Create a faceless business channel',
    );

    final engine = ContentBusinessEngine();
    final plan = engine.createPlan(objective);

    final financialStep = plan.steps.firstWhere(
      (step) => step.id == 'content_13',
    );

    expect(engine.requiresFinancialApproval(financialStep), isTrue);
  });
}
