import 'package:flutter_test/flutter_test.dart';
import '../lib/skills/research/research_skill.dart';

void main() {
  late ResearchSkill skill;

  setUp(() {
    skill = ResearchSkill();
  });

  test('Research skill can handle research requests', () {
    expect(
      skill.canHandle('research autonomous AI'),
      isTrue,
    );
  });

  test('Research skill uses the research tool', () async {
    final result = await skill.execute(
      'research autonomous AI',
    );

    expect(
      result,
      contains('Research tool ready for:'),
    );

    expect(
      result,
      contains('research autonomous AI'),
    );
  });
}
