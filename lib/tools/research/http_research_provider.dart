import 'dart:convert';

import 'package:http/http.dart' as http;

import 'research_provider.dart';

/// External research provider backed by a public HTTP research endpoint.
///
/// This provider gathers information only.
/// It does not make business decisions and does not perform financial actions.
class HttpResearchProvider implements ResearchProvider {
  final http.Client client;
  final String endpoint;

  HttpResearchProvider({
    http.Client? client,
    this.endpoint = 'https://en.wikipedia.org/api/rest_v1/page/summary/',
  }) : client = client ?? http.Client();

  @override
  String get name => 'http';

  @override
  Future<String> research(String query) async {
    final trimmed = query.trim();

    if (trimmed.isEmpty) {
      return 'Research query is empty.';
    }

    final encoded = Uri.encodeComponent(trimmed);
    final uri = Uri.parse('$endpoint$encoded');

    try {
      final response = await client.get(
        uri,
        headers: const {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        return [
          'RESEARCH PROVIDER: HTTP',
          'RESEARCH STATUS: ERROR',
          'Query: $trimmed',
          '',
          'External research request failed.',
          'HTTP status: ${response.statusCode}',
        ].join('\n');
      }

      final decoded = jsonDecode(response.body);

      if (decoded is! Map<String, dynamic>) {
        return [
          'RESEARCH PROVIDER: HTTP',
          'RESEARCH STATUS: ERROR',
          'Query: $trimmed',
          '',
          'External research returned an invalid response.',
        ].join('\n');
      }

      final title = decoded['title']?.toString() ?? trimmed;
      final description =
          decoded['description']?.toString() ?? 'No description available.';
      final extract =
          decoded['extract']?.toString() ?? 'No research summary available.';

      return [
        'RESEARCH PROVIDER: HTTP',
        'RESEARCH STATUS: LIVE',
        'Query: $trimmed',
        '',
        'Topic: $title',
        'Description: $description',
        '',
        extract,
        '',
        'SOURCE: Wikipedia REST API',
      ].join('\n');
    } catch (error) {
      return [
        'RESEARCH PROVIDER: HTTP',
        'RESEARCH STATUS: ERROR',
        'Query: $trimmed',
        '',
        'External research request could not be completed.',
        'Error: $error',
      ].join('\n');
    }
  }

  void close() {
    client.close();
  }
}
