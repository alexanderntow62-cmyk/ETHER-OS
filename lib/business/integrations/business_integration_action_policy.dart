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

    // Registered integrations may execute their own actions
    // unless the integration has explicitly classified the
    // action as requiring approval or financial authorization.
    return BusinessIntegrationActionRisk.autonomous;
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
