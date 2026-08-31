import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class EtherGeneratedImage {
  final File file;
  final String? text;

  const EtherGeneratedImage({required this.file, this.text});
}

class EtherImageGenerationService {
  final String apiKey;
  final String model;
  final http.Client client;

  EtherImageGenerationService({
    required this.apiKey,
    this.model = 'gemini-3.1-flash-image',
    http.Client? client,
  }) : client = client ?? http.Client();

  Future<EtherGeneratedImage> generate({
    required String prompt,
    String? outputPath,
    String aspectRatio = '1:1',
    String imageSize = '1K',
  }) async {
    final key = apiKey.trim();

    if (key.isEmpty) {
      throw StateError('ETHER: Gemini API key is not configured.');
    }

    if (prompt.trim().isEmpty) {
      throw ArgumentError('ETHER: Image prompt cannot be empty.');
    }

    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/interactions',
    );

    final response = await client.post(
      uri,
      headers: {'Content-Type': 'application/json', 'x-goog-api-key': key},
      body: jsonEncode({
        'model': model,
        'input': prompt.trim(),
        'response_format': {
          'type': 'image',
          'aspect_ratio': aspectRatio,
          'image_size': imageSize,
        },
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StateError(
        'ETHER image generation failed '
        '(${response.statusCode}): ${response.body}',
      );
    }

    final data = jsonDecode(response.body);

    final bytes = _findImageBytes(data);

    if (bytes == null || bytes.isEmpty) {
      throw StateError('ETHER: Image generation returned no image data.');
    }

    final path =
        outputPath ??
        '${Directory.systemTemp.path}/'
            'ether_image_${DateTime.now().millisecondsSinceEpoch}.png';

    final file = File(path);
    await file.writeAsBytes(bytes, flush: true);

    return EtherGeneratedImage(file: file, text: _findText(data));
  }

  List<int>? _findImageBytes(dynamic data) {
    if (data is! Map) return null;

    final steps = data['steps'];

    if (steps is List) {
      for (final step in steps) {
        if (step is! Map) continue;

        final content = step['content'];

        if (content is List) {
          for (final block in content) {
            if (block is! Map) continue;

            if (block['type'] == 'image' && block['data'] is String) {
              try {
                return base64Decode(block['data'] as String);
              } catch (_) {
                return null;
              }
            }
          }
        }
      }
    }

    final outputImage = data['output_image'];

    if (outputImage is Map && outputImage['data'] is String) {
      try {
        return base64Decode(outputImage['data'] as String);
      } catch (_) {
        return null;
      }
    }

    return null;
  }

  String? _findText(dynamic data) {
    if (data is! Map) return null;

    final steps = data['steps'];

    if (steps is List) {
      for (final step in steps) {
        if (step is! Map) continue;

        final content = step['content'];

        if (content is List) {
          for (final block in content) {
            if (block is Map &&
                block['type'] == 'text' &&
                block['text'] is String) {
              final text = (block['text'] as String).trim();

              if (text.isNotEmpty) return text;
            }
          }
        }
      }
    }

    return null;
  }

  void close() {
    client.close();
  }
}
