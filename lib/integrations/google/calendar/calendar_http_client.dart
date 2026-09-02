import 'dart:convert';

import 'package:http/http.dart' as http;

import '../auth/google_authorized_client.dart';
import '../google_api_exception.dart';

class CalendarHttpClient {
  final http.Client httpClient;
  final GoogleAuthorizedClient authorizedClient;

  CalendarHttpClient({
    required this.httpClient,
    required this.authorizedClient,
  });

  Future<Map<String, dynamic>> getJson(
    String path, {
    Map<String, String>? queryParameters,
  }) async {
    final token = await authorizedClient.token();

    if (token == null) {
      throw const GoogleApiException(
        statusCode: 401,
        message: 'Google account is not authorized.',
      );
    }

    final uri = Uri.https('www.googleapis.com', path, queryParameters);

    final response = await httpClient.get(
      uri,
      headers: {
        'Authorization': 'Bearer ${token.accessToken}',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw GoogleApiException(
        statusCode: response.statusCode,
        message: response.body,
      );
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> postJson(
    String path,
    Map<String, dynamic> body,
  ) async {
    final token = await authorizedClient.token();

    if (token == null) {
      throw const GoogleApiException(
        statusCode: 401,
        message: 'Google account is not authorized.',
      );
    }

    final uri = Uri.https('www.googleapis.com', path);

    final response = await httpClient.post(
      uri,
      headers: {
        'Authorization': 'Bearer ${token.accessToken}',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw GoogleApiException(
        statusCode: response.statusCode,
        message: response.body,
      );
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
