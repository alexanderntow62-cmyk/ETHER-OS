import 'package:flutter_test/flutter_test.dart';
import '../lib/business/business_schedule_config.dart';

void main() {
  test('ETHER schedule uses the default work window', () {
    const config = BusinessScheduleConfig();

    expect(config.enabled, isFalse);
    expect(config.startTime, const Duration(hours: 6, minutes: 30));
    expect(config.endTime, const Duration(hours: 17, minutes: 30));
    expect(config.intervalMinutes, 30);
  });

  test('ETHER schedule can be enabled and customized', () {
    const config = BusinessScheduleConfig();

    final updated = config.copyWith(
      enabled: true,
      startHour: 7,
      startMinute: 0,
      endHour: 18,
      endMinute: 0,
      intervalMinutes: 15,
    );

    expect(updated.enabled, isTrue);
    expect(updated.startTime, const Duration(hours: 7));
    expect(updated.endTime, const Duration(hours: 18));
    expect(updated.intervalMinutes, 15);
  });

  test('ETHER schedule produces a readable summary', () {
    const config = BusinessScheduleConfig(enabled: true);

    expect(config.summary, contains('ETHER BUSINESS SCHEDULE'));
    expect(config.summary, contains('Enabled: YES'));
    expect(config.summary, contains('06:30–17:30'));
    expect(config.summary, contains('30 minutes'));
  });
}
