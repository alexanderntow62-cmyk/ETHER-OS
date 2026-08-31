class ContentCalendarItem {
  final String id;
  final String topic;
  final String platform;
  final DateTime scheduledAt;
  final bool isRepurposed;

  const ContentCalendarItem({
    required this.id,
    required this.topic,
    required this.platform,
    required this.scheduledAt,
    this.isRepurposed = false,
  });
}

class ContentCalendar {
  final List<ContentCalendarItem> _items = [];

  List<ContentCalendarItem> get items => List.unmodifiable(_items);

  void add(ContentCalendarItem item) {
    _items.add(item);
  }

  void clear() {
    _items.clear();
  }
}
