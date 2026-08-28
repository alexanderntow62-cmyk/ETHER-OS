import 'package:flutter_test/flutter_test.dart';
import '../lib/tools/research_tool.dart';

void main() {
  late ResearchTool tool;

  setUp(() {
    tool = ResearchTool();
  });

  test('Research tool has correct identity', () {
    expect(tool.name, 'research');
    expect(
      tool.description,
      contains('external information'),
    );
  });

  test('Research tool handles a query', () async {
    final result = await tool.execute('AI business opportunities');

    expect(
      result,
      contains('AI business opportunities'),
    );
  });

  test('Research tool rejects an empty query', () async {
    final result = await tool.execute('');

    expect(result, 'Research query is empty.');
  });
}
