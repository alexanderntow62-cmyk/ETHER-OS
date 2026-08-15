import 'dart:convert';

import 'package:http/http.dart' as http;

import 'ether_ai_engine.dart';

class OpenAIEtherEngine implements EtherAIEngine {
  final String apiKey;
  final String model;

  OpenAIEtherEngine({
    required this.apiKey,
    this.model = 'gpt-5-mini',
  });

  @override
  Future<String> generate({
    required String message,
    String? context,
  }) async {
    final uri = Uri.parse('https://api.openai.com/v1/responses');

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': model,
        'input': [
          if (context != null && context.trim().isNotEmpty)
            {
              'role': 'developer',
              'content': [
                {
                  'type': 'input_text',
                  'text': context,
                },
              ],
            },
          {
            'role': 'user',
            'content': [
              {
                'type': 'input_text',
                'text': message,
              },
            ],
          },
        ],
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'AI request failed (${response.statusCode}): ${response.body}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    final outputText = data['output_text'];

    if (outputText is String && outputText.trim().isNotEmpty) {
      return outputText.trim();
    }

    return 'The AI engine returned no text response.';
  }
}
