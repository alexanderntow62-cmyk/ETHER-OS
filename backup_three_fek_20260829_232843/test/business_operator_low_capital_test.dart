import 'package:flutter_test/flutter_test.dart';
import '../lib/business/ether_business_operator.dart';

void main() {
  test(
    'ETHER Business Operator identifies low-capital opportunities',
    () async {
      final operator = EtherBusinessOperator();

      final result = await operator.start(
        'Find a business I can start with little or no money',
      );

      expect(result, contains('ETHER BUSINESS OPERATOR'));
      expect(result, contains('LOW-CAPITAL'));
      expect(result, contains('FINANCIAL SAFETY'));
      expect(result, contains('approval'));
    },
  );
}
