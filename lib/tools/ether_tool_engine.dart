import 'ether_tool.dart';

class EtherToolEngine {
  final List<EtherTool> _tools = [];

  void register(EtherTool tool) {
    if (_tools.any((existing) => existing.name == tool.name)) {
      return;
    }

    _tools.add(tool);
  }

  EtherTool? findTool(String input) {
    final lower = input.toLowerCase();

    for (final tool in _tools) {
      if (lower.contains(tool.name.toLowerCase())) {
        return tool;
      }
    }

    return null;
  }

  Future<String?> tryHandle(String input) async {
    final tool = findTool(input);

    if (tool == null) {
      return null;
    }

    return tool.execute(input);
  }

  List<String> get toolNames => _tools.map((tool) => tool.name).toList();

  List<EtherTool> get tools => List.unmodifiable(_tools);
}
