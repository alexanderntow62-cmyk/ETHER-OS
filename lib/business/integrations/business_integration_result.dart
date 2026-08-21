class BusinessIntegrationResult {
  final bool success;
  final String integration;
  final String action;
  final String message;
  final Map<String, dynamic> data;

  const BusinessIntegrationResult({
    required this.success,
    required this.integration,
    required this.action,
    required this.message,
    this.data = const {},
  });

  factory BusinessIntegrationResult.success({
    required String integration,
    required String action,
    required String message,
    Map<String, dynamic> data = const {},
  }) {
    return BusinessIntegrationResult(
      success: true,
      integration: integration,
      action: action,
      message: message,
      data: data,
    );
  }

  factory BusinessIntegrationResult.failure({
    required String integration,
    required String action,
    required String message,
    Map<String, dynamic> data = const {},
  }) {
    return BusinessIntegrationResult(
      success: false,
      integration: integration,
      action: action,
      message: message,
      data: data,
    );
  }

  @override
  String toString() {
    return [
      'INTEGRATION: $integration',
      'ACTION: $action',
      'STATUS: ${success ? 'SUCCESS' : 'FAILED'}',
      'MESSAGE: $message',
      if (data.isNotEmpty) 'DATA: $data',
    ].join('\n');
  }
}
