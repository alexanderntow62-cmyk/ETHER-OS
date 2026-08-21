import 'business_integration.dart';
import 'business_integration_result.dart';

class BusinessIntegrationRegistry {
  final Map<String, BusinessIntegration> _integrations = {};

  BusinessIntegrationRegistry({
    Iterable<BusinessIntegration> integrations = const [],
  }) {
    for (final integration in integrations) {
      register(integration);
    }
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
