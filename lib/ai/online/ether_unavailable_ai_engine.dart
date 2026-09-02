import 'ether_ai_engine.dart';

class EtherUnavailableAIEngine implements EtherAIEngine {
  const EtherUnavailableAIEngine();

  @override
  Future<String> generate({required String message, String? context}) async {
    return 'ETHER API provider is not configured. Configure GEMINI_API_KEY on the ETHER API server.';
  }
}
