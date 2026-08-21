import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ether_ai_engine.dart';

class GeminiEtherEngine implements EtherAIEngine {
  final String apiKey;
  final String model;

  GeminiEtherEngine({required this.apiKey, this.model = 'gemini-3.6-flash'});

  static const String _systemInstruction = '''
You are ETHER, the intelligence core of ETHER-OS.
ETHER-OS is a project created and engineered by Alexander Ntow.

Your identity:
- Your name is ETHER.
- You are the intelligence core of ETHER-OS.
- ETHER-OS is an AI operating-system project being developed by Alexander Ntow.
- Do not invent a different creator.
- If asked who created ETHER-OS, identify Alexander Ntow as its creator.
- If asked who you are, explain that you are ETHER, the intelligence core operating inside ETHER-OS.

Behavior:
- Be accurate and honest.
- Do not claim capabilities you do not actually have.
- Do not fabricate facts.
- Use conversation context when it is provided.
- Answer naturally and clearly.
''';

  @override
  Future<String> generate({required String message, String? context}) async {
    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/'
      '$model:generateContent',
    );

    final contents = <Map<String, dynamic>>[];

    contents.add({
      'role': 'user',
      'parts': [
        {'text': _systemInstruction},
      ],
    });

    if (context != null && context.trim().isNotEmpty) {
      contents.add({
        'role': 'user',
        'parts': [
          {'text': 'Recent conversation context for ETHER-OS:\n$context'},
        ],
      });
    }

    contents.add({
      'role': 'user',
      'parts': [
        {'text': message},
      ],
    });

    final body = jsonEncode({'contents': contents});

    Exception? lastError;

    for (var attempt = 1; attempt <= 3; attempt++) {
      try {
        final response = await http
            .post(
              uri,
              headers: {
                'Content-Type': 'application/json',
                'x-goog-api-key': apiKey,
              },
              body: body,
            )
            .timeout(const Duration(seconds: 60));

        if (response.statusCode >= 200 && response.statusCode < 300) {
          final data = jsonDecode(response.body) as Map<String, dynamic>;

          final candidates = data['candidates'];

          if (candidates is List && candidates.isNotEmpty) {
            final candidate = candidates.first as Map<String, dynamic>;

            final content = candidate['content'];

            if (content is Map<String, dynamic>) {
              final parts = content['parts'];

              if (parts is List) {
                for (final part in parts) {
                  if (part is Map<String, dynamic>) {
                    final text = part['text'];

                    if (text is String && text.trim().isNotEmpty) {
                      return text.trim();
                    }
                  }
                }
              }
            }
          }

          return 'Gemini returned no text response.';
        }

        final error = Exception(
          'Gemini request failed (${response.statusCode}): '
          '${response.body}',
        );

        lastError = error;

        // 503 = temporary service unavailability.
        // Retry instead of immediately failing ETHER.
        if (response.statusCode == 503 && attempt < 3) {
          await Future.delayed(Duration(seconds: attempt * 2));
          continue;
        }

        throw error;
      } on TimeoutException catch (e) {
        lastError = Exception('Gemini request timed out: $e');

        if (attempt < 3) {
          await Future.delayed(Duration(seconds: attempt * 2));
          continue;
        }

        throw lastError;
      } catch (e) {
        lastError = Exception(e.toString());

        if (attempt < 3) {
          await Future.delayed(Duration(seconds: attempt * 2));
          continue;
        }

        throw lastError;
      }
    }

    throw lastError ?? Exception('Gemini request failed.');
  }
}
