import 'dart:io';

import 'package:http/http.dart' as http;

import 'ether_generation_provider.dart';

class EtherPollinationsProvider implements EtherGenerationProvider {
  final String? apiKey;
  final http.Client client;

  EtherPollinationsProvider({this.apiKey, http.Client? client})
    : client = client ?? http.Client();

  static const String _baseUrl = 'https://gen.pollinations.ai';

  Map<String, String> get _headers {
    final key = apiKey?.trim();

    if (key == null || key.isEmpty) {
      return {};
    }

    return {'Authorization': 'Bearer $key'};
  }

  @override
  Future<File> generateImage({
    required String prompt,
    String? outputPath,
    String aspectRatio = '1:1',
  }) async {
    final cleanPrompt = prompt.trim();

    if (cleanPrompt.isEmpty) {
      throw ArgumentError('ETHER: Image prompt cannot be empty.');
    }

    final encodedPrompt = Uri.encodeComponent(cleanPrompt);

    final uri = Uri.parse(
      '$_baseUrl/image/$encodedPrompt'
      '?model=flux'
      '&aspectRatio=$aspectRatio',
    );

    final response = await client.get(uri, headers: _headers);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StateError(
        'ETHER image generation failed '
        '(${response.statusCode}): ${response.body}',
      );
    }

    final path =
        outputPath ??
        '${Directory.systemTemp.path}/'
            'ether_image_'
            '${DateTime.now().millisecondsSinceEpoch}.jpg';

    final file = File(path);

    await file.writeAsBytes(response.bodyBytes, flush: true);

    return file;
  }

  @override
  Future<File> generateVideo({
    required String prompt,
    String? outputPath,
    int duration = 5,
  }) async {
    final cleanPrompt = prompt.trim();

    if (cleanPrompt.isEmpty) {
      throw ArgumentError('ETHER: Video prompt cannot be empty.');
    }

    if (duration <= 0) {
      throw ArgumentError('ETHER: Video duration must be greater than zero.');
    }

    final encodedPrompt = Uri.encodeComponent(cleanPrompt);

    final uri = Uri.parse(
      '$_baseUrl/video/$encodedPrompt'
      '?model=veo'
      '&duration=$duration',
    );

    final response = await client.get(uri, headers: _headers);

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

    return file;
  }

  void close() {
    client.close();
  }
}
