import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:ether_os/agent/ether_agent.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferencesStorePlatform.instance =
        InMemorySharedPreferencesStore.empty();
  });

  test('ETHER real business request', () async {
    final agent = EtherAgent();

    final result = await agent.run(
      'Find me a business I can start with no money',
    );

    print(result);

    expect(result, isNotEmpty);
    expect(result, contains('ETHER BUSINESS OPERATOR'));
    expect(result, contains('AUTONOMOUS POLICY'));
    expect(result, contains('FINANCIAL SAFETY'));
  });
}
