import 'package:flutter_test/flutter_test.dart';
import '../lib/ai/brain/ether_brain.dart';
import '../lib/ai/online/gemini_ai_config.dart';

void main() {
  test('ETHER Brain connects to Gemini AI', () async {
    if (!GeminiAIConfig.hasGeminiKey) {
      return;
    }

    final brain = EtherBrain();

    final response = await brain.think(
      'Reply with exactly: ETHER BRAIN ONLINE',
    );

    expect(response.trim(), isNotEmpty);
    expect(response.toUpperCase(), contains('ETHER BRAIN ONLINE'));
  });
}
