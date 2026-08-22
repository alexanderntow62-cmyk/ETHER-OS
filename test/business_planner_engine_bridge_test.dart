import 'package:flutter_test/flutter_test.dart';

import '../lib/business/business_permission.dart';
import '../lib/business/business_task.dart';
import '../lib/business/ether_business_engine.dart';
import '../lib/business/business_planner.dart';
import '../lib/business/integrations/business_integration.dart';
import '../lib/business/integrations/business_integration_registry.dart';
import '../lib/business/integrations/business_integration_result.dart';

class PlannerBridgeTestIntegration implements BusinessIntegration {
  @override
  final String id = 'woocommerce';

  @override
  final String name = 'Planner Bridge Test Integration';

  @override
  final bool isConfigured = true;

  @override
  Set<String> get supportedActions => {'list_products'};

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
      message: 'Planner bridge integration executed.',
    );
  }
}

class PlannerBridgeTestPlanner extends EtherBusinessPlanner {
  @override
  BusinessPlan createPlan(String goal) {
    return BusinessPlan(
      goal: goal,
      steps: const [
        BusinessPlanStep(
          id: 'woocommerce_products',
          title: 'Retrieve products',
          description: 'Retrieve the current product catalog.',
          integrationId: 'woocommerce',
          action: 'list_products',
        ),
      ],
    );
  }
}

void main() {
  test('planner integration step is routed through the business engine',
      () async {
    final integration = PlannerBridgeTestIntegration();

    final engine = EtherBusinessEngine(
      planner: PlannerBridgeTestPlanner(),
      integrations: BusinessIntegrationRegistry(
        integrations: [integration],
      ),
    );

    final task = engine.createTask(
      id: 'planner_bridge_1',
      goal: 'Retrieve current products',
      permission: BusinessPermission.autonomous,
    );

    final result = await engine.execute(task);

    expect(result, contains('INTEGRATION EXECUTED'));
    expect(result, contains('woocommerce'));
    expect(result, contains('list_products'));
    expect(integration.lastAction, 'list_products');
    expect(task.status, BusinessTaskStatus.completed);
  });
}
