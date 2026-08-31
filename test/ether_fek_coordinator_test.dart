import 'package:flutter_test/flutter_test.dart';
import '../lib/fek/ether_fek_coordinator.dart';

void main() {
  test('FEK routes business requests to business FEK', () {
    final fek = EtherFEKCoordinator();

    expect(fek.route('create an online business'), EtherFekType.business);
  });

  test('FEK routes calculation requests to action FEK', () {
    final fek = EtherFEKCoordinator();

    expect(fek.route('calculate 25 times 4'), EtherFekType.action);
  });

  test('FEK routes normal conversation to core FEK', () {
    final fek = EtherFEKCoordinator();

    expect(fek.route('who are you'), EtherFekType.core);
  });
}
