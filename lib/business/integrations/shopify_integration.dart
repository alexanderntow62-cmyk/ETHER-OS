import 'business_integration.dart';
import 'business_integration_result.dart';

class ShopifyIntegration implements BusinessIntegration {
  final String? storeUrl;
  final String? accessToken;

  const ShopifyIntegration({
    this.storeUrl,
    this.accessToken,
  });

  @override
  String get id => 'shopify';

  @override
  String get name => 'Shopify';

  @override
  bool get isConfigured =>
      storeUrl != null &&
      storeUrl!.trim().isNotEmpty &&
      accessToken != null &&
      accessToken!.trim().isNotEmpty;

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
        message: 'Shopify integration is not configured.',
      );
    }

    return BusinessIntegrationResult.failure(
      integration: id,
      action: action,
      message: 'Shopify action is not connected to a live API yet.',
    );
  }
}
