import 'package:flutter_test/flutter_test.dart';

import '../lib/business/integrations/business_integration.dart';
import '../lib/business/integrations/business_integration_registry.dart';
import '../lib/business/integrations/business_integration_result.dart';
import '../lib/business/integrations/woocommerce_integration.dart';

class FakeBusinessIntegration implements BusinessIntegration {
  @override
  final String id;

  @override
  final String name;

  @override
  final bool isConfigured;

  FakeBusinessIntegration({
    required this.id,
    required this.name,
    required this.isConfigured,
  });

  @override
  Future<bool> testConnection() async => isConfigured;

  @override
  Future<BusinessIntegrationResult> execute({
    required String action,
    required Map<String, dynamic> parameters,
  }) async {
    return BusinessIntegrationResult.success(
      integration: id,
      action: action,
      message: 'Fake integration executed.',
    );
  }
}

void main() {
  group('BusinessIntegrationRegistry', () {
    test('registers and retrieves integrations', () {
      final integration = WooCommerceIntegration();

      final registry = BusinessIntegrationRegistry(
        integrations: [integration],
      );

      expect(registry.contains('woocommerce'), isTrue);
      expect(registry.get('woocommerce'), same(integration));
      expect(registry.integrations, hasLength(1));
    });

    test('reports configured integrations correctly', () {
      final configured = WooCommerceIntegration(
        storeUrl: 'https://example.com',
        consumerKey: 'ck_test',
        consumerSecret: 'cs_test',
      );

      final unconfigured = FakeBusinessIntegration(
        id: 'fake',
        name: 'Fake',
        isConfigured: false,
      );

      final registry = BusinessIntegrationRegistry(
        integrations: [
          configured,
          unconfigured,
        ],
      );

      expect(registry.integrations, hasLength(2));
      expect(registry.configuredIntegrations, hasLength(1));
      expect(
        registry.configuredIntegrations.first.id,
        'woocommerce',
      );
    });

    test('unknown integration returns failure', () async {
      final registry = BusinessIntegrationRegistry();

      final result = await registry.execute(
        integrationId: 'unknown',
        action: 'test',
      );

      expect(result.success, isFalse);
      expect(result.integration, 'unknown');
    });

    test('delegates execution to registered integration', () async {
      final integration = WooCommerceIntegration();

      final registry = BusinessIntegrationRegistry(
        integrations: [integration],
      );

      final result = await registry.execute(
        integrationId: 'woocommerce',
        action: 'create_product',
      );

      expect(result.success, isFalse);
      expect(
        result.message,
        'WooCommerce integration is not configured.',
      );
    });

    test('delegates execution to a configured integration', () async {
      final integration = FakeBusinessIntegration(
        id: 'fake',
        name: 'Fake',
        isConfigured: true,
      );

      final registry = BusinessIntegrationRegistry(
        integrations: [integration],
      );

      final result = await registry.execute(
        integrationId: 'fake',
        action: 'test_action',
      );

      expect(result.success, isTrue);
      expect(result.integration, 'fake');
      expect(result.action, 'test_action');
    });
  });
}
