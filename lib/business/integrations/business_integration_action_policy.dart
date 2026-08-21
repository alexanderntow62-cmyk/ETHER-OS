import '../business_permission.dart';

enum BusinessIntegrationActionRisk {
  autonomous,
  approvalRequired,
  financial,
}

class BusinessIntegrationActionPolicy {
  const BusinessIntegrationActionPolicy();

  BusinessIntegrationActionRisk classify({
    required String integrationId,
    required String action,
  }) {
    final integration = integrationId.trim().toLowerCase();
    final normalizedAction = action.trim().toLowerCase();

    if (integration == 'woocommerce') {
      switch (normalizedAction) {
        case 'test_connection':
        case 'get_store':
        case 'list_products':
        case 'get_product':
        case 'list_orders':
          return BusinessIntegrationActionRisk.autonomous;

        case 'create_product':
        case 'update_product':
        case 'create_order':
        case 'update_order':
          return BusinessIntegrationActionRisk.approvalRequired;

        case 'delete_product':
        case 'delete_order':
        case 'refund':
        case 'payment':
        case 'purchase':
        case 'purchase_inventory':
          return BusinessIntegrationActionRisk.financial;
      }
    }

    // Fail closed: unknown integration actions require approval.
    // New integrations/actions must be explicitly classified as
    // autonomous before ETHER can execute them without approval.
    return BusinessIntegrationActionRisk.approvalRequired;
  }

  BusinessPermission permissionFor({
    required String integrationId,
    required String action,
  }) {
    switch (classify(
      integrationId: integrationId,
      action: action,
    )) {
      case BusinessIntegrationActionRisk.autonomous:
        return BusinessPermission.autonomous;

      case BusinessIntegrationActionRisk.approvalRequired:
        return BusinessPermission.approvalRequired;

      case BusinessIntegrationActionRisk.financial:
        return BusinessPermission.financial;
    }
  }
}
