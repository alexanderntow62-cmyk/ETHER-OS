class RepurposedContent {
  final String sourceTitle;
  final List<String> shortTitles;
  final List<String> shortHooks;

  const RepurposedContent({
    required this.sourceTitle,
    required this.shortTitles,
    required this.shortHooks,
  });
}

class ContentRepurposingEngine {
  RepurposedContent repurpose(String sourceTitle) {
    return RepurposedContent(
      sourceTitle: sourceTitle,
      shortTitles: [
        '$sourceTitle — Part 1',
        '$sourceTitle — The important part',
        '$sourceTitle — 30 second explanation',
        '$sourceTitle — What nobody tells you',
        '$sourceTitle — Quick breakdown',
      ],
      shortHooks: [
        'Most people get this wrong.',
        'Here is the simple explanation.',
        'You need to know this.',
        'This changes everything about the topic.',
        'Let me explain this quickly.',
      ],
    );
  }
}
