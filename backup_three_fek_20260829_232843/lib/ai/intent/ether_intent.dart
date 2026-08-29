enum EtherIntentType {
  conversation,
  skill,
  memory,
  systemAction,
  businessAction,
  unknown,
}

class EtherIntent {
  final EtherIntentType type;
  final String input;

  const EtherIntent({
    required this.type,
    required this.input,
  });

  bool get isConversation => type == EtherIntentType.conversation;
  bool get isSkill => type == EtherIntentType.skill;
  bool get isMemory => type == EtherIntentType.memory;
  bool get isSystemAction => type == EtherIntentType.systemAction;
  bool get isBusinessAction => type == EtherIntentType.businessAction;
}
