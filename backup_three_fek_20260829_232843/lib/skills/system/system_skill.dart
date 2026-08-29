import 'dart:io';

import '../core/ether_skill.dart';

class SystemSkill implements EtherSkill {
  @override
  String get id => 'system';

  @override
  String get name => 'system';

  @override
  String get description =>
      'Provides safe information about the current ETHER-OS environment.';

  @override
  bool canHandle(String input) {
    final lower = input.toLowerCase();

    return lower.contains('system status') ||
        lower.contains('system info') ||
        lower.contains('environment status') ||
        lower.contains('device status');
  }

  @override
  Future<String> execute(String input) async {
    final buffer = StringBuffer();

    buffer.writeln('ETHER SYSTEM STATUS');
    buffer.writeln('Platform: ${Platform.operatingSystem}');
    buffer.writeln('Dart: ${Platform.version.split(' ').first}');
    buffer.writeln('Processors: ${Platform.numberOfProcessors}');
    buffer.writeln('Executable: ${Platform.resolvedExecutable}');
    buffer.writeln('Environment: ACTIVE');

    return buffer.toString().trim();
  }
}
