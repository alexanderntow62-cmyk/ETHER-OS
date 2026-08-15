import 'package:flutter_test/flutter_test.dart';
import '../lib/ai/ether_voice.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('ETHER voice exposes speech controls', () {
    final voice = EtherVoice();

    expect(voice.isSpeaking, isFalse);
    expect(voice.isPaused, isFalse);
  });
}
