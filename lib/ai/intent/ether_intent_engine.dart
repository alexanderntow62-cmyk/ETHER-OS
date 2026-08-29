import 'ether_intent.dart';

class EtherIntentEngine {
  EtherIntent classify(String input) {
    final text = input.trim();
    final lower = text.toLowerCase();

    if (text.isEmpty) {
      return EtherIntent(type: EtherIntentType.unknown, input: text);
    }

    // Memory commands
    if (lower == 'clear memory' ||
        lower == 'forget my name' ||
        lower.startsWith('remember that ') ||
        lower.startsWith('my name is ') ||
        lower.startsWith('i am learning ') ||
        lower.startsWith("i'm learning ") ||
        lower.startsWith('i am building ') ||
        lower.startsWith("i'm building ")) {
      return EtherIntent(type: EtherIntentType.memory, input: text);
    }

    // System actions
    if (lower.startsWith('open ') ||
        lower.startsWith('launch ') ||
        lower.startsWith('start ') ||
        lower.contains('open booking.com') ||
        lower.contains('open settings')) {
      return EtherIntent(type: EtherIntentType.systemAction, input: text);
    }

    // Business actions
    if (lower.contains('business') ||
        lower.contains('make money') ||
        lower.contains('find a customer') ||
        lower.contains('find customers') ||
        lower.contains('business idea')) {
      return EtherIntent(type: EtherIntentType.businessAction, input: text);
    }

    // Calculator / registered skills
    if (RegExp(r'\d+(?:\.\d+)?\s*[+\-*/]\s*\d+(?:\.\d+)?').hasMatch(lower) ||
        lower.startsWith('calculate ') ||
        lower.startsWith('compute ') ||
        lower.contains(' plus ') ||
        lower.contains(' minus ') ||
        lower.contains(' times ') ||
        lower.contains(' multiplied by ') ||
        lower.contains(' divided by ')) {
      return EtherIntent(type: EtherIntentType.skill, input: text);
    }

    // Normal conversation / questions
    if (lower == 'hello' ||
        lower == 'hi' ||
        lower == 'hey' ||
        lower.contains('?') ||
        lower.startsWith('what ') ||
        lower.startsWith('why ') ||
        lower.startsWith('how ') ||
        lower.startsWith('who ') ||
        lower.startsWith('where ') ||
        lower.startsWith('when ') ||
        lower.startsWith('can you ') ||
        lower.startsWith('tell me ')) {
      return EtherIntent(type: EtherIntentType.conversation, input: text);
    }

    // Unknown requests can still go to the AI.
    return EtherIntent(type: EtherIntentType.unknown, input: text);
  }
}
