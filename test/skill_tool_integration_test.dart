import 'package:flutter_test/flutter_test.dart';
import 'package:ether_os/skills/core/ether_skill_engine.dart';
import 'package:ether_os/tools/ether_tool_engine.dart';

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

    final result = await engine.tryHandle('research autonomous AI');

    expect(result, contains('RESEARCH PROVIDER: LOCAL'));
    expect(result, contains('research autonomous AI'));
  });
}
