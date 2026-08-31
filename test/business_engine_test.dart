import 'package:flutter_test/flutter_test.dart';
import 'package:ether_os/business/ether_business_engine.dart';
import 'package:ether_os/business/business_task.dart';

void main() {
  test(
    'ETHER Business Engine executes autonomous work and stops at finance',
    () async {
      final engine = EtherBusinessEngine();

      final task = engine.createTask(
        id: 'business_test_1',
        goal: 'Start a dropshipping business',
      );

      final result = await engine.execute(task);

      expect(task.status, BusinessTaskStatus.waitingApproval);

      expect(result, contains('BUSINESS EXECUTION'));
      expect(result, contains('Define market'));
      expect(result, contains('Research products'));
      expect(result, contains('Evaluate products'));
      expect(result, contains('Select products'));
      expect(result, contains('Build pricing strategy'));
      expect(result, contains('Prepare marketing strategy'));
      expect(result, contains('STOPPED AT FINANCIAL BOUNDARY'));
      expect(result, contains('APPROVAL REQUIRED'));
      expect(result, contains('FINANCIAL'));
    },
  );
}
