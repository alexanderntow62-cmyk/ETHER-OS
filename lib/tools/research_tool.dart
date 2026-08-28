import 'ether_tool.dart';

/// ETHER's research tool.
///
/// This is the external-information interface used by ResearchSkill.
/// The tool itself does not make business decisions; it only gathers
/// information for the intelligence layer.
class ResearchTool implements EtherTool {
  @override
  String get name => 'research';

  @override
  String get description =>
      'Gathers external information for ETHER research tasks.';

  @override
  Future<String> execute(String input) async {
    final query = input.trim();

    if (query.isEmpty) {
      return 'Research query is empty.';
    }

    return 'Research tool ready for: $query';
  }
}
