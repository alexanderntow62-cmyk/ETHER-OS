import 'business_integration.dart';
import 'business_integration_result.dart';

class PrintfulIntegration implements BusinessIntegration {
  final String? apiKey;

  const PrintfulIntegration({
    this.apiKey,
  });

  @override
  String get id => 'printful';

  @override
  String get name => 'Printful';

  @override
  Set<String> get supportedActions => const {};

  @override
  bool get isConfigured =>
      apiKey != null && apiKey!.trim().isNotEmpty;

  @override
  Future<bool> testConnection() async {
    if (!isConfigured) {
      return false;
    }

    return true;
  }

  @override
  Future<BusinessIntegrationResult> execute({
    required String action,
    required Map<String, dynamic> parameters,
  }) async {
    if (!isConfigured) {
      return BusinessIntegrationResult.failure(
        integration: id,
        action: action,
        message: 'Printful integration is not configured.',
      );
    }

    return BusinessIntegrationResult.failure(
      integration: id,
      action: action,
      message: 'Printful action is not connected to a live API yet.',
    );
  }
}
