import 'package:flutter_test/flutter_test.dart';
import 'package:ether_os/business/business_control_center.dart';

void main() {
  test('ETHER Control Center manages businesses', () {
    final center = BusinessControlCenter();

    center.addBusiness('Dropshipping Store');
    center.addBusiness('Affiliate Business');

    expect(center.businesses.length, 2);
    expect(center.businesses, contains('Dropshipping Store'));
    expect(center.businesses, contains('Affiliate Business'));
  });

  test(
    'ETHER Control Center creates an approval item for financial work',
    () async {
      final center = BusinessControlCenter();

      center.addBusiness('Dropshipping Store');

      final result = await center.runBusinessCheck(
        'Start a dropshipping business',
      );

      expect(result, contains('FINANCIAL'));
      expect(center.approvalQueue.pendingCount, greaterThan(0));
    },
  );

  test('ETHER Control Center dashboard reports approval items', () async {
    final center = BusinessControlCenter();

    center.addBusiness('Dropshipping Store');

    await center.runBusinessCheck('Start a dropshipping business');

    final dashboard = center.dashboard();

    expect(dashboard, contains('ETHER BUSINESS CONTROL CENTER'));
    expect(dashboard, contains('Dropshipping Store'));
    expect(dashboard, contains('NEEDS YOUR ATTENTION'));
    expect(dashboard, contains('approval item'));
  });
}
