import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import '../lib/agent/ether_agent.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferencesStorePlatform.instance =
        InMemorySharedPreferencesStore.empty();
  });

  test('ETHER Agent executes a calculator skill', () async {
    final agent = EtherAgent();

    final result = await agent.run('calculate 25 times 4');

    expect(result, contains('100'));
  });

  test('ETHER Brain answers who created ETHER', () async {
    final agent = EtherAgent();

    final result = await agent.run('who created you');

    expect(result.toLowerCase(), contains('alexander ntow'));
    expect(result.toLowerCase(), contains('ether-os'));
  });

  test('ETHER Agent calculates business profit and margin', () async {
    final agent = EtherAgent();

    final result = await agent.run(
      'calculate profit and margin. Cost 50, selling price 80',
    );

    expect(result, contains('Profit: 30'));
    expect(result, contains('Margin: 37.50%'));
    expect(result, contains('Markup: 60%'));
  });
}
