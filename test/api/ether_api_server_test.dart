import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:http/http.dart' as http;

import 'package:ether_os/api/ether_api_server.dart';

void main() {
  late EtherApiServer server;
  late HttpServer httpServer;

  setUp(() async {
    server = EtherApiServer(host: '127.0.0.1', port: 8788, apiKey: 'test-key');

    await server.start();

    httpServer = await HttpServer.bind('127.0.0.1', 0);

    await httpServer.close();
    await server.stop();

    server = EtherApiServer(host: '127.0.0.1', port: 8788, apiKey: 'test-key');

    await server.start();
  });

  tearDown(() async {
    await server.stop();
  });

  test('health endpoint works without authentication', () async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8788/health'));

    expect(response.statusCode, 200);

    final body = jsonDecode(response.body);

    expect(body['success'], true);
    expect(body['status'], 'healthy');
  });

  test('protected endpoint requires API key', () async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8788/v1/status'),
    );

    expect(response.statusCode, 401);
  });

  test('status endpoint works with API key', () async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8788/v1/status'),
      headers: {'x-ether-api-key': 'test-key'},
    );

    expect(response.statusCode, 200);

    final body = jsonDecode(response.body);

    expect(body['success'], true);
    expect(body['brain'], 'ready');
    expect(body['fek'], 'ready');
    expect(body['business'], 'ready');
  });

  test('business plan requires approval', () async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8788/v1/business/plan'),
      headers: {
        'x-ether-api-key': 'test-key',
        'content-type': 'application/json',
      },
      body: jsonEncode({'goal': 'Build an online business'}),
    );

    expect(response.statusCode, 200);

    final body = jsonDecode(response.body);

    expect(body['success'], true);
    expect(body['status'], 'awaiting_approval');
    expect(body['requires_user_approval'], true);
  });
}
