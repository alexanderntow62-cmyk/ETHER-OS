import 'package:flutter_test/flutter_test.dart';
import 'package:ether_os/business/ether_business_operator.dart';
import 'package:ether_os/business/business_task.dart';

void main() {
  test(
    'ETHER Business Operator runs autonomous business preparation',
    () async {
      final operator = EtherBusinessOperator();

      final result = await operator.start('Start a dropshipping business');

      expect(result, contains('ETHER BUSINESS OPERATOR'));
      expect(result, contains('AUTONOMOUS WORKFLOW'));
      expect(result, contains('PRODUCT RESEARCH'));
      expect(result, contains('RECOMMENDED PRODUCT'));
      expect(result, contains('Portable LED Desk Lamp'));
      expect(result, contains('FINANCIAL BOUNDARY'));
      expect(result, contains('No purchases'));
    },
  );

  test('ETHER Business Operator blocks financial actions', () async {
    final operator = EtherBusinessOperator();

    final task = operator.createFinancialAction(
      goal: 'Pay for a store subscription',
    );

    final result = await operator.business.execute(task);

    expect(task.status, BusinessTaskStatus.waitingApproval);
    expect(result, contains('APPROVAL REQUIRED'));
    expect(result, contains('financial actions'));
  });
}
