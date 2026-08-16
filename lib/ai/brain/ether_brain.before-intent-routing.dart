import 'ether_memory.dart';
import '../intent/ether_intent.dart';
import '../intent/ether_intent_engine.dart';
import 'ether_persistent_memory.dart';
import '../../skills/core/ether_skill_engine.dart';
import '../online/ether_ai_engine.dart';
import '../online/gemini_ai_config.dart';
import '../online/gemini_ether_engine.dart';

class EtherBrain {
  final String name;
  final EtherMemory memory;
  final EtherIntentEngine intents;
  final EtherSkillEngine skills;
  final EtherPersistentMemory persistentMemory;
  final EtherAIEngine? onlineAI;

  final Map<String, String> _facts = {};

  EtherBrain({
    this.name = 'ETHER',
    EtherMemory? memory,
    EtherIntentEngine? intents,
    EtherSkillEngine? skills,
    EtherPersistentMemory? persistentMemory,
    EtherAIEngine? onlineAI,
  }) : memory = memory ?? EtherMemory(),
         intents = intents ?? EtherIntentEngine(),
       skills = skills ?? EtherSkillEngine(),
       persistentMemory = persistentMemory ?? EtherPersistentMemory(),
       onlineAI =
           onlineAI ??
           (GeminiAIConfig.hasGeminiKey
               ? GeminiEtherEngine(apiKey: GeminiAIConfig.apiKey)
               : null);

  Future<void> initialize() async {
    final savedFacts = await persistentMemory.loadFacts();

    _facts
      ..clear()
      ..addAll(savedFacts);
  }

  Future<String> think(String message) async {
    final input = message.trim();

    if (input.isEmpty) {
      return '$name is ready. Please give me something to work with.';
    }

    memory.rememberUser(input);

    final lower = input.toLowerCase();

    // Clear all persistent and conversation memory.
    if (lower == 'clear memory') {
      memory.clear();
      _facts.clear();

      await persistentMemory.clear();

      final response = '$name memory has been cleared.';
      memory.rememberEther(response);

      return response;
    }

    // Forget the user's saved name.
    if (lower == 'forget my name') {
      if (_facts.remove('name') != null) {
        await persistentMemory.saveFacts(_facts);

        final response = 'I have forgotten your name.';
        memory.rememberEther(response);

        return response;
      }

      final response = 'I do not have your name saved.';
      memory.rememberEther(response);

      return response;
    }

    // Store the user's name.
    if (lower.startsWith('my name is ')) {
      final value = input.substring('my name is '.length).trim();

      late final String response;

      if (value.isNotEmpty) {
        _facts['name'] = value;

        await persistentMemory.saveFacts(_facts);

        response = 'Got it. I will remember that your name is $value.';
      } else {
        response = 'Tell me your name after saying "My name is".';
      }

      memory.rememberEther(response);
      return response;
    }

    // Store a general fact.
    if (lower.startsWith('remember that ')) {
      final fact = input.substring('remember that '.length).trim();

      late final String response;

      if (fact.isNotEmpty) {
        final key = 'fact_${DateTime.now().millisecondsSinceEpoch}';

        _facts[key] = fact;

        await persistentMemory.saveFacts(_facts);

        response = 'Understood. I will remember that.';
      } else {
        response = 'Tell me what you want me to remember.';
      }

      memory.rememberEther(response);
      return response;
    }

    // Remember what the user is learning.
    if (lower.startsWith('i am learning ') ||
        lower.startsWith("i'm learning ") ||
        lower.startsWith('i am currently learning ') ||
        lower.startsWith("i'm currently learning ")) {
      final match = RegExp(
        r"(?:i am|i'm)\s+(?:currently\s+)?learning\s+(.+)",
        caseSensitive: false,
      ).firstMatch(input);

      if (match != null) {
        final subject = match.group(1)!.trim();
        _facts['learning'] = subject;
        await persistentMemory.saveFacts(_facts);

        final response =
            'Got it. I will remember that you are learning $subject.';
        memory.rememberEther(response);
        return response;
      }
    }

    // Remember what the user is building.
    if (lower.startsWith('i am building ') ||
        lower.startsWith("i'm building ")) {
      final match = RegExp(
        r"(?:i am|i'm)\s+building\s+(.+)",
        caseSensitive: false,
      ).firstMatch(input);

      if (match != null) {
        final project = match.group(1)!.trim();
        _facts['building'] = project;
        await persistentMemory.saveFacts(_facts);

        final response =
            'Got it. I will remember that you are building $project.';
        memory.rememberEther(response);
        return response;
      }
    }

    // Store the user's work.
    if (lower.startsWith('i work as ') ||
        lower.startsWith("i'm a ") ||
        lower.startsWith('i am a ')) {
      final match = RegExp(
        r"""(?:i work as|i'm a|i am a)\s+(.+)""",
        caseSensitive: false,
      ).firstMatch(input);

      if (match != null) {
        final value = match.group(1)!.trim();
        if (value.isNotEmpty) {
          _facts['work'] = value;
          await persistentMemory.saveFacts(_facts);
          final response = 'Got it. I will remember that you work as $value.';
          memory.rememberEther(response);
          return response;
        }
      }
    }

    // Store the user's location.
    if (lower.startsWith('i live in ') ||
        lower.startsWith('i am from ') ||
        lower.startsWith("i'm from ")) {
      final match = RegExp(
        r"""(?:i live in|i am from|i'm from)\s+(.+)""",
        caseSensitive: false,
      ).firstMatch(input);

      if (match != null) {
        final value = match.group(1)!.trim();
        if (value.isNotEmpty) {
          _facts['location'] = value;
          await persistentMemory.saveFacts(_facts);
          final response = 'Got it. I will remember that you are in $value.';
          memory.rememberEther(response);
          return response;
        }
      }
    }

    // Store a favorite.
    if (lower.startsWith('my favorite ')) {
      final match = RegExp(
        r"""my favorite\s+(.+?)\s+is\s+(.+)""",
        caseSensitive: false,
      ).firstMatch(input);

      if (match != null) {
        final category = match.group(1)!.trim().toLowerCase();
        final value = match.group(2)!.trim();

        if (category.isNotEmpty && value.isNotEmpty) {
          _facts['favorite_$category'] = value;
          await persistentMemory.saveFacts(_facts);
          final response =
              'Got it. I will remember that your favorite $category is $value.';
          memory.rememberEther(response);
          return response;
        }
      }
    }

    // Store the user's goal.
    if (lower.startsWith('my goal is ') || lower.startsWith('my goal is to ')) {
      final match = RegExp(
        r"""my goal is\s+(?:to\s+)?(.+)""",
        caseSensitive: false,
      ).firstMatch(input);

      if (match != null) {
        final value = match.group(1)!.trim();
        if (value.isNotEmpty) {
          _facts['goal'] = value;
          await persistentMemory.saveFacts(_facts);
          final response = 'Got it. I will remember that your goal is $value.';
          memory.rememberEther(response);
          return response;
        }
      }
    }

    // Retrieve what the user is learning.
    if (lower.contains('what am i learning') ||
        lower.contains('what am i studying')) {
      final subject = _facts['learning'];

      final response = subject == null
          ? 'You have not told me what you are learning yet.'
          : 'You are learning $subject.';

      memory.rememberEther(response);
      return response;
    }

    // Retrieve the user's project name.
    if (lower.contains('what is my project') ||
        lower.contains('what is the name of my project') ||
        lower.contains('what is my project called')) {
      String? project;

      // Prefer an explicitly stored building/project fact.
      project = _facts['building'];

      // Otherwise search generic remembered facts.
      for (final fact in _facts.values) {
        final factLower = fact.toLowerCase();
        if (factLower.startsWith('my project is called ')) {
          project = fact.substring('my project is called '.length).trim();
          break;
        }
      }

      final response = project == null
          ? 'You have not told me your project name yet.'
          : project.startsWith('my project is called ')
          ? 'Your project is ${project.substring('my project is called '.length).trim()}.'
          : 'Your project is $project.';

      memory.rememberEther(response);
      return response;
    }

    // Retrieve what the user is building.
    if (lower.contains('what am i building')) {
      final project = _facts['building'];

      final response = project == null
          ? 'You have not told me what you are building yet.'
          : 'You are building $project.';

      memory.rememberEther(response);
      return response;
    }

    // Retrieve the user's name.
    if (lower.contains('what is my name')) {
      final rememberedName = _facts['name'];

      final response = rememberedName == null
          ? 'You have not told me your name yet.'
          : 'Your name is $rememberedName.';

      memory.rememberEther(response);
      return response;
    }

    // Retrieve the user's work.
    if (lower.contains('what is my work') ||
        lower.contains('what do i do') ||
        lower.contains('what is my job')) {
      final value = _facts['work'];
      final response = value == null
          ? 'You have not told me what you do yet.'
          : 'You work as $value.';
      memory.rememberEther(response);
      return response;
    }

    // Retrieve the user's location.
    if (lower.contains('where do i live') ||
        lower.contains('where am i from') ||
        lower.contains('what is my location')) {
      final value = _facts['location'];
      final response = value == null
          ? 'You have not told me where you live yet.'
          : 'You are in $value.';
      memory.rememberEther(response);
      return response;
    }

    // Retrieve a favorite.
    final favoriteMatch = RegExp(
      r"""what is my favorite\s+(.+?)[?]?$""",
      caseSensitive: false,
    ).firstMatch(input.trim());

    if (favoriteMatch != null) {
      final category = favoriteMatch.group(1)!.trim().toLowerCase();
      final value = _facts['favorite_$category'];

      final response = value == null
          ? 'You have not told me your favorite $category yet.'
          : 'Your favorite $category is $value.';

      memory.rememberEther(response);
      return response;
    }

    // Retrieve the user's goal.
    if (lower.contains('what is my goal') ||
        lower.contains('what are my goals')) {
      final value = _facts['goal'];
      final response = value == null
          ? 'You have not told me your goal yet.'
          : 'Your goal is $value.';
      memory.rememberEther(response);
      return response;
    }

    // Show everything ETHER remembers.
    if (lower.contains('what do you remember')) {
      late final String response;

      if (_facts.isEmpty) {
        response = 'I do not have any saved facts yet.';
      } else {
        final facts = _facts.entries
            .map((entry) => '• ${entry.value}')
            .join('\n');

        response = 'Here is what I remember:\n$facts';
      }

      memory.rememberEther(response);
      return response;
    }

    // Handle greetings, including greetings followed by emoji or punctuation.
    final greetingMatch = RegExp(r'^(hello|hi|hey)\b', caseSensitive: false).hasMatch(input.trim());
    if (greetingMatch) {
      final response = 'Hello 👋. I am $name, the intelligence core of ETHER-OS. My brain is online and ready to help.';
      memory.rememberEther(response);
      return response;
    }

    // Handle requests asking ETHER to introduce itself.
    if (lower.contains('who are you') ||
        lower.contains('tell me about yourself') ||
        lower.contains('tell me about ether') ||
        lower.contains('what are you')) {
      final response =
          'I am $name, the intelligence core of ETHER-OS.\n\n'
          'I can understand your messages, remember information you ask me to keep, '
          'use skills, maintain conversation context, and connect to online AI when configured. '
          'My goal is to become the intelligent control core of your ETHER-OS system.';
      memory.rememberEther(response);
      return response;
    }

    // Try registered skills before normal conversation.
    final skillResult = await skills.tryHandle(input);

    if (skillResult != null) {
      memory.rememberEther(skillResult);
      return skillResult;
    }

    late final String response;

    if (RegExp(r'^(hello|hi|hey)(?:\\s|[!?.,;:])', caseSensitive: false).hasMatch(input.trim()) ||
        RegExp(r'^(hello|hi|hey)$', caseSensitive: false).hasMatch(input.trim())) {
      response = 'Hello. I am $name. My core brain is active and ready.';
    } else if (lower.contains('who are you')) {
      response = 'I am $name, the intelligence core of ETHER-OS.';
    } else if (lower.contains('status')) {
      response =
          '$name Brain: ONLINE\n'
          'AI Core: ACTIVE\n'
          'Memory: ACTIVE\n'
          'Facts: ${_facts.length}\n'
          'Conversation Memory: ${memory.length}/'
          '${EtherMemory.maxMessages}\n'
          'Tools: ACTIVE\n'
          'Skills: ${skills.skillNames.join(', ')}';
    } else {
      // Use recent conversation context for simple follow-ups.
      final context = memory.getRecentContext(6);

      final contextResponse = _answerFromRecentContext(lower, context);

      if (contextResponse != null) {
        response = contextResponse;
      } else if (onlineAI != null) {
        try {
          response = await onlineAI!.generate(
            message: input,
            context: context.isEmpty
                ? null
                : 'You are ETHER, the intelligence core of ETHER-OS. '
                      'Use the recent conversation context when helpful:\n'
                      '$context',
          );
        } catch (e) {
          response = 'ONLINE AI ERROR: $e';
        }
      } else {
        response =
            'I received your request: "$input"\n\n'
            '$name Brain is processing it. '
            'Memory, conversation context, skills, '
            'and basic recall are active.';
      }
    }

    memory.rememberEther(response);
    return response;
  }

  String? _answerFromRecentContext(String lower, String context) {
    if (context.isEmpty) {
      return null;
    }

    // Example:
    // User: I am learning Flutter
    // User: What am I learning?
    if (lower.contains('what am i learning') ||
        lower.contains('what am i studying')) {
      for (final line in context.split('\n').reversed) {
        if (line.startsWith('User: ')) {
          final text = line.substring('User: '.length).trim();

          final match = RegExp(
            r"""(?:i am|i'm)\s+(?:currently\s+)?learning\s+(.+)""",
            caseSensitive: false,
          ).firstMatch(text);

          if (match != null) {
            return 'You are learning ${match.group(1)}.';
          }
        }
      }
    }

    // Example:
    // User: I am building ETHER-OS
    // User: What am I building?
    if (lower.contains('what am i building')) {
      for (final line in context.split('\n').reversed) {
        if (line.startsWith('User: ')) {
          final text = line.substring('User: '.length).trim();

          final match = RegExp(
            r"""(?:i am|i'm)\s+building\s+(.+)""",
            caseSensitive: false,
          ).firstMatch(text);

          if (match != null) {
            return 'You are building ${match.group(1)}.';
          }
        }
      }
    }

    return null;
  }
}
