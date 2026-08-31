enum ContentPlatform { youtube, tiktok }

enum ContentFormat { longForm, shortForm, both }

class ContentObjective {
  final String goal;
  final List<ContentPlatform> platforms;
  final ContentFormat format;
  final int videosPerWeek;
  final bool repurposeContent;

  const ContentObjective({
    required this.goal,
    this.platforms = const [ContentPlatform.youtube, ContentPlatform.tiktok],
    this.format = ContentFormat.both,
    this.videosPerWeek = 3,
    this.repurposeContent = true,
  });

  bool get isFaceless => goal.toLowerCase().contains('faceless');

  bool get usesYouTube => platforms.contains(ContentPlatform.youtube);

  bool get usesTikTok => platforms.contains(ContentPlatform.tiktok);
}
