import 'business_task.dart';

class BusinessApprovalQueue {
  final List<BusinessTask> _items = [];

  List<BusinessTask> get items => List.unmodifiable(_items);

  int get pendingCount => _items.length;

  void add(BusinessTask task) {
    if (!_items.contains(task)) {
      _items.add(task);
    }
  }

  bool remove(BusinessTask task) {
    return _items.remove(task);
  }

  void clear() {
    _items.clear();
  }
}
