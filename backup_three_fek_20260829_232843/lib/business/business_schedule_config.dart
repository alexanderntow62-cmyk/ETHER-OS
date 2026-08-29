class BusinessScheduleConfig {
  final bool enabled;
  final int startHour;
  final int startMinute;
  final int endHour;
  final int endMinute;
  final int intervalMinutes;

  const BusinessScheduleConfig({
    this.enabled = false,
    this.startHour = 6,
    this.startMinute = 30,
    this.endHour = 17,
    this.endMinute = 30,
    this.intervalMinutes = 30,
  });

  Duration get startTime => Duration(hours: startHour, minutes: startMinute);

  Duration get endTime => Duration(hours: endHour, minutes: endMinute);

  BusinessScheduleConfig copyWith({
    bool? enabled,
    int? startHour,
    int? startMinute,
    int? endHour,
    int? endMinute,
    int? intervalMinutes,
  }) {
    return BusinessScheduleConfig(
      enabled: enabled ?? this.enabled,
      startHour: startHour ?? this.startHour,
      startMinute: startMinute ?? this.startMinute,
      endHour: endHour ?? this.endHour,
      endMinute: endMinute ?? this.endMinute,
      intervalMinutes: intervalMinutes ?? this.intervalMinutes,
    );
  }

  String get summary {
    final start =
        '${startHour.toString().padLeft(2, '0')}:${startMinute.toString().padLeft(2, '0')}';

    final end =
        '${endHour.toString().padLeft(2, '0')}:${endMinute.toString().padLeft(2, '0')}';

    return [
      'ETHER BUSINESS SCHEDULE',
      '',
      'Enabled: ${enabled ? 'YES' : 'NO'}',
      'Work window: $start–$end',
      'Interval: $intervalMinutes minutes',
    ].join('\n');
  }
}
