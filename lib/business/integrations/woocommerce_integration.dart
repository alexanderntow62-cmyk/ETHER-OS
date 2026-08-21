import 'dart:convert';

import 'package:http/http.dart' as http;

import 'business_integration.dart';
import 'business_integration_result.dart';

class WooCommerceIntegration implements BusinessIntegration {
  final String? storeUrl;
  final String? consumerKey;
  final String? consumerSecret;
  final http.Client client;

  WooCommerceIntegration({
    this.storeUrl,
    this.consumerKey,
    this.consumerSecret,
    http.Client? client,
  }) : client = client ?? http.Client();

  @override
  String get id => 'woocommerce';

  @override
  String get name => 'WooCommerce';

  @override
  bool get isConfigured =>
      storeUrl != null &&
      storeUrl!.trim().isNotEmpty &&
      consumerKey != null &&
      consumerKey!.trim().isNotEmpty &&
      consumerSecret != null &&
      consumerSecret!.trim().isNotEmpty;

  String get _baseUrl {
    final value = storeUrl!.trim().replaceFirst(RegExp(r'/$'), '');
    return '$value/wp-json/wc/v3';
  }

  Uri _uri(
    String path, {
    Map<String, String> query = const {},
  }) {
    return Uri.parse('$_baseUrl$path').replace(
      queryParameters: {
        'consumer_key': consumerKey!.trim(),
        'consumer_secret': consumerSecret!.trim(),
        ...query,
      },
    );
  }

  @override
  Future<bool> testConnection() async {
    if (!isConfigured) {
      return false;
    }

    try {
      final response = await client.get(_uri('/system_status'));

      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<BusinessIntegrationResult> execute({
    required String action,
    required Map<String, dynamic> parameters,
  }) async {
    if (!isConfigured) {
      return BusinessIntegrationResult.failure(
        integration: id,
        action: action,
        message: 'WooCommerce integration is not configured.',
      );
    }

    try {
      switch (action) {
        case 'test_connection':
          final connected = await testConnection();

          return connected
              ? BusinessIntegrationResult.success(
                  integration: id,
                  action: action,
                  message: 'WooCommerce connection successful.',
                )
              : BusinessIntegrationResult.failure(
                  integration: id,
                  action: action,
                  message: 'WooCommerce connection failed.',
                );

        case 'get_store':
          return await _getStore(action);

        case 'list_products':
          return await _listProducts(action, parameters);

        case 'get_product':
          return await _getProduct(action, parameters);

        case 'list_orders':
          return await _listOrders(action, parameters);

        default:
          return BusinessIntegrationResult.failure(
            integration: id,
            action: action,
            message: 'Unsupported WooCommerce action: $action',
          );
      }
    } catch (error) {
      return BusinessIntegrationResult.failure(
        integration: id,
        action: action,
        message: 'WooCommerce request failed: $error',
      );
    }
  }

  Future<BusinessIntegrationResult> _getStore(String action) async {
    final response = await client.get(_uri('/system_status'));

    if (!_isSuccess(response)) {
      return _httpFailure(action, response);
    }

    final data = _decodeObject(response.body);

    return BusinessIntegrationResult.success(
      integration: id,
      action: action,
      message: 'WooCommerce store information retrieved.',
      data: data,
    );
  }

  Future<BusinessIntegrationResult> _listProducts(
    String action,
    Map<String, dynamic> parameters,
  ) async {
    final query = _paginationQuery(parameters);
    final response = await client.get(_uri('/products', query: query));

    if (!_isSuccess(response)) {
      return _httpFailure(action, response);
    }

    final data = _decodeList(response.body);

    return BusinessIntegrationResult.success(
      integration: id,
      action: action,
      message: 'WooCommerce products retrieved.',
      data: {
        'products': data,
        'count': data.length,
      },
    );
  }

  Future<BusinessIntegrationResult> _getProduct(
    String action,
    Map<String, dynamic> parameters,
  ) async {
    final idValue = parameters['id'];

    if (idValue == null) {
      return BusinessIntegrationResult.failure(
        integration: id,
        action: action,
        message: 'Product id is required.',
      );
    }

    final response = await client.get(
      _uri('/products/${Uri.encodeComponent(idValue.toString())}'),
    );

    if (!_isSuccess(response)) {
      return _httpFailure(action, response);
    }

    return BusinessIntegrationResult.success(
      integration: id,
      action: action,
      message: 'WooCommerce product retrieved.',
      data: _decodeObject(response.body),
    );
  }

  Future<BusinessIntegrationResult> _listOrders(
    String action,
    Map<String, dynamic> parameters,
  ) async {
    final query = _paginationQuery(parameters);
    final response = await client.get(_uri('/orders', query: query));

    if (!_isSuccess(response)) {
      return _httpFailure(action, response);
    }

    final data = _decodeList(response.body);

    return BusinessIntegrationResult.success(
      integration: id,
      action: action,
      message: 'WooCommerce orders retrieved.',
      data: {
        'orders': data,
        'count': data.length,
      },
    );
  }

  Map<String, String> _paginationQuery(Map<String, dynamic> parameters) {
    final query = <String, String>{};

    final page = parameters['page'];
    final perPage = parameters['per_page'];

    if (page != null) {
      query['page'] = page.toString();
    }

    if (perPage != null) {
      query['per_page'] = perPage.toString();
    }

    return query;
  }

  bool _isSuccess(http.Response response) {
    return response.statusCode >= 200 && response.statusCode < 300;
  }

  BusinessIntegrationResult _httpFailure(
    String action,
    http.Response response,
  ) {
    return BusinessIntegrationResult.failure(
      integration: id,
      action: action,
      message:
          'WooCommerce API returned HTTP ${response.statusCode}.',
      data: {
        'statusCode': response.statusCode,
        'body': response.body,
      },
    );
  }

  Map<String, dynamic> _decodeObject(String body) {
    final decoded = jsonDecode(body);

    if (decoded is! Map) {
      throw const FormatException('Expected a JSON object.');
    }

    return Map<String, dynamic>.from(decoded);
  }

  List<dynamic> _decodeList(String body) {
    final decoded = jsonDecode(body);

    if (decoded is! List) {
      throw const FormatException('Expected a JSON list.');
    }

    return decoded;
  }
}
