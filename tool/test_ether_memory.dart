import '../lib/ai/brain/ether_brain.dart';

Future<void> main() async {
  final brain = EtherBrain();

  await brain.initialize();

  final tests = [
    'My name is Alexander',
    'What is my name?',
    'I work as an electrician',
    'What is my work?',
    'I live in Ghana',
    'Where do I live?',
    'My favorite language is Japanese',
    'What is my favorite language?',
    'My goal is to build ETHER-OS',
    'What is my goal?',
    'What do you remember?',
  ];

  for (final input in tests) {
    final response = await brain.think(input);
    print('USER: $input');
    print('ETHER: $response');
    print('---');
  }
}
