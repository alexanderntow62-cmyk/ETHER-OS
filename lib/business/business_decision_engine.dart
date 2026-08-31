import 'business_state.dart';

enum BusinessDecisionType {
  calculator,
  research,
  content,
  product,
  marketing,
  customer,
  finance,
  general,
}

class BusinessDecision {
  final BusinessDecisionType type;
  final String action;
  final String reason;
  final bool requiresApproval;

  const BusinessDecision({
    required this.type,
    required this.action,
    required this.reason,
    this.requiresApproval = false,
  });

  @override
  String toString() {
    return [
      'BUSINESS DECISION',
      'Type: ${type.name}',
      'Action: $action',
      'Reason: $reason',
      'Approval required: $requiresApproval',
    ].join('\n');
  }
}

class EtherBusinessDecisionEngine {
  BusinessDecision decide({
    required String goal,
    required BusinessState state,
  }) {
    final input = goal.trim().toLowerCase();

    if (input.isEmpty) {
      return const BusinessDecision(
        type: BusinessDecisionType.general,
        action: 'Request a business goal.',
        reason: 'No business objective was provided.',
      );
    }

    // 1. CALCULATIONS / ANALYSIS.
    // Calculations are informational and do not authorize spending.
    if (_containsAny(input, [
      'calculate',
      'calculation',
      'calculator',
      'compute',
      'percentage',
      'percent',
      'revenue minus',
      'cost price',
      'selling price',
    ])) {
      return const BusinessDecision(
        type: BusinessDecisionType.calculator,
        action: 'Calculate the requested business figures.',
        reason:
            'Calculations are informational and do not create financial commitments.',
      );
    }

    // 2. FINANCIAL ACTIONS ALWAYS HAVE HIGHEST PRIORITY.
    if (_containsAny(input, [
      'pay',
      'payment',
      'purchase',
      'buy',
      'subscription',
      'advertising budget',
      'spend money',
      'spend',
      'withdraw',
      'charge',
      'order',
    ])) {
      return const BusinessDecision(
        type: BusinessDecisionType.finance,
        action: 'Prepare the financial action for user approval.',
        reason: 'Financial commitments are outside autonomous authority.',
        requiresApproval: true,
      );
    }

    // 2. EXPLICIT RESEARCH INTENT.
    // "research products" is research, not merely product management.
    if (_containsAny(input, [
      'market research',
      'product research',
      'research',
      'find opportunities',
      'competitor',
      'competition',
    ])) {
      return const BusinessDecision(
        type: BusinessDecisionType.research,
        action: 'Research the market and identify opportunities.',
        reason:
            'Research provides information needed for an informed business decision.',
      );
    }

    // 3. PRODUCT / DROPSHIPPING OPERATIONS.
    if (_containsAny(input, [
      'dropshipping',
      'drop shipping',
      'product selection',
      'select products',
      'evaluate products',
      'supplier',
      'online store',
      'ecommerce',
      'e-commerce',
    ])) {
      return const BusinessDecision(
        type: BusinessDecisionType.product,
        action: 'Evaluate products, suppliers, pricing, and margins.',
        reason: 'Product viability should be evaluated before launch.',
      );
    }

    // 4. CONTENT BUSINESS.
    //
    // Content gets its own route so YouTube/TikTok/faceless
    // content businesses are handled by the dedicated
    // ContentBusinessEngine rather than the generic marketing
    // workflow.
    if (_containsAny(input, [
      'faceless',
      'youtube channel',
      'youtube',
      'tiktok',
      'short form content',
      'short-form content',
      'long form content',
      'long-form content',
      'content business',
      'content creation',
      'create videos',
      'make videos',
      'video content',
    ])) {
      return const BusinessDecision(
        type: BusinessDecisionType.content,
        action: 'Plan and prepare the content business workflow.',
        reason:
            'Content production, repurposing, analytics, and publishing preparation are handled by the dedicated content business layer.',
      );
    }

    // 5. MARKETING.
    if (_containsAny(input, [
      'marketing',
      'promotion',
      'content',
      'youtube',
      'social media',
      'advertising',
    ])) {
      return const BusinessDecision(
        type: BusinessDecisionType.marketing,
        action: 'Prepare and execute an organic marketing strategy.',
        reason:
            'Marketing is required to attract customers and generate demand.',
      );
    }

    // 5. CUSTOMER OPERATIONS.
    if (_containsAny(input, [
      'customer',
      'customers',
      'sales',
      'sell',
      'support',
    ])) {
      return const BusinessDecision(
        type: BusinessDecisionType.customer,
        action:
            'Analyze customers and prepare the next customer-facing action.',
        reason: 'Customer activity is necessary for business growth.',
      );
    }

    // 6. CONTINUE EXISTING WORK.
    if (state.pendingActions.isNotEmpty) {
      return const BusinessDecision(
        type: BusinessDecisionType.general,
        action: 'Continue the highest-priority pending business action.',
        reason: 'The business already has unfinished work.',
      );
    }

    // 7. GENERAL BUSINESS DECISION.
    return const BusinessDecision(
      type: BusinessDecisionType.general,
      action: 'Analyze the business goal and create the next actionable step.',
      reason: 'No specialized business decision rule matched the request.',
    );
  }

  bool _containsAny(String input, List<String> terms) {
    return terms.any(input.contains);
  }
}
