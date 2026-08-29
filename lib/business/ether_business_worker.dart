import 'ether_business_operator.dart';

/// Autonomous business worker used by FEK-3.
///
/// Responsibilities:
/// - enforce the autonomous work window
/// - invoke the business operator
/// - expose worker state
/// - never bypass the business/financial safety boundary
class EtherBusinessWorker {
  final EtherBusinessOperator operator;
  final DateTime Function() clock;

  bool _running = false;

  /// Default autonomous business window:
  /// 06:30 -> 17:30 local time.
  static const int workStartHour = 6;
  static const int workStartMinute = 30;
  static const int workEndHour = 17;
  static const int workEndMinute = 30;

  EtherBusinessWorker({
    EtherBusinessOperator? operator,
    DateTime Function()? clock,
  }) : operator = operator ?? EtherBusinessOperator(),
       clock = clock ?? DateTime.now;

  bool get isRunning => _running;

  bool isWithinWorkWindow([DateTime? now]) {
    final time = now ?? clock();

    final minutes = time.hour * 60 + time.minute;
    const start = workStartHour * 60 + workStartMinute;
    const end = workEndHour * 60 + workEndMinute;

    return minutes >= start && minutes <= end;
  }

  Future<String> performCheck(String goal) async {
    final input = goal.trim();

    if (input.isEmpty) {
      return [
        'ETHER BUSINESS WORKER',
        'STATUS: NO GOAL',
        'No business goal provided.',
      ].join('\n');
    }

    if (!isWithinWorkWindow()) {
      return [
        'ETHER BUSINESS WORKER',
        'STATUS: OUTSIDE WORK WINDOW',
        'Work window: 06:30–17:30',
        'No autonomous work performed.',
      ].join('\n');
    }

    _running = true;

    try {
      final result = await operator.start(input);

      return [
        'ETHER BUSINESS WORKER',
        'STATUS: COMPLETED',
        '',
        result,
      ].join('\n');
    } catch (error) {
      return ['ETHER BUSINESS WORKER', 'STATUS: ERROR', '$error'].join('\n');
    } finally {
      _running = false;
    }
  }

  Future<String> run(String goal) {
    return performCheck(goal);
  }

  void stop() {
    _running = false;
  }
}
