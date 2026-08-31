import 'package:flutter_test/flutter_test.dart';

import 'package:ether_os/fek/ether_fek_coordinator.dart';

void main() {
  test('ETHER coordinator exposes all three primary FEKs', () {
    final fek = EtherFEKCoordinator();

    expect(fek.core, isNotNull);
    expect(fek.action, isNotNull);
    expect(fek.business, isNotNull);
  });

  test('ETHER coordinator exposes supporting Cognitive FEK', () {
    final fek = EtherFEKCoordinator();

    expect(fek.cognitive, isNotNull);
    expect(fek.cognitive.type, EtherFekType.cognitive);
  });

  test('ETHER coordinator exposes supporting Operations FEK', () {
    final fek = EtherFEKCoordinator();

    expect(fek.operations, isNotNull);
    expect(fek.operations.type, EtherFekType.operations);
  });

  test(
    'ETHER uses one shared Brain across Core, Action and Cognitive FEKs',
    () {
      final fek = EtherFEKCoordinator();

      expect(identical(fek.brain, fek.core.brain), isTrue);

      expect(identical(fek.brain, fek.action.brain), isTrue);

      expect(identical(fek.brain, fek.cognitive.brain), isTrue);
    },
  );

  test('ETHER routes conversation to Core FEK', () {
    final fek = EtherFEKCoordinator();

    expect(fek.route('hello ETHER'), EtherFekType.core);
  });

  test('ETHER routes execution to Action FEK', () {
    final fek = EtherFEKCoordinator();

    expect(fek.route('calculate 25 times 4'), EtherFekType.action);
  });

  test('ETHER routes business operations to Business FEK', () {
    final fek = EtherFEKCoordinator();

    expect(fek.route('create an online business'), EtherFekType.business);
  });

  test('ETHER routes planning to Cognitive FEK', () {
    final fek = EtherFEKCoordinator();

    expect(fek.route('create a plan for my project'), EtherFekType.cognitive);
  });

  test('ETHER routes scheduling to Operations FEK', () {
    final fek = EtherFEKCoordinator();

    expect(fek.route('schedule a business cycle'), EtherFekType.operations);
  });
}
