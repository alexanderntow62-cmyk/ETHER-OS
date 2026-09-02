import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class EtherApiException implements Exception {
  final int? statusCode;
  final String message;

  const EtherApiException({this.statusCode, required this.message});

  @override
  String toString() {
    if (statusCode == null) {
      return 'EtherApiException: $message';
    }
    return 'EtherApiException($statusCode): $message';
  }
}

class EtherApiClient {
  final http.Client client;
  final Duration timeout;

  const EtherApiClient({
    required this.client,
    this.timeout = const Duration(seconds: 30),
  });

  Future<dynamic> get(Uri uri, {Map<String, String>? headers}) async {
    final response = await client
        .get(uri, headers: _headers(headers))
        .timeout(timeout);

    return _decode(response);
  }

  Future<dynamic> post(
    Uri uri, {
    Object? body,
    Map<String, String>? headers,
  }) async {
    final response = await client
        .post(uri, headers: _headers(headers), body: _encodeBody(body))
        .timeout(timeout);

    return _decode(response);
  }

  Future<dynamic> put(
    Uri uri, {
    Object? body,
    Map<String, String>? headers,
  }) async {
    final response = await client
        .put(uri, headers: _headers(headers), body: _encodeBody(body))
        .timeout(timeout);

    return _decode(response);
  }

  Future<dynamic> delete(Uri uri, {Map<String, String>? headers}) async {
    final response = await client
        .delete(uri, headers: _headers(headers))
        .timeout(timeout);

    return _decode(response);
  }

  Map<String, String> _headers(Map<String, String>? headers) {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      ...?headers,
    };
  }

  String? _encodeBody(Object? body) {
    if (body == null) return null;
    if (body is String) return body;
    return jsonEncode(body);
  }

  dynamic _decode(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw EtherApiException(
        statusCode: response.statusCode,
        message: response.body,
      );
    }

    if (response.body.trim().isEmpty) {
      return null;
    }

    try {
      return jsonDecode(response.body);
    } catch (_) {
      return response.body;
    }
  }

  void close() {
    client.close();
  }
}
