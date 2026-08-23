import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EtherSecureCredentials {
  static const _storage = FlutterSecureStorage();

  static String _key(String integration, String field) =>
      'ether.business.$integration.$field';

  static Future<void> save({
    required String integration,
    required String field,
    required String value,
  }) async {
    await _storage.write(
      key: _key(integration, field),
      value: value,
    );
  }

  static Future<String?> read({
    required String integration,
    required String field,
  }) async {
    return _storage.read(
      key: _key(integration, field),
    );
  }

  static Future<void> delete({
    required String integration,
    required String field,
  }) async {
    await _storage.delete(
      key: _key(integration, field),
    );
  }

  static Future<void> deleteIntegration(String integration) async {
    await _storage.delete(
      key: _key(integration, 'store_url'),
    );
    await _storage.delete(
      key: _key(integration, 'consumer_key'),
    );
    await _storage.delete(
      key: _key(integration, 'consumer_secret'),
    );
    await _storage.delete(
      key: _key(integration, 'access_token'),
    );
    await _storage.delete(
      key: _key(integration, 'api_key'),
    );
  }
}
