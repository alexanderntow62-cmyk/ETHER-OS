import 'ether_tool.dart';
import 'research/research_provider.dart';
import 'research/local_research_provider.dart';

/// ETHER's research tool.
///
/// This is the external-information interface used by ResearchSkill.
/// The tool delegates information gathering to a ResearchProvider.
/// The tool itself does not make business decisions.
class ResearchTool implements EtherTool {
  final ResearchProvider provider;

  ResearchTool({ResearchProvider? provider})
    : provider = provider ?? LocalResearchProvider();

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

    // Preserve the existing user-facing query behavior while routing
    // research through the provider abstraction.
    return provider.research(query);
  }
}
