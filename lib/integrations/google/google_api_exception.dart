class GoogleApiException implements Exception {
  final int statusCode;
  final String message;

  const GoogleApiException({required this.statusCode, required this.message});

  @override
  String toString() => 'GoogleApiException($statusCode): $message';
}
