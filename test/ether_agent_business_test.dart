import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import '../lib/agent/ether_agent.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferencesStorePlatform.instance =
        InMemorySharedPreferencesStore.empty();
  });

  test('ETHER Agent routes business requests through BusinessOperator',
      () async {
    final agent = EtherAgent();

    final result = await agent.run('I want a business idea');

    expect(result, isNotEmpty);
    expect(result, contains('ETHER BUSINESS OPERATOR'));
  });

  test('ETHER Agent routes dropshipping requests to business workflow',
      () async {
    final agent = EtherAgent();

    final result =
        await agent.run('Start a dropshipping business');

    expect(result, contains('ETHER BUSINESS OPERATOR'));
    expect(result, contains('AUTONOMOUS WORKFLOW'));
    expect(result, contains('FINANCIAL BOUNDARY'));
  });

  test('ETHER Agent can analyze a low-capital business request',
      () async {
    final agent = EtherAgent();

    final result =
        await agent.run('Give me a business I can start with no money');

    expect(result, contains('ETHER BUSINESS OPERATOR'));
    expect(result, contains('AUTONOMOUS POLICY'));
    expect(result, contains('FINANCIAL SAFETY'));
  });
}
