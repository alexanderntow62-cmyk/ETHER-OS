import 'package:flutter_test/flutter_test.dart';
import '../lib/skills/core/ether_skill_engine.dart';
import '../lib/tools/ether_tool_engine.dart';

void main() {
  test('Skill engine exposes the research skill', () {
    final engine = EtherSkillEngine();

    expect(engine.skillNames, contains('research'));
  });

  test('Skill engine registers the research tool', () {
    final engine = EtherSkillEngine();

    expect(engine.toolNames, contains('research'));
  });

  test('Research skill uses the shared tool engine', () async {
    final tools = EtherToolEngine();
    final engine = EtherSkillEngine(tools: tools);

    final result = await engine.tryHandle(
      'research autonomous AI',
    );

    expect(result, contains('Research tool ready for:'));
    expect(result, contains('research autonomous AI'));
  });
}
