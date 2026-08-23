import 'package:flutter_test/flutter_test.dart';

import '../lib/business/security/ether_secure_credentials.dart';
import '../lib/business/ether_business_engine.dart';

void main() {
  test('secure credential API is available', () {
    expect(EtherSecureCredentials.save, isNotNull);
    expect(EtherSecureCredentials.read, isNotNull);
    expect(EtherSecureCredentials.delete, isNotNull);
    expect(EtherSecureCredentials.deleteIntegration, isNotNull);
  });

  test('business engine exposes secure-storage initialization', () {
    expect(EtherBusinessEngine.fromSecureStorage, isNotNull);
  });
}
