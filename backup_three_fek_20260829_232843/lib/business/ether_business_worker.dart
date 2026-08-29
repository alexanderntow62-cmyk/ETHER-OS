import 'ether_business_operator.dart';

class EtherBusinessWorker {
  final EtherBusinessOperator operator;
  final Duration interval;
  final Duration startTime;
  final Duration endTime;
  final DateTime Function() clock;

  bool _running = false;

  EtherBusinessWorker({
    EtherBusinessOperator? operator,
    this.interval = const Duration(minutes: 30),
    this.startTime = const Duration(hours: 6, minutes: 30),
    this.endTime = const Duration(hours: 17, minutes: 30),
    DateTime Function()? clock,
  }) : operator = operator ?? EtherBusinessOperator(),
       clock = clock ?? DateTime.now;

  bool get isRunning => _running;

  bool isWithinWorkWindow(DateTime time) {
    final current = Duration(hours: time.hour, minutes: time.minute);

    return current >= startTime && current <= endTime;
  }

  Future<String> performCheck(String goal) async {
    if (goal.trim().isEmpty) {
      return 'ETHER WORKER\nNo task provided.';
    }

    final now = clock();

    if (!isWithinWorkWindow(now)) {
      return [
        'ETHER WORKER',
        'STATUS: OUTSIDE WORK WINDOW',
        'Work window: 06:30–17:30',
        'ETHER will wait for the next permitted work period.',
      ].join('\n');
    }

    _running = true;

    try {
      final result = await operator.start(goal);

      return [
        'ETHER AUTONOMOUS WORKER',
        '',
        'STATUS: WORK COMPLETED',
        'Time: ${_formatTime(now)}',
        '',
        result,
      ].join('\n');
    } finally {
      _running = false;
    }
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }
}
