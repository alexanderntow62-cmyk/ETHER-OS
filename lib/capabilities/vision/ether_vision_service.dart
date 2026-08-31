import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class EtherVisionService {
  final http.Client client;
  final String apiKey;
  final String model;

  EtherVisionService({
    required this.apiKey,
    this.model = 'gemini-3.6-flash',
    http.Client? client,
  }) : client = client ?? http.Client();

  Future<String> analyzeImage({
    required File image,
    required String instruction,
  }) async {
    if (apiKey.trim().isEmpty) {
      throw StateError('ETHER: Gemini API key is not configured.');
    }

    final bytes = await image.readAsBytes();
    final encoded = base64Encode(bytes);

    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/'
      '$model:generateContent',
    );

    final response = await client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'x-goog-api-key': apiKey,
      },
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {
                'text': instruction,
              },
              {
                'inline_data': {
                  'mime_type': _mimeType(image.path),
                  'data': encoded,
                },
              },
            ],
          },
        ],
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StateError(
        'ETHER vision request failed '
        '(${response.statusCode}): ${response.body}',
      );
    }

    final data = jsonDecode(response.body);

    final candidates = data['candidates'];

    if (candidates is List && candidates.isNotEmpty) {
      final content = candidates.first['content'];

      if (content is Map) {
        final parts = content['parts'];

        if (parts is List) {
          for (final part in parts) {
            if (part is Map && part['text'] is String) {
              return part['text'] as String;
            }
          }
        }
      }
    }

    return 'ETHER vision returned no text response.';
  }

  String _mimeType(String path) {
    final lower = path.toLowerCase();

    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    if (lower.endsWith('.gif')) return 'image/gif';

    return 'image/jpeg';
  }

  void close() {
    client.close();
  }
}
