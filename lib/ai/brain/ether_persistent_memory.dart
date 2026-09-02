import 'package:shared_preferences/shared_preferences.dart';

abstract class EtherMemoryStore {
  Future<List<String>> getStringList(String key);
  Future<void> setStringList(String key, List<String> value);
  Future<void> remove(String key);
}

class SharedPreferencesMemoryStore implements EtherMemoryStore {
  @override
  Future<List<String>> getStringList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? <String>[];
  }

  @override
  Future<void> setStringList(String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, value);
  }

  @override
  Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}

class InMemoryMemoryStore implements EtherMemoryStore {
  final Map<String, List<String>> _data = {};

  @override
  Future<List<String>> getStringList(String key) async {
    return List<String>.from(_data[key] ?? const <String>[]);
  }

  @override
  Future<void> setStringList(String key, List<String> value) async {
    _data[key] = List<String>.from(value);
  }

  @override
  Future<void> remove(String key) async {
    _data.remove(key);
  }
}

class EtherPersistentMemory {
  static const String _factsKey = 'ether_facts';

  final EtherMemoryStore store;

  EtherPersistentMemory({EtherMemoryStore? store})
    : store = store ?? SharedPreferencesMemoryStore();

  Future<Map<String, String>> loadFacts() async {
    final stored = await store.getStringList(_factsKey);

    final facts = <String, String>{};

    for (final item in stored) {
      final separator = item.indexOf('|');

      if (separator <= 0) {
        continue;
      }

      final key = item.substring(0, separator);
      final value = item.substring(separator + 1);

      facts[key] = value;
    }

    return facts;
  }

  Future<Map<String, String>> getAllFacts() async {
    return loadFacts();
  }

  Future<String?> getFact(String key) async {
    final facts = await loadFacts();
    return facts[key];
  }

  Future<void> saveFact(String key, String value) async {
    final facts = await loadFacts();
    facts[key] = value;
    await saveFacts(facts);
  }

  Future<void> saveFacts(Map<String, String> facts) async {
    final stored = facts.entries
        .map((entry) => '${entry.key}|${entry.value}')
        .toList();

    await store.setStringList(_factsKey, stored);
  }

  Future<void> deleteFact(String key) async {
    final facts = await loadFacts();

    if (!facts.containsKey(key)) {
      return;
    }

    facts.remove(key);
    await saveFacts(facts);
  }

  Future<void> clear() async {
    await store.remove(_factsKey);
  }
}
