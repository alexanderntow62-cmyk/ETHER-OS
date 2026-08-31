import 'research_provider.dart';

/// Safe local fallback used when no external research provider is configured.
///
/// This provider does not claim to perform live web research.
class LocalResearchProvider implements ResearchProvider {
  @override
  String get name => 'local';

  @override
  Future<String> research(String query) async {
    final trimmed = query.trim();

    if (trimmed.isEmpty) {
      return 'Research query is empty.';
    }

    return [
      'RESEARCH PROVIDER: LOCAL',
      'RESEARCH STATUS: FALLBACK',
      'Query: $trimmed',
      '',
      'No external research provider is configured.',
      'ETHER did not claim live market or web data.',
    ].join('\n');
  }
}
