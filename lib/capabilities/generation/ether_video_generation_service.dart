import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class EtherGeneratedVideo {
  final File file;

  const EtherGeneratedVideo({required this.file});
}

class EtherVideoGenerationService {
  final String apiKey;
  final String model;
  final http.Client client;

  EtherVideoGenerationService({
    required this.apiKey,
    this.model = 'ltx-2-5-fast',
    http.Client? client,
  }) : client = client ?? http.Client();

  Future<EtherGeneratedVideo> generate({
    required String prompt,
    String? outputPath,
    int? duration = 6,
    String resolution = '1280x720',
    int fps = 24,
    bool generateAudio = true,
  }) async {
    final key = apiKey.trim();

    if (key.isEmpty) {
      throw StateError('ETHER: LTX API key is not configured.');
    }

    final cleanPrompt = prompt.trim();

    if (cleanPrompt.isEmpty) {
      throw ArgumentError('ETHER: Video prompt cannot be empty.');
    }

    if (duration != null && duration <= 0) {
      throw ArgumentError('ETHER: Video duration must be greater than zero.');
    }

    final uri = Uri.parse('https://api.ltx.io/v1/text-to-video');

    final response = await client.post(
      uri,
      headers: {
        'Authorization': 'Bearer $key',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'prompt': cleanPrompt,
        'model': model,
        'duration': duration,
        'resolution': resolution,
        'fps': fps,
        'generate_audio': generateAudio,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StateError(
        'ETHER video generation failed '
        '(${response.statusCode}): ${response.body}',
      );
    }

    final path =
        outputPath ??
        '${Directory.systemTemp.path}/'
            'ether_video_'
            '${DateTime.now().millisecondsSinceEpoch}.mp4';

    final file = File(path);

    await file.writeAsBytes(response.bodyBytes, flush: true);

    return EtherGeneratedVideo(file: file);
  }

  void close() {
    client.close();
  }
}
