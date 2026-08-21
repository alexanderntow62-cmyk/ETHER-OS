import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../lib/business/integrations/woocommerce_integration.dart';

class FakeHttpClient extends http.BaseClient {
  int statusCode = 200;
  String responseBody = '{}';

  Uri? lastUri;
  String? lastMethod;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    lastUri = request.url;
    lastMethod = request.method;

    return http.StreamedResponse(
      Stream.value(utf8.encode(responseBody)),
      statusCode,
      headers: {
        'content-type': 'application/json',
      },
      request: request,
    );
  }
}

void main() {
  group('WooCommerceIntegration', () {
    test('is not configured when credentials are missing', () {
      final integration = WooCommerceIntegration();

      expect(integration.isConfigured, isFalse);
    });

    test('is configured when store URL and credentials are provided', () {
      final integration = WooCommerceIntegration(
        storeUrl: 'https://example.com',
        consumerKey: 'ck_test',
        consumerSecret: 'cs_test',
      );

      expect(integration.isConfigured, isTrue);
    });

    test('test_connection succeeds on a successful API response', () async {
      final client = FakeHttpClient()
        ..statusCode = 200
        ..responseBody = '{"environment":{"version":"9.9.0"}}';

      final integration = WooCommerceIntegration(
        storeUrl: 'https://example.com',
        consumerKey: 'ck_test',
        consumerSecret: 'cs_test',
        client: client,
      );

      final result = await integration.execute(
        action: 'test_connection',
        parameters: {},
      );

      expect(result.success, isTrue);
      expect(result.integration, 'woocommerce');
      expect(result.action, 'test_connection');
      expect(client.lastMethod, 'GET');
      expect(client.lastUri?.path, '/wp-json/wc/v3/system_status');
      expect(
        client.lastUri?.queryParameters['consumer_key'],
        'ck_test',
      );
      expect(
        client.lastUri?.queryParameters['consumer_secret'],
        'cs_test',
      );
    });

    test('list_products returns products', () async {
      final client = FakeHttpClient()
        ..responseBody = jsonEncode([
          {
            'id': 101,
            'name': 'ETHER Shirt',
            'price': '25.00',
          },
          {
            'id': 102,
            'name': 'ETHER Hoodie',
            'price': '40.00',
          },
        ]);

      final integration = WooCommerceIntegration(
        storeUrl: 'https://example.com',
        consumerKey: 'ck_test',
        consumerSecret: 'cs_test',
        client: client,
      );

      final result = await integration.execute(
        action: 'list_products',
        parameters: {
          'page': 1,
          'per_page': 10,
        },
      );

      expect(result.success, isTrue);
      expect(result.data['count'], 2);
      expect(result.data['products'], isA<List>());
      expect(client.lastUri?.path, '/wp-json/wc/v3/products');
      expect(client.lastUri?.queryParameters['page'], '1');
      expect(client.lastUri?.queryParameters['per_page'], '10');
    });

    test('get_product requires an id', () async {
      final client = FakeHttpClient();

      final integration = WooCommerceIntegration(
        storeUrl: 'https://example.com',
        consumerKey: 'ck_test',
        consumerSecret: 'cs_test',
        client: client,
      );

      final result = await integration.execute(
        action: 'get_product',
        parameters: {},
      );

      expect(result.success, isFalse);
      expect(result.message, 'Product id is required.');
    });

    test('get_product retrieves a product', () async {
      final client = FakeHttpClient()
        ..responseBody = jsonEncode({
          'id': 101,
          'name': 'ETHER Shirt',
          'price': '25.00',
        });

      final integration = WooCommerceIntegration(
        storeUrl: 'https://example.com',
        consumerKey: 'ck_test',
        consumerSecret: 'cs_test',
        client: client,
      );

      final result = await integration.execute(
        action: 'get_product',
        parameters: {'id': 101},
      );

      expect(result.success, isTrue);
      expect(result.data['id'], 101);
      expect(result.data['name'], 'ETHER Shirt');
      expect(client.lastUri?.path, '/wp-json/wc/v3/products/101');
    });

    test('list_orders returns orders', () async {
      final client = FakeHttpClient()
        ..responseBody = jsonEncode([
          {
            'id': 5001,
            'status': 'processing',
          },
          {
            'id': 5002,
            'status': 'completed',
          },
        ]);

      final integration = WooCommerceIntegration(
        storeUrl: 'https://example.com',
        consumerKey: 'ck_test',
        consumerSecret: 'cs_test',
        client: client,
      );

      final result = await integration.execute(
        action: 'list_orders',
        parameters: {
          'page': 1,
          'per_page': 20,
        },
      );

      expect(result.success, isTrue);
      expect(result.data['count'], 2);
      expect(result.data['orders'], isA<List>());
      expect(client.lastUri?.path, '/wp-json/wc/v3/orders');
    });

    test('returns failure for an HTTP error', () async {
      final client = FakeHttpClient()
        ..statusCode = 401
        ..responseBody = '{"message":"Unauthorized"}';

      final integration = WooCommerceIntegration(
        storeUrl: 'https://example.com',
        consumerKey: 'ck_test',
        consumerSecret: 'cs_test',
        client: client,
      );

      final result = await integration.execute(
        action: 'list_products',
        parameters: {},
      );

      expect(result.success, isFalse);
      expect(result.data['statusCode'], 401);
    });

    test('rejects unsupported actions', () async {
      final integration = WooCommerceIntegration(
        storeUrl: 'https://example.com',
        consumerKey: 'ck_test',
        consumerSecret: 'cs_test',
        client: FakeHttpClient(),
      );

      final result = await integration.execute(
        action: 'delete_everything',
        parameters: {},
      );

      expect(result.success, isFalse);
      expect(
        result.message,
        'Unsupported WooCommerce action: delete_everything',
      );
    });
  });
}
