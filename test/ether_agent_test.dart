import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:ether_os/agent/ether_agent.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferencesStorePlatform.instance =
        InMemorySharedPreferencesStore.empty();
  });

  test('ETHER Agent answers a calculator request normally', () async {
    final agent = EtherAgent();

    final result = await agent.run('calculate 25 times 4');

    expect(result, contains('100'));
    expect(result, isNot(contains('ETHER AGENT')));
    expect(result, isNot(contains('Goal:')));
    expect(result, isNot(contains('Tasks:')));
    expect(result, isNot(contains('COMPLETED')));
  });

  test('ETHER Agent handles profit and margin calculation normally', () async {
    final agent = EtherAgent();

    final result = await agent.run(
      'calculate profit and margin. Cost 50, selling price 80',
    );

    expect(result, contains('30'));
    expect(result, contains('37.50'));
    expect(result, isNot(contains('ETHER AGENT')));
    expect(result, isNot(contains('Goal:')));
    expect(result, isNot(contains('Tasks:')));
  });
}
