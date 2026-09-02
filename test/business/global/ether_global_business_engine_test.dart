import 'package:flutter_test/flutter_test.dart';
import 'package:ether_os/business/global/ether_global_business_engine.dart';

void main() {
  group('ETHER Global Business Engine', () {
    test('creates a global business review', () {
      final engine = EtherGlobalBusinessEngine();

      final review = engine.reviewBusiness();

      expect(review, contains('ETHER GLOBAL BUSINESS REVIEW'));
      expect(review, contains('MISSION PHASES:'));
      expect(review, contains('FINANCIAL SAFETY:'));
      expect(review, contains('Financial commitments require user approval.'));
    });

    test('generates autonomous business tasks', () {
      final engine = EtherGlobalBusinessEngine();

      final tasks = engine.generateInitialTasks();

      expect(tasks, isNotEmpty);
      expect(engine.pendingTasks, isNotEmpty);
      expect(engine.nextTask, isNotNull);
    });

    test('records measurements and evaluates scaling', () {
      final engine = EtherGlobalBusinessEngine();

      final business = engine.creator.createBestBusiness();

      expect(business, isNotNull);

      engine.recordMeasurement(
        businessId: business!.opportunity.id,
        revenue: 1000,
        costs: 400,
        customers: 25,
        completedTasks: 10,
      );

      final decision = engine.evaluateScaling();

      expect(decision.shouldScale, isTrue);
      expect(decision.actions, isNotEmpty);
    });

    test('does not recommend scaling without customers', () {
      final engine = EtherGlobalBusinessEngine();

      final business = engine.creator.createBestBusiness();

      expect(business, isNotNull);

      engine.recordMeasurement(
        businessId: business!.opportunity.id,
        revenue: 0,
        costs: 0,
        customers: 0,
      );

      final decision = engine.evaluateScaling();

      expect(decision.shouldScale, isFalse);
    });
  });
}
