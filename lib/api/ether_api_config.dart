import 'package:http/http.dart' as http;

import 'ether_api_client.dart';
import '../ai/online/ether_api_ai_engine.dart';

class EtherApiConfig {
  /// Override these at build time:
  ///
  /// --dart-define=ETHER_API_BASE_URL=https://your-server
  /// --dart-define=ETHER_API_KEY=your-key
  ///
  /// For the embedded local development server:
  /// http://127.0.0.1:8787
  static const String baseUrl = String.fromEnvironment(
    'ETHER_API_BASE_URL',
    defaultValue: 'http://127.0.0.1:8787',
  );

  static const String apiKey = String.fromEnvironment(
    'ETHER_API_KEY',
    defaultValue: 'ether-local-dev-key',
  );

  static Uri get baseUri => Uri.parse(baseUrl);

  static EtherApiAIEngine createAIEngine() {
    return EtherApiAIEngine(
      client: EtherApiClient(client: http.Client()),
      baseUri: baseUri,
      apiKey: apiKey,
    );
  }

  static EtherApiClient createClient() {
    return EtherApiClient(client: http.Client());
  }
}
