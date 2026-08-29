import 'package:flutter_test/flutter_test.dart';

import '../lib/fek/ether_fek_coordinator.dart';

void main() {
  test('ETHER coordinator exposes all three FEKs', () {
    final fek = EtherFEKCoordinator();

    expect(fek.core, isNotNull);
    expect(fek.action, isNotNull);
    expect(fek.business, isNotNull);
  });

  test('ETHER uses one shared Brain across Core and Action FEKs', () {
    final fek = EtherFEKCoordinator();

    expect(identical(fek.brain, fek.core.brain), isTrue);
    expect(identical(fek.brain, fek.action.brain), isTrue);
  });

  test('ETHER routes conversation to Core FEK', () {
    final fek = EtherFEKCoordinator();

    expect(
      fek.route('hello ETHER'),
      EtherFEKType.core,
    );
  });

  test('ETHER routes execution to Action FEK', () {
    final fek = EtherFEKCoordinator();

    expect(
      fek.route('calculate 25 times 4'),
      EtherFEKType.action,
    );
  });

  test('ETHER routes business operations to Business FEK', () {
    final fek = EtherFEKCoordinator();

    expect(
      fek.route('create an online business'),
      EtherFEKType.business,
    );
  });
}
