import 'package:flutter_test/flutter_test.dart';
import 'package:ether_os/tools/research/local_research_provider.dart';
import 'package:ether_os/tools/research/research_provider.dart';

void main() {
  test('local research provider has correct identity', () {
    final provider = LocalResearchProvider();

    expect(provider.name, 'local');
  });

  test('local research provider rejects empty queries', () async {
    final provider = LocalResearchProvider();

    final result = await provider.research('');

    expect(result, 'Research query is empty.');
  });

  test('local research provider does not falsely claim live research', () async {
    final provider = LocalResearchProvider();

    final result = await provider.research('AI business opportunities');

    expect(result, contains('AI business opportunities'));
    expect(result, contains('FALLBACK'));
    expect(result, contains('No external research provider is configured.'));
  });

  test('research provider abstraction can be implemented', () async {
    final provider = _TestProvider();

    final result = await provider.research('test query');

    expect(result, 'TEST RESULT: test query');
  });
}

class _TestProvider implements ResearchProvider {
  @override
  String get name => 'test';

  @override
  Future<String> research(String query) async {
    return 'TEST RESULT: $query';
  }
}
