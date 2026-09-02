import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ether_os/jarvis/ether_jarvis_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  group('EtherJarvisController', () {
    test('initializes successfully', () async {
      final jarvis = EtherJarvisController();

      expect(jarvis.isInitialized, isFalse);

      await jarvis.initialize();

      expect(jarvis.isInitialized, isTrue);
      expect(jarvis.isBusy, isFalse);
    });

    test('handles an empty command', () async {
      final jarvis = EtherJarvisController();

      final response = await jarvis.execute('');

      expect(response, contains('JARVIS'));
      expect(jarvis.isBusy, isFalse);
    });

    test('processes a normal command', () async {
      final jarvis = EtherJarvisController();

      final response = await jarvis.execute('hello');

      expect(response.trim(), isNotEmpty);
      expect(jarvis.isBusy, isFalse);
    });

    test('can be initialized more than once safely', () async {
      final jarvis = EtherJarvisController();

      await jarvis.initialize();
      await jarvis.initialize();

      expect(jarvis.isInitialized, isTrue);
    });
  });
}
