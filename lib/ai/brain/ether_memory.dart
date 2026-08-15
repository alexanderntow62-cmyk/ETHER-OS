class EtherMemory {
  final List<Map<String, String>> _messages = [];

  // Maximum number of messages kept in active conversation memory.
  static const int maxMessages = 20;

  void rememberUser(String message) {
    _addMessage('user', message);
  }

  void rememberEther(String message) {
    _addMessage('ether', message);
  }

  void _addMessage(String role, String content) {
    _messages.add({
      'role': role,
      'content': content,
    });

    // Keep only the most recent messages.
    while (_messages.length > maxMessages) {
      _messages.removeAt(0);
    }
  }

  List<Map<String, String>> get messages =>
      List.unmodifiable(_messages);

  // Get the most recent messages.
  List<Map<String, String>> recentMessages([int count = 10]) {
    if (_messages.isEmpty) {
      return const [];
    }

    final start = _messages.length > count
        ? _messages.length - count
        : 0;

    return List.unmodifiable(_messages.sublist(start));
  }

  // Return the recent conversation as readable text.
  String getRecentContext([int count = 10]) {
    final recent = recentMessages(count);

    if (recent.isEmpty) {
      return '';
    }

    return recent.map((message) {
      final role = message['role'] == 'user'
          ? 'User'
          : 'ETHER';

      return '$role: ${message['content']}';
    }).join('\n');
  }

  void clear() {
    _messages.clear();
  }

  int get length => _messages.length;
}
