import 'business_integration.dart';
import 'business_integration_result.dart';
import 'woocommerce_integration.dart';
import 'shopify_integration.dart';
import 'printful_integration.dart';

class BusinessIntegrationRegistry {
  final Map<String, BusinessIntegration> _integrations = {};

  BusinessIntegrationRegistry({
    Iterable<BusinessIntegration>? integrations,
  }) {
    final defaults = integrations ??
        <BusinessIntegration>[
          WooCommerceIntegration(),
          ShopifyIntegration(),
          PrintfulIntegration(),
        ];

    for (final integration in defaults) {
      register(integration);
    }
  }

  /// Creates a registry with integrations loaded from secure storage.
  ///
  /// Existing constructor behavior remains unchanged so tests and callers
  /// that provide integrations directly continue to work.
  static Future<BusinessIntegrationRegistry> fromSecureStorage() async {
    final registry = BusinessIntegrationRegistry(
      integrations: const [],
    );

    registry.register(
      await WooCommerceIntegration.fromSecureStorage(),
    );

    // Shopify and Printful remain available with their existing
    // configuration paths until their secure-storage loaders are added.
    registry.register(const ShopifyIntegration());
    registry.register(const PrintfulIntegration());

    return registry;
  }

  void register(BusinessIntegration integration) {
    _integrations[integration.id] = integration;
  }

  BusinessIntegration? get(String id) => _integrations[id];

  List<BusinessIntegration> get integrations =>
      List.unmodifiable(_integrations.values);

  List<BusinessIntegration> get configuredIntegrations =>
      List.unmodifiable(
        _integrations.values.where((integration) => integration.isConfigured),
      );

  bool contains(String id) => _integrations.containsKey(id);

  Set<String> supportedActions(String id) {
    return get(id)?.supportedActions ?? const {};
  }

  bool supportsAction({
    required String integrationId,
    required String action,
  }) {
    final integration = get(integrationId);
    if (integration == null) {
      return false;
    }

    return integration.supportedActions.contains(action);
  }

  Future<bool> testConnection(String id) async {
    final integration = get(id);

    if (integration == null) {
      return false;
    }

    return integration.testConnection();
  }

  Future<BusinessIntegrationResult> execute({
    required String integrationId,
    required String action,
    Map<String, dynamic> parameters = const {},
  }) async {
    final integration = get(integrationId);

    if (integration == null) {
      return BusinessIntegrationResult.failure(
        integration: integrationId,
        action: action,
        message: 'Integration "$integrationId" is not registered.',
      );
    }

    return integration.execute(
      action: action,
      parameters: parameters,
    );
  }
}
