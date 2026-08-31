enum EtherFekType { core, action, business, cognitive, operations }

abstract class EtherFek {
  EtherFekType get type;

  String get name;

  bool canHandle(String input);

  Future<String> handle(String input);
}
