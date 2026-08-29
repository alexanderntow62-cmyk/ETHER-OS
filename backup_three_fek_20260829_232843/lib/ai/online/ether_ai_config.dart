class EtherAIConfig {
  static const String openAIApiKey =
      String.fromEnvironment('OPENAI_API_KEY');

  static bool get hasOpenAIKey =>
      openAIApiKey.trim().isNotEmpty;
}
