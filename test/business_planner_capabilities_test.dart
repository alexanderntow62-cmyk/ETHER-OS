import 'package:flutter_test/flutter_test.dart';

import '../lib/business/business_permission.dart';
import '../lib/business/business_planner.dart';

void main() {
  group('Business planner integration capabilities', () {
    test('plan steps can declare an integration and action', () {
      const step = BusinessPlanStep(
        id: 'woocommerce_products',
        title: 'Retrieve products',
        description: 'Retrieve the current product catalog.',
        integrationId: 'woocommerce',
        action: 'list_products',
      );

      expect(step.integrationId, 'woocommerce');
      expect(step.action, 'list_products');
      expect(step.permission, BusinessPermission.autonomous);
    });

    test('integration capability metadata is optional', () {
      const step = BusinessPlanStep(
        id: 'strategy_1',
        title: 'Create strategy',
        description: 'Develop an actionable business strategy.',
      );

      expect(step.integrationId, isNull);
      expect(step.action, isNull);
    });

    test('financial permission remains independent from integration metadata',
        () {
      const step = BusinessPlanStep(
        id: 'purchase',
        title: 'Purchase inventory',
        description: 'Purchase inventory after user approval.',
        permission: BusinessPermission.financial,
        integrationId: 'woocommerce',
        action: 'create_order',
      );

      expect(step.integrationId, 'woocommerce');
      expect(step.action, 'create_order');
      expect(step.permission, BusinessPermission.financial);
    });

    test('existing planner plans remain compatible', () {
      final planner = EtherBusinessPlanner();
      final plan = planner.createPlan('build a dropshipping business');

      expect(plan.steps, isNotEmpty);

      for (final step in plan.steps) {
        expect(step.integrationId, isNull);
        expect(step.action, isNull);
      }
    });
  });
}
