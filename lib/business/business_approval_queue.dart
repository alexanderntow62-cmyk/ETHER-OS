import 'business_task.dart';

class BusinessApprovalQueue {
  final List<BusinessTask> _items = [];

  List<BusinessTask> get items => List.unmodifiable(_items);

  int get pendingCount => _items.length;

  void add(BusinessTask task) {
    if (!_items.contains(task) &&
        task.status == BusinessTaskStatus.waitingApproval) {
      _items.add(task);
    }
  }

  bool approve(BusinessTask task) {
    if (!_items.contains(task)) {
      return false;
    }

    if (task.status != BusinessTaskStatus.waitingApproval) {
      return false;
    }

    _items.remove(task);
    return true;
  }

  bool reject(BusinessTask task, {String reason = 'Rejected by user.'}) {
    if (!_items.contains(task)) {
      return false;
    }

    task.fail(reason);
    _items.remove(task);
    return true;
  }

  bool remove(BusinessTask task) {
    return _items.remove(task);
  }

  void clear() {
    _items.clear();
  }
}
