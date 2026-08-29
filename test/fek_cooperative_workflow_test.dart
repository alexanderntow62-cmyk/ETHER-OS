import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../lib/fek/ether_fek_coordinator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  test(
    'FEK cooperative workflow falls back to normal processing for non-business requests',
    () async {
      final fek = EtherFEKCoordinator();

      final result = await fek.processAutonomousBusiness(
        'calculate 25 times 4',
      );

      expect(result, contains('100'));
    },
  );

  test(
    'FEK cooperative workflow uses Business FEK for business requests',
    () async {
      final fek = EtherFEKCoordinator();

      final result = await fek.processAutonomousBusiness(
        'start a dropshipping business',
      );

      expect(result, contains('ETHER BUSINESS AUTONOMY LOOP'));
      expect(result, contains('FEK-3 created the authoritative business plan.'));
    },
  );

  test(
    'FEK cooperative workflow preserves financial safety',
    () async {
      final fek = EtherFEKCoordinator();

      final result = await fek.processAutonomousBusiness(
        'pay for advertising for my business',
      );

      expect(result.toLowerCase(), contains('approval'));
    },
  );

  test(
    'FEK autonomous business loop routes permitted execution through FEK-2',
    () async {
      final fek = EtherFEKCoordinator();

      final result = await fek.runAutonomousBusinessLoop(
        'start a dropshipping business',
      );

      expect(result, contains('ETHER BUSINESS AUTONOMY LOOP'));
      expect(result, contains('FEK-2'));
    },
  );
}
