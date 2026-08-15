import 'package:flutter_test/flutter_test.dart';
import '../lib/business/ether_business_worker.dart';

void main() {
  test('ETHER worker recognizes the autonomous work window', () {
    final worker = EtherBusinessWorker();

    expect(worker.isWithinWorkWindow(DateTime(2026, 8, 15, 6, 30)), isTrue);

    expect(worker.isWithinWorkWindow(DateTime(2026, 8, 15, 12, 0)), isTrue);

    expect(worker.isWithinWorkWindow(DateTime(2026, 8, 15, 17, 30)), isTrue);

    expect(worker.isWithinWorkWindow(DateTime(2026, 8, 15, 18, 0)), isFalse);
  });

  test('ETHER worker rejects empty work', () async {
    final worker = EtherBusinessWorker();

    final result = await worker.performCheck('');

    expect(result, contains('No task provided'));
    expect(worker.isRunning, isFalse);
  });

  test('ETHER worker can perform autonomous business work', () async {
    final worker = EtherBusinessWorker();

    final result = await worker.performCheck(
      'Find a business I can start with little or no money',
    );

    expect(result, contains('ETHER'));
    expect(worker.isRunning, isFalse);
  });
}
