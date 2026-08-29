import 'dart:async';

import 'ether_business_worker.dart';

class BusinessScheduler {
  final EtherBusinessWorker worker;
  final Duration interval;
  final DateTime Function() clock;

  Timer? _timer;
  bool _running = false;

  BusinessScheduler({
    EtherBusinessWorker? worker,
    this.interval = const Duration(minutes: 30),
    DateTime Function()? clock,
  }) : clock = clock ?? DateTime.now,
       worker = worker ?? EtherBusinessWorker(clock: clock ?? DateTime.now);

  bool get isRunning => _running;

  bool isWithinWorkWindow() {
    return worker.isWithinWorkWindow(clock());
  }

  Future<String> runOnce(String goal) async {
    if (!isWithinWorkWindow()) {
      return [
        'ETHER SCHEDULER',
        'STATUS: OUTSIDE WORK WINDOW',
        'Work window: 06:30–17:30',
        'No autonomous work performed.',
      ].join('\n');
    }

    return worker.performCheck(goal);
  }

  void start(String goal) {
    if (_running) {
      return;
    }

    _running = true;

    runOnce(goal);

    _timer = Timer.periodic(interval, (_) {
      runOnce(goal);
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _running = false;
  }

  void dispose() {
    stop();
  }
}
