import 'local_research_provider.dart';
import 'research_provider.dart';

/// Research provider that tries an external provider first and falls back
/// to the safe local provider when external research is unavailable.
class FallbackResearchProvider implements ResearchProvider {
  final ResearchProvider primary;
  final ResearchProvider fallback;

  FallbackResearchProvider({
    required this.primary,
    ResearchProvider? fallback,
  }) : fallback = fallback ?? LocalResearchProvider();

  @override
  String get name => 'fallback';

  @override
  Future<String> research(String query) async {
    final result = await primary.research(query);

    if (result.contains('RESEARCH STATUS: LIVE')) {
      return result;
    }

    final localResult = await fallback.research(query);

    return [
      localResult,
      '',
      'PRIMARY PROVIDER STATUS',
      result,
    ].join('\n');
  }
}
