import 'package:flutter_test/flutter_test.dart';
import 'package:ether_os/fek/ether_fek.dart';
import 'package:ether_os/fek/ether_fek_router.dart';

void main() {
  group('EtherFekRouter', () {
    test('routes business goals to operations FEK', () {
      final router = EtherFekRouter();
      final fek = router.route('start a business', businessIntent: true);

      expect(fek.type, EtherFekType.operations);
    });

    test('routes action goals to action FEK', () {
      final router = EtherFekRouter();

      final fek = router.route('calculate 2 + 2');

      expect(fek.type, EtherFekType.action);
    });

    test('routes general goals to cognitive FEK', () {
      final router = EtherFekRouter();

      final fek = router.route('explain quantum computing');

      expect(fek.type, EtherFekType.cognitive);
    });
  });
}
