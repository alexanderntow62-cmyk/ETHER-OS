import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import '../lib/fek/ether_fek_coordinator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferencesStorePlatform.instance =
        InMemorySharedPreferencesStore.empty();
  });

  test('FEK routes normal conversation to Core FEK', () {
    final fek = EtherFEKCoordinator();

    expect(fek.route('hello ETHER'), EtherFekType.core);
  });

  test('FEK routes calculator requests to Action FEK', () {
    final fek = EtherFEKCoordinator();

    expect(fek.route('calculate 25 times 4'), EtherFekType.action);
  });

  test('FEK routes business requests to Business FEK', () {
    final fek = EtherFEKCoordinator();

    expect(fek.route('create an online business'), EtherFekType.business);
  });

  test('FEK processes calculator request', () async {
    final fek = EtherFEKCoordinator();

    final result = await fek.process('calculate 25 times 4');

    expect(result, contains('100'));
    expect(result.toLowerCase(), isNot(contains('goal:')));
    expect(result.toLowerCase(), isNot(contains('tasks:')));
  });

  test('FEK processes normal conversation', () async {
    final fek = EtherFEKCoordinator();

    final result = await fek.process('who are you');

    expect(result.toLowerCase(), contains('ether'));
    expect(result.toLowerCase(), isNot(contains('goal:')));
    expect(result.toLowerCase(), isNot(contains('tasks:')));
  });
}
