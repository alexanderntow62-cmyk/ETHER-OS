import 'business_integration.dart';
import 'business_integration_result.dart';

class WooCommerceIntegration implements BusinessIntegration {
  final String? storeUrl;
  final String? consumerKey;
  final String? consumerSecret;

  const WooCommerceIntegration({
    this.storeUrl,
    this.consumerKey,
    this.consumerSecret,
  });

  @override
  String get id => 'woocommerce';

  @override
  String get name => 'WooCommerce';

  @override
  bool get isConfigured =>
      storeUrl != null &&
      storeUrl!.trim().isNotEmpty &&
      consumerKey != null &&
      consumerKey!.trim().isNotEmpty &&
      consumerSecret != null &&
      consumerSecret!.trim().isNotEmpty;

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
        message: 'WooCommerce integration is not configured.',
      );
    }

    return BusinessIntegrationResult.failure(
      integration: id,
      action: action,
      message: 'WooCommerce action is not connected to a live API yet.',
    );
  }
}
