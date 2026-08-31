import 'package:flutter_test/flutter_test.dart';
import 'package:ether_os/business/content/content_objective_router.dart';

void main() {
  test('routes faceless YouTube and TikTok objective', () {
    final router = ContentObjectiveRouter();

    const input =
        'Create a faceless YouTube channel about AI and turn the videos into TikToks';

    expect(router.isContentObjective(input), isTrue);

    final objective = router.route(input);

    expect(objective.isFaceless, isTrue);
    expect(objective.usesYouTube, isTrue);
    expect(objective.usesTikTok, isTrue);
    expect(objective.repurposeContent, isTrue);
  });

  test('defaults to YouTube and TikTok for content objectives', () {
    final router = ContentObjectiveRouter();

    final objective = router.route(
      'Create a faceless content business about technology',
    );

    expect(objective.usesYouTube, isTrue);
    expect(objective.usesTikTok, isTrue);
  });
}
