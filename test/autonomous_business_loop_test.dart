import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../lib/fek/ether_fek_coordinator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  test(
    'autonomous business loop routes FEK-3 planning through FEK-2',
    () async {
      final fek = EtherFEKCoordinator();

      final result = await fek.runAutonomousBusinessLoop(
        'start a dropshipping business',
      );

      expect(result, contains('ETHER BUSINESS AUTONOMY LOOP'));
      expect(result, contains('Goal: start a dropshipping business'));
      expect(result, contains('OBSERVE'));
      expect(result, contains('DECIDE'));
      expect(result, contains('PLAN'));
      expect(result, contains('FEK-3 → FEK-2'));
      expect(result, contains('FEK-2 EXECUTION'));
      expect(result, contains('FEK COOPERATIVE HANDOFF'));
    },
  );

  test(
    'autonomous business loop stops financial actions before FEK-2',
    () async {
      final fek = EtherFEKCoordinator();

      final result = await fek.runAutonomousBusinessLoop(
        'pay for advertising for my business',
      );

      expect(result, contains('ETHER BUSINESS AUTONOMY LOOP'));
      expect(result, contains('APPROVAL REQUIRED'));
      expect(result.toLowerCase(), contains('financial'));
      expect(result.toLowerCase(), isNot(contains('FEK-2 EXECUTION')));
    },
  );

  test('non-business request still uses normal FEK routing', () async {
    final fek = EtherFEKCoordinator();

    final result = await fek.runAutonomousBusinessLoop('calculate 25 times 4');

    expect(result, contains('100'));
  });
}
