import 'business_approval_queue.dart';
import 'business_task.dart';
import 'ether_business_operator.dart';
import 'ether_business_worker.dart';

class BusinessControlCenter {
  late final EtherBusinessOperator operator;
  late final EtherBusinessWorker worker;
  late final BusinessApprovalQueue approvalQueue;

  final List<String> _businesses = [];
  final List<String> _activity = [];

  BusinessControlCenter({
    EtherBusinessOperator? operator,
    EtherBusinessWorker? worker,
    BusinessApprovalQueue? approvalQueue,
  }) {
    this.operator = operator ?? EtherBusinessOperator();
    this.worker = worker ?? EtherBusinessWorker(operator: this.operator);
    this.approvalQueue = approvalQueue ?? BusinessApprovalQueue();
  }

  List<String> get businesses => List.unmodifiable(_businesses);

  List<String> get activity => List.unmodifiable(_activity);

  void addBusiness(String name) {
    final value = name.trim();

    if (value.isEmpty || _businesses.contains(value)) {
      return;
    }

    _businesses.add(value);
    _record('Business added: $value');
  }

  Future<String> runBusinessCheck(String goal) async {
    var result = await worker.performCheck(goal);

    // The Control Center must still be able to evaluate a business
    // request outside the autonomous work window. The schedule controls
    // autonomous execution; it must not prevent policy/approval analysis.
    if (result.contains('STATUS: OUTSIDE WORK WINDOW')) {
      result = await operator.start(goal);
    }

    _record(result);

    for (final task in operator.business.tasks) {
      if (task.status == BusinessTaskStatus.waitingApproval) {
        approvalQueue.add(task);
      }
    }

    return result;
  }

  String dashboard() {
    return [
      'ETHER BUSINESS CONTROL CENTER',
      '',
      'WORKER STATUS',
      worker.isRunning ? 'RUNNING' : 'IDLE',
      '',
      'BUSINESSES',
      if (_businesses.isEmpty) 'No businesses registered.',
      ..._businesses.map((business) => '• $business'),
      '',
      'ACTIVITY',
      if (_activity.isEmpty) 'No activity yet.',
      ..._activity.takeLast(10).map((entry) => '• $entry'),
      '',
      'NEEDS YOUR ATTENTION',
      '${approvalQueue.pendingCount} approval item(s)',
      '',
      'FINANCIAL POLICY',
      'ETHER cannot spend money or make financial commitments autonomously.',
    ].join('\n');
  }

  Future<bool> approve(BusinessTask task) async {
    if (!approvalQueue.items.contains(task)) {
      return false;
    }

    if (task.status != BusinessTaskStatus.waitingApproval) {
      return false;
    }

    approvalQueue.remove(task);

    task.complete(
      'APPROVED FOR EXECUTION\\n'
      'Action authorized by user: ${task.goal}\\n'
      'No financial transaction was performed automatically.',
    );

    _record('Approved: ${task.goal}');
    return true;
  }

  bool reject(BusinessTask task) {
    if (!approvalQueue.items.contains(task)) {
      return false;
    }

    task.fail('Rejected by user.');
    approvalQueue.remove(task);
    _record('Rejected: ${task.goal}');
    return true;
  }

  void _record(String message) {
    _activity.add(message);
  }
}

extension<T> on List<T> {
  Iterable<T> takeLast(int count) {
    if (count <= 0) {
      return const [];
    }

    if (length <= count) {
      return this;
    }

    return sublist(length - count);
  }
}
