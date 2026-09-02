import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:ether_os/tools/research/http_research_provider.dart';

void main() {
  test('HTTP research provider has correct identity', () {
    final provider = HttpResearchProvider(client: _FakeHttpClient());

    expect(provider.name, 'http');
  });

  test('HTTP research provider handles successful response', () async {
    final provider = HttpResearchProvider(
      client: _FakeHttpClient(
        responseBody: jsonEncode({
          'title': 'Artificial intelligence',
          'description': 'Intelligence demonstrated by machines.',
          'extract': 'Artificial intelligence is a field of research.',
        }),
      ),
    );

    final result = await provider.research('Artificial intelligence');

    expect(result, contains('RESEARCH PROVIDER: HTTP'));
    expect(result, contains('RESEARCH STATUS: LIVE'));
    expect(result, contains('Artificial intelligence'));
    expect(result, contains('field of research'));
  });

  test('HTTP research provider handles failed response', () async {
    final provider = HttpResearchProvider(
      client: _FakeHttpClient(statusCode: 500),
    );

    final result = await provider.research('AI');

    expect(result, contains('RESEARCH STATUS: ERROR'));
    expect(result, contains('500'));
  });

  test('HTTP research provider rejects empty query', () async {
    final provider = HttpResearchProvider(client: _FakeHttpClient());

    final result = await provider.research('');

    expect(result, 'Research query is empty.');
  });
}

class _FakeHttpClient extends http.BaseClient {
  final int statusCode;
  final String responseBody;

  _FakeHttpClient({this.statusCode = 200, this.responseBody = '{}'});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    return http.StreamedResponse(
      Stream.value(utf8.encode(responseBody)),
      statusCode,
      headers: const {'content-type': 'application/json'},
    );
  }
}
