import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import '../lib/agent/ether_agent.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferencesStorePlatform.instance =
        InMemorySharedPreferencesStore.empty();
  });

  test('ETHER Agent executes calculator skill', () async {
    final agent = EtherAgent();

    final result = await agent.run('calculate 25 times 4');

    expect(result, contains('ETHER AGENT'));
    expect(result, contains('COMPLETED'));
    expect(result, contains('100'));
  });

  test('ETHER Agent can report status', () async {
    final agent = EtherAgent();

    final result = await agent.run('status');

    expect(result, contains('ETHER AGENT'));
    expect(result, contains('COMPLETED'));
    expect(result.toLowerCase(), contains('status'));
  });

  test('ETHER Agent can identify itself', () async {
    final agent = EtherAgent();

    final result = await agent.run('who are you');

    expect(result, contains('ETHER AGENT'));
    expect(result, contains('COMPLETED'));
    expect(result.toLowerCase(), contains('ether'));
  });
}
