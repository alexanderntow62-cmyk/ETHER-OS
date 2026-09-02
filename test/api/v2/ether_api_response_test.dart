import 'dart:convert';

import 'package:test/test.dart';
import 'package:ether_os/api/v2/models/ether_api_response.dart';

void main() {
  test('success response serializes correctly', () {
    final response = EtherApiResponse.success(
      type: 'status',
      data: {'brain': 'ready', 'fek': 'ready'},
    );

    expect(response.success, true);
    expect(response.type, 'status');
    expect(response.error, isNull);

    final decoded = jsonDecode(response.encode());

    expect(decoded['success'], true);
    expect(decoded['type'], 'status');
    expect(decoded['data']['brain'], 'ready');
    expect(decoded['data']['fek'], 'ready');
  });

  test('failure response serializes correctly', () {
    final response = EtherApiResponse.failure(
      type: 'authentication_error',
      error: 'Unauthorized',
    );

    expect(response.success, false);
    expect(response.type, 'authentication_error');
    expect(response.error, 'Unauthorized');

    final decoded = jsonDecode(response.encode());

    expect(decoded['success'], false);
    expect(decoded['type'], 'authentication_error');
    expect(decoded['error'], 'Unauthorized');
  });
}
