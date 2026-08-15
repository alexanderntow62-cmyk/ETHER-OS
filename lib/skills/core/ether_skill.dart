abstract class EtherSkill {
  String get id;
  String get name;

  bool canHandle(String input);

  Future<String> execute(String input);
}
