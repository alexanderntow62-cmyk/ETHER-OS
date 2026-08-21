import 'business_integration_result.dart';
abstract class BusinessIntegration {
  String get id;
  String get name;

  bool get isConfigured;

  /// Actions this integration actually implements.
  ///
  /// Registration alone does not imply that an action is available.
  Set<String> get supportedActions;

  Future<BusinessIntegrationResult> execute({
    required String action,
    required Map<String, dynamic> parameters,
  });

  Future<bool> testConnection();
}
