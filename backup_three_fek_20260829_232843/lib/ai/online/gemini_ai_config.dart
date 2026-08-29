class GeminiAIConfig {
  static const String apiKey = String.fromEnvironment('GEMINI_API_KEY');

  static bool get hasGeminiKey => apiKey.trim().isNotEmpty;
}
