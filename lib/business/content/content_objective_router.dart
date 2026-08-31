import 'content_business_engine.dart';
import 'content_objective.dart';

class ContentObjectiveRouter {
  final ContentBusinessEngine engine;

  ContentObjectiveRouter({ContentBusinessEngine? engine})
    : engine = engine ?? ContentBusinessEngine();

  bool isContentObjective(String input) {
    final text = input.toLowerCase();

    const signals = [
      'youtube',
      'tiktok',
      'faceless channel',
      'faceless youtube',
      'faceless tiktok',
      'content channel',
      'shorts',
      'short videos',
      'videos',
      'content business',
      'create content',
      'make videos',
      'content creator',
    ];

    return signals.any(text.contains);
  }

  ContentObjective route(String input) {
    final text = input.toLowerCase();

    final platforms = <ContentPlatform>[];

    if (text.contains('youtube')) {
      platforms.add(ContentPlatform.youtube);
    }

    if (text.contains('tiktok')) {
      platforms.add(ContentPlatform.tiktok);
    }

    if (platforms.isEmpty) {
      platforms.addAll([ContentPlatform.youtube, ContentPlatform.tiktok]);
    }

    final format = text.contains('short')
        ? ContentFormat.shortForm
        : text.contains('long')
        ? ContentFormat.longForm
        : ContentFormat.both;

    return ContentObjective(
      goal: input,
      platforms: platforms,
      format: format,
      repurposeContent: true,
    );
  }

  String execute(String input) {
    final objective = route(input);
    return engine.describe(objective);
  }
}
