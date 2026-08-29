import 'package:flutter_test/flutter_test.dart';
import '../lib/business/business_scheduler.dart';

void main() {
  test('ETHER scheduler recognizes the configured work window', () {
    final scheduler = BusinessScheduler(
      clock: () => DateTime(2026, 8, 15, 10, 0),
    );

    expect(scheduler.isWithinWorkWindow(), isTrue);
  });

  test('ETHER scheduler blocks work outside the configured window', () async {
    final scheduler = BusinessScheduler(
      clock: () => DateTime(2026, 8, 15, 20, 0),
    );

    final result = await scheduler.runOnce('Check the dropshipping business');

    expect(result, contains('OUTSIDE WORK WINDOW'));
    expect(result, contains('06:30–17:30'));
  });

  test('ETHER scheduler runs autonomous work inside the window', () async {
    final scheduler = BusinessScheduler(
      clock: () => DateTime(2026, 8, 15, 10, 0),
    );

    final result = await scheduler.runOnce('Check the dropshipping business');

    expect(result, contains('ETHER AUTONOMOUS WORKER'));
  });

  test('ETHER scheduler can start and stop', () {
    final scheduler = BusinessScheduler(
      interval: const Duration(hours: 1),
      clock: () => DateTime(2026, 8, 15, 10, 0),
    );

    scheduler.start('Check the dropshipping business');

    expect(scheduler.isRunning, isTrue);

    scheduler.stop();

    expect(scheduler.isRunning, isFalse);
  });
}
