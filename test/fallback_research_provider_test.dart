import 'package:flutter_test/flutter_test.dart';

import 'package:ether_os/tools/research/fallback_research_provider.dart';
import 'package:ether_os/tools/research/research_provider.dart';

void main() {
  test('fallback provider returns primary live result', () async {
    final provider = FallbackResearchProvider(
      primary: _TestProvider(result: 'RESEARCH STATUS: LIVE\nLive result'),
    );

    final result = await provider.research('AI');

    expect(result, contains('RESEARCH STATUS: LIVE'));
    expect(result, contains('Live result'));
  });

  test('fallback provider uses local fallback after primary failure', () async {
    final provider = FallbackResearchProvider(
      primary: _TestProvider(
        result: 'RESEARCH STATUS: ERROR\nProvider unavailable',
      ),
    );

    final result = await provider.research('AI business');

    expect(result, contains('RESEARCH PROVIDER: LOCAL'));
    expect(result, contains('RESEARCH STATUS: FALLBACK'));
    expect(result, contains('AI business'));
    expect(result, contains('PRIMARY PROVIDER STATUS'));
  });
}

class _TestProvider implements ResearchProvider {
  final String result;

  _TestProvider({required this.result});

  @override
  String get name => 'test';

  @override
  Future<String> research(String query) async {
    return result;
  }
}
