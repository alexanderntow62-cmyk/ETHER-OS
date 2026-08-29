abstract class EtherTool {
  String get name;

  String get description;

  Future<String> execute(String input);
}
