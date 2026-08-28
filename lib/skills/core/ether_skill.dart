abstract class EtherSkill {
  String get id;
  String get name;
  String get description;

  bool canHandle(String input);

  Future<String> execute(String input);
}
