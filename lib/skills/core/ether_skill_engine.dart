import '../../tools/ether_tool_engine.dart';
import '../calculator/calculator_skill.dart';
import '../research/research_skill.dart';
import '../system/system_skill.dart';
import 'ether_skill.dart';

class EtherSkillEngine {
  final EtherToolEngine tools;

  final List<EtherSkill> _skills;

  EtherSkillEngine({EtherToolEngine? tools})
    : tools = tools ?? EtherToolEngine(),
      _skills = [] {
    _skills.add(CalculatorSkill());
    _skills.add(SystemSkill());
    _skills.add(ResearchSkill(tools: this.tools));
  }

  EtherSkill? findSkill(String input) {
    for (final skill in _skills) {
      if (skill.canHandle(input)) {
        return skill;
      }
    }

    return null;
  }

  Future<String?> tryHandle(String input) async {
    final skill = findSkill(input);

    if (skill == null) {
      return null;
    }

    return skill.execute(input);
  }

  List<String> get skillNames => _skills.map((skill) => skill.name).toList();

  List<EtherSkill> get skills => List.unmodifiable(_skills);

  List<String> get toolNames => tools.toolNames;
}
