import '../../capabilities/generation/ether_generation_service.dart';
import '../core/ether_skill.dart';

class GenerationSkill implements EtherSkill {
  final EtherGenerationService generation;

  GenerationSkill({EtherGenerationService? generation})
    : generation = generation ?? EtherGenerationService();

  @override
  String get id => 'generation';

  @override
  String get name => 'Generation';

  @override
  String get description =>
      'Generates images and videos from natural-language prompts.';

  @override
  bool canHandle(String input) {
    final lower = input.trim().toLowerCase();

    return lower.contains('generate image') ||
        lower.contains('generate an image') ||
        lower.contains('create an image') ||
        lower.contains('make an image') ||
        lower.contains('generate video') ||
        lower.contains('generate a video') ||
        lower.contains('create a video') ||
        lower.contains('make a video');
  }

  @override
  Future<String> execute(String input) async {
    final text = input.trim();
    final lower = text.toLowerCase();

    if (text.isEmpty) {
      return 'Please tell me what you want me to generate.';
    }

    final isVideo = lower.contains('video');

    final prompt = _extractPrompt(text, isVideo);

    if (prompt.isEmpty) {
      return isVideo
          ? 'Please tell me what video you want me to generate.'
          : 'Please tell me what image you want me to generate.';
    }

    try {
      if (isVideo) {
        final file = await generation.generateVideo(prompt: prompt);

        return 'Video generated successfully.\n'
            'File: ${file.path}';
      }

      final file = await generation.generateImage(prompt: prompt);

      return 'Image generated successfully.\n'
          'File: ${file.path}';
    } catch (e) {
      return 'Generation failed: $e';
    }
  }

  String _extractPrompt(String input, bool isVideo) {
    var prompt = input.trim();

    final patterns = isVideo
        ? <String>[
            'generate a video',
            'generate video',
            'create a video',
            'make a video',
          ]
        : <String>[
            'generate an image',
            'generate image',
            'create an image',
            'make an image',
          ];

    final lower = prompt.toLowerCase();

    for (final pattern in patterns) {
      if (lower.startsWith(pattern)) {
        prompt = prompt.substring(pattern.length).trim();
        break;
      }
    }

    if (prompt.startsWith(':')) {
      prompt = prompt.substring(1).trim();
    }

    return prompt;
  }

  void dispose() {
    generation.close();
  }
}
