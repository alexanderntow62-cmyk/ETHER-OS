class ContentMetrics {
  final int views;
  final int likes;
  final int comments;
  final int shares;
  final double watchTime;
  final double retention;

  const ContentMetrics({
    this.views = 0,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    this.watchTime = 0,
    this.retention = 0,
  });

  double get engagementRate {
    if (views <= 0) return 0;
    return (likes + comments + shares) / views;
  }
}

class ContentAnalyticsEngine {
  String evaluate(ContentMetrics metrics) {
    if (metrics.views == 0) {
      return 'INSUFFICIENT DATA';
    }

    if (metrics.retention >= 0.50 && metrics.engagementRate >= 0.05) {
      return 'STRONG — scale similar content.';
    }

    if (metrics.retention >= 0.30) {
      return 'PROMISING — improve hook and packaging.';
    }

    return 'WEAK — test a new topic, hook, or format.';
  }
}
