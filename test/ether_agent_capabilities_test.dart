import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import '../lib/agent/ether_agent.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferencesStorePlatform.instance =
        InMemorySharedPreferencesStore.empty();
  });

  test('ETHER Agent executes calculator skill normally', () async {
    final agent = EtherAgent();

    final result = await agent.run('calculate 25 times 4');

    expect(result, contains('100'));
    expect(result, isNot(contains('ETHER AGENT')));
    expect(result, isNot(contains('Goal:')));
    expect(result, isNot(contains('Tasks:')));
    expect(result, isNot(contains('COMPLETED')));
  });

  test('ETHER Agent can report status normally', () async {
    final agent = EtherAgent();

    final result = await agent.run('status');

    expect(result.toLowerCase(), contains('ether'));
    expect(result.toLowerCase(), contains('brain: online'));
    expect(result, isNot(contains('ETHER AGENT')));
    expect(result, isNot(contains('Goal:')));
    expect(result, isNot(contains('Tasks:')));
    expect(result, isNot(contains('COMPLETED')));
  });

  test('ETHER Agent can identify itself normally', () async {
    final agent = EtherAgent();

    final result = await agent.run('who are you');

    expect(result.toLowerCase(), contains('ether'));
    expect(result, isNot(contains('ETHER AGENT')));
    expect(result, isNot(contains('Goal:')));
    expect(result, isNot(contains('Tasks:')));
    expect(result, isNot(contains('COMPLETED')));
  });
}
