import 'package:shared_preferences/shared_preferences.dart';

class EtherPersistentMemory {
  static const String _factsKey = 'ether_facts';

  Future<Map<String, String>> loadFacts() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_factsKey) ?? [];

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
    final prefs = await SharedPreferences.getInstance();

    final stored = facts.entries
        .map((entry) => '${entry.key}|${entry.value}')
        .toList();

    await prefs.setStringList(_factsKey, stored);
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_factsKey);
  }
}
