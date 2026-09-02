import 'ether_ai_engine.dart';
import '../../api/ether_api_client.dart';

/// AI engine that routes ETHER's general intelligence through
/// the ETHER API instead of calling a provider directly.
///
/// This keeps provider credentials out of the normal ETHER
/// conversational path and gives ETHER one API gateway.
class EtherApiAIEngine implements EtherAIEngine {
  final EtherApiClient client;
  final Uri baseUri;
  final String apiKey;

  EtherApiAIEngine({
    required this.client,
    required this.baseUri,
    required this.apiKey,
  });

  Uri _chatUri() {
    final base = baseUri.toString().replaceFirst(RegExp(r'/$'), '');
    return Uri.parse('$base/v1/chat');
  }

  @override
  Future<String> generate({required String message, String? context}) async {
    final result = await client.post(
      _chatUri(),
      headers: {'x-ether-api-key': apiKey},
      body: {
        'message': message,
        if (context != null && context.trim().isNotEmpty) 'context': context,
      },
    );

    if (result is! Map) {
      throw const EtherApiException(
        message: 'ETHER API returned an invalid response.',
      );
    }

    final response = result['response'];

    if (response is String && response.trim().isNotEmpty) {
      return response.trim();
    }

    final error = result['error'];

    throw EtherApiException(
      message: error is String ? error : 'ETHER API returned no response.',
    );
  }

  void close() {
    client.close();
  }
}
