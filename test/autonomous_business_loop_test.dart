import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../lib/fek/ether_fek_coordinator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  test('autonomous business loop is available', () async {
    final fek = EtherFEKCoordinator();

    final result = await fek.runAutonomousBusinessLoop(
      'start a dropshipping business',
    );

    expect(result, contains('ETHER BUSINESS AUTONOMY LOOP'));
    expect(result, contains('Goal: start a dropshipping business'));
    expect(result, contains('OBSERVE'));
    expect(result, contains('DECIDE'));
    expect(result, contains('PLAN + EXECUTE'));
    expect(result, contains('MEASURE'));
    expect(result, contains('LEARN'));
  });

  test('autonomous business loop stops at financial boundary', () async {
    final fek = EtherFEKCoordinator();

    final result = await fek.runAutonomousBusinessLoop(
      'start a dropshipping business',
    );

    expect(result, contains('STOPPED AT FINANCIAL BOUNDARY'));
    expect(result, contains('APPROVAL REQUIRED'));
    expect(result, contains('FINANCIAL'));
    expect(
      result,
      contains(
        'No purchases, payments, subscriptions, or financial commitments were made.',
      ),
    );
    expect(result.toLowerCase(), contains('approval'));
  });

  test('non-business request still uses normal FEK routing', () async {
    final fek = EtherFEKCoordinator();

    final result = await fek.runAutonomousBusinessLoop('calculate 25 times 4');

    expect(result, contains('100'));
  });
}
