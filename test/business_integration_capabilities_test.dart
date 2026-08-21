import 'package:flutter_test/flutter_test.dart';

import '../lib/business/integrations/business_integration_registry.dart';
import '../lib/business/integrations/woocommerce_integration.dart';

void main() {
  group('Business integration capabilities', () {
    test('WooCommerce declares its implemented actions', () {
      final integration = WooCommerceIntegration();

      expect(
        integration.supportedActions,
        containsAll(<String>[
          'test_connection',
          'get_store',
          'list_products',
          'get_product',
          'list_orders',
        ]),
      );
    });

    test('Shopify is registered but has no live actions yet', () {
      final registry = BusinessIntegrationRegistry();

      expect(registry.contains('shopify'), isTrue);
      expect(registry.supportedActions('shopify'), isEmpty);
    });

    test('Printful is registered but has no live actions yet', () {
      final registry = BusinessIntegrationRegistry();

      expect(registry.contains('printful'), isTrue);
      expect(registry.supportedActions('printful'), isEmpty);
    });

    test('registry reports supported WooCommerce actions', () {
      final registry = BusinessIntegrationRegistry();

      expect(
        registry.supportsAction(
          integrationId: 'woocommerce',
          action: 'list_products',
        ),
        isTrue,
      );

      expect(
        registry.supportsAction(
          integrationId: 'woocommerce',
          action: 'create_product',
        ),
        isFalse,
      );
    });

    test('registry exposes capabilities without enforcing execution policy',
        () {
      final registry = BusinessIntegrationRegistry();

      expect(
        registry.supportsAction(
          integrationId: 'shopify',
          action: 'list_products',
        ),
        isFalse,
      );

      expect(
        registry.supportsAction(
          integrationId: 'woocommerce',
          action: 'list_products',
        ),
        isTrue,
      );
    });

    test('unknown integration has no capabilities', () {
      final registry = BusinessIntegrationRegistry();

      expect(registry.supportedActions('missing'), isEmpty);
      expect(
        registry.supportsAction(
          integrationId: 'missing',
          action: 'anything',
        ),
        isFalse,
      );
    });
  });
}
