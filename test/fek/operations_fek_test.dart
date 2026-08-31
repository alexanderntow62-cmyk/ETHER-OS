import 'package:flutter_test/flutter_test.dart';
import 'package:ether_os/fek/ether_fek.dart';
import 'package:ether_os/fek/operations/ether_operations_fek.dart';

void main() {
  test('operations FEK identifies itself correctly', () {
    final fek = EtherOperationsFEK();

    expect(fek.type, EtherFekType.operations);
    expect(fek.name, 'OPERATIONS FEK');
    expect(fek.canHandle('start a business'), isTrue);
  });

  test('operations FEK rejects empty input', () {
    final fek = EtherOperationsFEK();

    expect(fek.canHandle(''), isFalse);
  });
}
