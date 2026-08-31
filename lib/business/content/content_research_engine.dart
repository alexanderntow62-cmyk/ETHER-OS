class ContentResearchItem {
  final String topic;
  final double opportunityScore;
  final String reason;

  const ContentResearchItem({
    required this.topic,
    required this.opportunityScore,
    required this.reason,
  });
}

class ContentResearchEngine {
  List<ContentResearchItem> generateOpportunities(String niche) {
    return [
      ContentResearchItem(
        topic: 'Top $niche tools beginners should know',
        opportunityScore: 0.90,
        reason: 'Strong educational and list format.',
      ),
      ContentResearchItem(
        topic: 'Best $niche tools this week',
        opportunityScore: 0.88,
        reason: 'Recurring format suitable for a content series.',
      ),
      ContentResearchItem(
        topic: '5 mistakes beginners make with $niche',
        opportunityScore: 0.84,
        reason: 'Problem-focused content creates strong hooks.',
      ),
      ContentResearchItem(
        topic: 'How to use $niche to save time',
        opportunityScore: 0.82,
        reason: 'Practical how-to content.',
      ),
      ContentResearchItem(
        topic: '$niche explained in simple terms',
        opportunityScore: 0.78,
        reason: 'Evergreen educational content.',
      ),
    ];
  }
}
