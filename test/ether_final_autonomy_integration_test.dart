import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../lib/agent/ether_agent.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, Object>{});
  TestWidgetsFlutterBinding.ensureInitialized();
  group('ETHER Final Autonomy Integration', () {
    late EtherAgent agent;

    setUp(() {
      agent = EtherAgent();
    });

    test('ETHER initializes and responds to a normal command', () async {
      await agent.initialize();

      final response = await agent.run(
        'Research a business opportunity',
      );

      expect(response.trim().isNotEmpty, isTrue);
    });

    test('ETHER refuses financial execution without approval', () async {
      await agent.initialize();

      final response = await agent.run(
        'Buy advertising for the business',
      );

      final lower = response.toLowerCase();

      expect(
        lower.contains('approval') ||
            lower.contains('financial') ||
            lower.contains('stopped'),
        isTrue,
      );
    });

    test('ETHER handles empty input safely', () async {
      await agent.initialize();

      final response = await agent.run('');

      expect(response.trim().isNotEmpty, isTrue);
    });
  });
}
