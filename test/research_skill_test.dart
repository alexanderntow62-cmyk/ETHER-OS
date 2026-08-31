import 'package:flutter_test/flutter_test.dart';
import 'package:ether_os/skills/research/research_skill.dart';

void main() {
  late ResearchSkill skill;

  setUp(() {
    skill = ResearchSkill();
  });

  test('Research skill can handle research requests', () {
    expect(skill.canHandle('research autonomous AI'), isTrue);
  });

  test('Research skill uses the research tool', () async {
    final result = await skill.execute('research autonomous AI');

    expect(result, contains('RESEARCH PROVIDER: LOCAL'));

    expect(result, contains('research autonomous AI'));
  });
}
