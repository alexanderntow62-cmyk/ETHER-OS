import 'package:flutter_test/flutter_test.dart';
import 'package:ether_os/fek/ether_fek.dart';
import 'package:ether_os/fek/action/ether_action_fek.dart';

void main() {
  test('action FEK identifies itself correctly', () {
    final fek = EtherActionFEK();

    expect(fek.type, EtherFekType.action);
    expect(fek.name, 'ACTION FEK');
    expect(fek.canHandle('run task'), isTrue);
  });

  test('action FEK rejects empty input', () {
    final fek = EtherActionFEK();

    expect(fek.canHandle(''), isFalse);
  });
}
