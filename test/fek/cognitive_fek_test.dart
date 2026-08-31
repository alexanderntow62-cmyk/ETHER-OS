import 'package:flutter_test/flutter_test.dart';
import 'package:ether_os/fek/ether_fek.dart';
import 'package:ether_os/fek/cognitive/ether_cognitive_fek.dart';

void main() {
  test('cognitive FEK identifies itself correctly', () {
    final fek = EtherCognitiveFEK();

    expect(fek.type, EtherFekType.cognitive);
    expect(fek.name, 'COGNITIVE FEK');
    expect(fek.canHandle('hello'), isTrue);
  });

  test('cognitive FEK rejects empty input', () {
    final fek = EtherCognitiveFEK();

    expect(fek.canHandle(''), isFalse);
  });
}
