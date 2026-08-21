import 'package:flutter_test/flutter_test.dart';

import '../lib/business/business_permission.dart';
import '../lib/business/integrations/business_integration_action_policy.dart';

void main() {
  group('BusinessIntegrationActionPolicy', () {
    const policy = BusinessIntegrationActionPolicy();

    test('WooCommerce read actions are autonomous', () {
      for (final action in [
        'test_connection',
        'get_store',
        'list_products',
        'get_product',
        'list_orders',
      ]) {
        expect(
          policy.classify(
            integrationId: 'woocommerce',
            action: action,
          ),
          BusinessIntegrationActionRisk.autonomous,
        );

        expect(
          policy.permissionFor(
            integrationId: 'woocommerce',
            action: action,
          ),
          BusinessPermission.autonomous,
        );
      }
    });

    test('WooCommerce write actions require approval', () {
      for (final action in [
        'create_product',
        'update_product',
        'create_order',
        'update_order',
      ]) {
        expect(
          policy.classify(
            integrationId: 'woocommerce',
            action: action,
          ),
          BusinessIntegrationActionRisk.approvalRequired,
        );

        expect(
          policy.permissionFor(
            integrationId: 'woocommerce',
            action: action,
          ),
          BusinessPermission.approvalRequired,
        );
      }
    });

    test('WooCommerce financial actions are financial', () {
      for (final action in [
        'delete_product',
        'delete_order',
        'refund',
        'payment',
        'purchase',
        'purchase_inventory',
      ]) {
        expect(
          policy.classify(
            integrationId: 'woocommerce',
            action: action,
          ),
          BusinessIntegrationActionRisk.financial,
        );

        expect(
          policy.permissionFor(
            integrationId: 'woocommerce',
            action: action,
          ),
          BusinessPermission.financial,
        );
      }
    });

    test('unclassified actions default to autonomous', () {
      expect(
        policy.classify(
          integrationId: 'test',
          action: 'sync',
        ),
        BusinessIntegrationActionRisk.autonomous,
      );

      expect(
        policy.permissionFor(
          integrationId: 'test',
          action: 'sync',
        ),
        BusinessPermission.autonomous,
      );
    });
  });
}
