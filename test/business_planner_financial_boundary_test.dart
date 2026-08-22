import 'package:flutter_test/flutter_test.dart';

import '../lib/business/business_permission.dart';
import '../lib/business/business_planner.dart';
import '../lib/business/business_task.dart';
import '../lib/business/ether_business_engine.dart';
import '../lib/business/integrations/business_integration.dart';
import '../lib/business/integrations/business_integration_registry.dart';
import '../lib/business/integrations/business_integration_result.dart';

class FinancialBoundaryTestIntegration implements BusinessIntegration {
  @override
  final String id = 'woocommerce';

  @override
  final String name = 'Financial Boundary Test Integration';

  @override
  final bool isConfigured = true;

  @override
  Set<String> get supportedActions => {'purchase_inventory'};

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
      message: 'This must never execute automatically.',
    );
  }
}

class FinancialBoundaryTestPlanner extends EtherBusinessPlanner {
  @override
  BusinessPlan createPlan(String goal) {
    return BusinessPlan(
      goal: goal,
      steps: const [
        BusinessPlanStep(
          id: 'inventory_purchase',
          title: 'Purchase inventory',
          description: 'Purchase inventory from the supplier.',
          permission: BusinessPermission.financial,
          integrationId: 'woocommerce',
          action: 'purchase_inventory',
        ),
      ],
    );
  }
}

void main() {
  test('planner financial integration step never executes automatically',
      () async {
    final integration = FinancialBoundaryTestIntegration();

    final engine = EtherBusinessEngine(
      planner: FinancialBoundaryTestPlanner(),
      integrations: BusinessIntegrationRegistry(
        integrations: [integration],
      ),
    );

    final task = engine.createTask(
      id: 'financial_boundary_1',
      goal: 'Purchase inventory',
      permission: BusinessPermission.autonomous,
    );

    final result = await engine.execute(task);

    expect(result, contains('STOPPED AT FINANCIAL BOUNDARY'));
    expect(result, contains('APPROVAL REQUIRED'));
    expect(result, contains('Purchase inventory'));

    expect(integration.lastAction, isNull);
    expect(task.status, BusinessTaskStatus.waitingApproval);
    expect(engine.pendingApprovalCount, 1);
  });
}
