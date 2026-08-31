import 'package:flutter_test/flutter_test.dart';
import 'package:ether_os/skills/system/system_skill.dart';

void main() {
  late SystemSkill skill;

  setUp(() {
    skill = SystemSkill();
  });

  test('SystemSkill has correct identity', () {
    expect(skill.id, 'system');
    expect(skill.name, 'system');
    expect(skill.description, isNotEmpty);
  });

  test('SystemSkill recognizes system status requests', () {
    expect(skill.canHandle('system status'), isTrue);
    expect(skill.canHandle('show system info'), isTrue);
    expect(skill.canHandle('environment status'), isTrue);
    expect(skill.canHandle('device status'), isTrue);
  });

  test('SystemSkill ignores unrelated requests', () {
    expect(skill.canHandle('calculate 25 times 4'), isFalse);
    expect(skill.canHandle('hello ETHER'), isFalse);
  });

  test('SystemSkill returns environment information', () async {
    final result = await skill.execute('system status');

    expect(result, contains('ETHER SYSTEM STATUS'));
    expect(result, contains('Platform:'));
    expect(result, contains('Dart:'));
    expect(result, contains('Processors:'));
    expect(result, contains('Environment: ACTIVE'));
  });
}
