import '../../../agent/ether_task.dart';

/// FEK-2 business execution layer.
///
/// FEK-3 decides and plans.
/// FEK-2 executes permitted business tasks.
///
/// Financial actions are always blocked unless an explicit
/// higher-level approval mechanism authorizes them.
class EtherBusinessExecutor {
  Future<String?> execute(EtherTask task) async {
    final goal = task.goal.trim();
    final lower = goal.toLowerCase();

    if (goal.isEmpty) {
      return null;
    }

    // Financial actions are NEVER executed automatically.
    if (task.type == EtherTaskType.finance || _isFinancial(lower)) {
      return 'FEK-2 BLOCKED: Financial action requires user approval.';
    }

    if (_isResearch(lower)) {
      return _research(goal);
    }

    if (_isProduct(lower)) {
      return _product(goal);
    }

    if (_isMarketing(lower)) {
      return _marketing(goal);
    }

    if (_isCustomer(lower)) {
      return _customer(goal);
    }

    if (_isContent(lower)) {
      return _content(goal);
    }

    // Also recognize explicitly typed business tasks even when
    // their goal text does not contain a keyword.
    switch (task.type) {
      case EtherTaskType.research:
        return _research(goal);

      case EtherTaskType.product:
        return _product(goal);

      case EtherTaskType.marketing:
        return _marketing(goal);

      case EtherTaskType.customer:
        return _customer(goal);

      case EtherTaskType.finance:
        return 'FEK-2 BLOCKED: Financial action requires user approval.';

      case EtherTaskType.general:
      case EtherTaskType.calculator:
      case EtherTaskType.system:
        return null;
    }
  }

  bool _isFinancial(String input) {
    const terms = [
      'pay',
      'payment',
      'purchase',
      'buy',
      'spend',
      'withdraw',
      'subscribe',
      'subscription',
      'paid advertising',
      'pay for advertising',
      'transfer money',
      'send money',
      'charge',
      'order',
    ];

    return terms.any(input.contains);
  }

  bool _isResearch(String input) {
    const terms = [
      'research',
      'market research',
      'analyze market',
      'analyse market',
      'find market',
      'competitor',
      'competition',
    ];

    return terms.any(input.contains);
  }

  bool _isProduct(String input) {
    const terms = [
      'product',
      'products',
      'dropshipping',
      'drop shipping',
      'supplier',
      'inventory',
      'store',
      'ecommerce',
      'e-commerce',
    ];

    return terms.any(input.contains);
  }

  bool _isMarketing(String input) {
    const terms = [
      'marketing',
      'promotion',
      'promote',
      'audience',
      'advertising',
      'campaign',
    ];

    return terms.any(input.contains);
  }

  bool _isCustomer(String input) {
    const terms = [
      'customer',
      'customers',
      'support',
      'sales',
      'sell',
      'client',
      'clients',
    ];

    return terms.any(input.contains);
  }

  bool _isContent(String input) {
    const terms = [
      'content',
      'youtube',
      'video',
      'post',
      'article',
      'script',
      'thumbnail',
    ];

    return terms.any(input.contains);
  }

  String _research(String goal) {
    return [
      'FEK-2 BUSINESS EXECUTOR',
      'EXECUTION TYPE: RESEARCH',
      'Task received: $goal',
      'Research execution handler activated.',
      'No financial action performed.',
    ].join('\n');
  }

  String _product(String goal) {
    return [
      'FEK-2 BUSINESS EXECUTOR',
      'EXECUTION TYPE: PRODUCT',
      'Task received: $goal',
      'Product execution handler activated.',
      'No purchase or financial commitment performed.',
    ].join('\n');
  }

  String _marketing(String goal) {
    return [
      'FEK-2 BUSINESS EXECUTOR',
      'EXECUTION TYPE: MARKETING',
      'Task received: $goal',
      'Marketing execution handler activated.',
      'No paid advertising or financial commitment performed.',
    ].join('\n');
  }

  String _customer(String goal) {
    return [
      'FEK-2 BUSINESS EXECUTOR',
      'EXECUTION TYPE: CUSTOMER',
      'Task received: $goal',
      'Customer execution handler activated.',
      'No financial transaction performed.',
    ].join('\n');
  }

  String _content(String goal) {
    return [
      'FEK-2 BUSINESS EXECUTOR',
      'EXECUTION TYPE: CONTENT',
      'Task received: $goal',
      'Content execution handler activated.',
      'No financial action performed.',
    ].join('\n');
  }
}
