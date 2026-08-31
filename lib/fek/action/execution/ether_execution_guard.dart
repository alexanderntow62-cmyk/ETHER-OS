import '../../../agent/ether_task.dart';

/// FEK-2 execution safety boundary.
///
/// This guard runs BEFORE any executable capability.
/// Financial actions cannot pass automatically.
class EtherExecutionGuard {
  const EtherExecutionGuard();

  bool isFinancial(EtherTask task) {
    if (task.isFinancial) {
      return true;
    }

    final input = task.goal.toLowerCase();

    const financialTerms = [
      'pay',
      'payment',
      'purchase',
      'buy',
      'spend',
      'withdraw',
      'subscription',
      'subscribe',
      'advertising budget',
      'paid advertising',
      'pay for advertising',
      'transfer money',
      'send money',
      'charge',
      'order',
      'deposit',
      'invest',
      'refund',
    ];

    return financialTerms.any(input.contains);
  }

  String blockMessage() {
    return 'FEK-2 BLOCKED: Financial action requires user approval.';
  }
}
