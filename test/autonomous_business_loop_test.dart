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

    expect(result, contains('AUTONOMOUS BUSINESS LOOP'));
    expect(result, contains('Goal: start a dropshipping business'));
    expect(result, contains('LOOP'));
  });

  test('autonomous business loop stops at financial boundary', () async {
    final fek = EtherFEKCoordinator();

    final result = await fek.runAutonomousBusinessLoop(
      'start a dropshipping business',
    );

    expect(result, contains('WAITING FOR APPROVAL'));
    expect(result, contains('FINANCIAL'));
    expect(result.toLowerCase(), contains('approval'));
    expect(result, contains('Financial actions performed: 0'));
  });

  test('non-business request still uses normal FEK routing', () async {
    final fek = EtherFEKCoordinator();

    final result = await fek.runAutonomousBusinessLoop(
      'calculate 25 times 4',
    );

    expect(result, contains('100'));
  });
}
