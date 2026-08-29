import '../core/ether_skill.dart';
import '../../tools/ether_tool_engine.dart';
import '../../tools/research_tool.dart';

class ResearchSkill implements EtherSkill {
  final EtherToolEngine tools;

  ResearchSkill({EtherToolEngine? tools})
      : tools = tools ?? EtherToolEngine() {
    this.tools.register(ResearchTool());
  }

  @override
  String get id => 'research';

  @override
  String get name => 'research';

  @override
  String get description =>
      'Researches topics and gathers information for ETHER.';

  @override
  bool canHandle(String input) {
    final lower = input.toLowerCase();

    return lower.contains('research') ||
        lower.contains('investigate') ||
        lower.contains('find information') ||
        lower.contains('analyze market') ||
        lower.contains('market research');
  }

  @override
  Future<String> execute(String input) async {
    final result = await tools.tryHandle(input.trim());

    return result ?? 'Research tool could not handle this request.';
  }
}
