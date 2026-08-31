class ContentScript {
  final String title;
  final String hook;
  final List<String> sections;
  final String callToAction;

  const ContentScript({
    required this.title,
    required this.hook,
    required this.sections,
    required this.callToAction,
  });

  String get fullText => [hook, ...sections, callToAction].join('\n\n');
}

class ContentScriptEngine {
  ContentScript createScript({required String topic, bool shortForm = false}) {
    return ContentScript(
      title: topic,
      hook: shortForm
          ? 'Here is what you need to know about $topic.'
          : 'Today we are breaking down $topic.',
      sections: [
        'Explain the topic clearly.',
        'Show the most important facts or steps.',
        'Give practical examples.',
        'Summarize the main takeaway.',
      ],
      callToAction:
          'Follow for more useful content and subscribe for the next video.',
    );
  }
}
