import 'business_integration_result.dart';
abstract class BusinessIntegration {
  String get id;
  String get name;

  bool get isConfigured;

  Future<BusinessIntegrationResult> execute({
    required String action,
    required Map<String, dynamic> parameters,
  });

  Future<bool> testConnection();
}
