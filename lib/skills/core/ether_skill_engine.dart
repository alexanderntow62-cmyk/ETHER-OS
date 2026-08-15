import '../calculator/calculator_skill.dart';
import 'ether_skill.dart';

class EtherSkillEngine {
  final List<EtherSkill> _skills = [
    CalculatorSkill(),
  ];

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

  List<String> get skillNames =>
      _skills.map((s) => s.name).toList();
}
