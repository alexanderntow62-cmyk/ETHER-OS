import 'package:flutter_test/flutter_test.dart';

import '../lib/business/business_permission.dart';
import '../lib/business/business_task.dart';
import '../lib/business/ether_business_engine.dart';
import '../lib/business/integrations/business_integration.dart';
import '../lib/business/integrations/business_integration_registry.dart';
import '../lib/business/integrations/business_integration_result.dart';

class TestIntegration implements BusinessIntegration {
  @override
  final String id = 'woocommerce';

  @override
  final String name = 'Test Integration';

  @override
  final bool isConfigured = true;

  String? lastAction;

  @override
  Future<bool> testConnection() async => true;

  @override
  Future<BusinessIntegrationResult> execute({
    required String action,
    required Map<String, dynamic> parameters,
  }) async {
    lastAction = action;

    return BusinessIntegrationResult.success(
      integration: id,
      action: action,
      message: 'Integration executed.',
    );
  }
}

void main() {
  group('EtherBusinessEngine integration execution', () {
    late TestIntegration integration;
    late EtherBusinessEngine engine;

    setUp(() {
      integration = TestIntegration();

      engine = EtherBusinessEngine(
        integrations: BusinessIntegrationRegistry(
          integrations: [integration],
        ),
      );
    });

    test('approved autonomous task can execute an integration', () async {
      final task = engine.createTask(
        id: 'test_1',
        goal: 'Perform a non-financial integration action',
      );

      task.approve();

      final result = await engine.executeIntegration(
        task: task,
        integrationId: 'woocommerce',
        action: 'list_products',
      );

      expect(result.success, isTrue);
      expect(result.integration, 'woocommerce');
      expect(result.action, 'list_products');
      expect(integration.lastAction, 'list_products');
    });

    test('financial task is blocked', () async {
      final task = engine.createTask(
        id: 'financial_1',
        goal: 'Purchase inventory',
        permission: BusinessPermission.financial,
      );

      final result = await engine.executeIntegration(
        task: task,
        integrationId: 'woocommerce',
        action: 'purchase_inventory',
      );

      expect(result.success, isFalse);
      expect(result.message, contains('FINANCIAL EXECUTION BLOCKED'));
      expect(task.status, BusinessTaskStatus.waitingApproval);
      expect(engine.pendingApprovalCount, 1);
      expect(integration.lastAction, isNull);
    });

    test('approval-required task is blocked', () async {
      final task = engine.createTask(
        id: 'approval_1',
        goal: 'Publish a store change',
        permission: BusinessPermission.approvalRequired,
      );

      final result = await engine.executeIntegration(
        task: task,
        integrationId: 'woocommerce',
        action: 'publish',
      );

      expect(result.success, isFalse);
      expect(result.message, contains('APPROVAL REQUIRED'));
      expect(task.status, BusinessTaskStatus.waitingApproval);
      expect(integration.lastAction, isNull);
    });

    test('unapproved autonomous task cannot directly execute integration',
        () async {
      final task = engine.createTask(
        id: 'blocked_1',
        goal: 'Run integration',
      );

      final result = await engine.executeIntegration(
        task: task,
        integrationId: 'woocommerce',
        action: 'list_products',
      );

      expect(result.success, isFalse);
      expect(result.message, contains('EXECUTION BLOCKED'));
      expect(integration.lastAction, isNull);
    });

    test('unknown integration returns failure without execution', () async {
      final task = engine.createTask(
        id: 'unknown_1',
        goal: 'Use unknown integration',
      );

      task.approve();

      final result = await engine.executeIntegration(
        task: task,
        integrationId: 'does_not_exist',
        action: 'test',
      );

      expect(result.success, isFalse);
      expect(result.message, contains('not registered'));
      expect(integration.lastAction, isNull);
    });
  });
}
