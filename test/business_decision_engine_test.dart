import 'package:flutter_test/flutter_test.dart';

import '../lib/business/business_state.dart';
import '../lib/business/business_decision_engine.dart';

void main() {
  test('Business state calculates profit', () {
    final state = BusinessState();

    state.recordRevenue(100);
    state.recordExpense(40);

    expect(state.profit, 60);
  });

  test('Business state tracks pending and completed actions', () {
    final state = BusinessState();

    state.addPendingAction('Research products');

    expect(state.pendingActions, contains('Research products'));

    state.completeAction('Research products');

    expect(state.pendingActions, isNot(contains('Research products')));
    expect(state.completedActions, contains('Research products'));
  });

  test('Decision engine chooses research for research requests', () {
    final engine = EtherBusinessDecisionEngine();

    final decision = engine.decide(
      goal: 'research profitable products',
      state: BusinessState(),
    );

    expect(decision.type, BusinessDecisionType.research);
    expect(decision.requiresApproval, false);
  });

  test('Decision engine chooses product analysis for dropshipping', () {
    final engine = EtherBusinessDecisionEngine();

    final decision = engine.decide(
      goal: 'find products for my dropshipping business',
      state: BusinessState(),
    );

    expect(decision.type, BusinessDecisionType.product);
  });

  test('Financial decisions require approval', () {
    final engine = EtherBusinessDecisionEngine();

    final decision = engine.decide(
      goal: 'buy advertising',
      state: BusinessState(),
    );

    expect(decision.type, BusinessDecisionType.finance);
    expect(decision.requiresApproval, true);
  });

  test('Business state prevents duplicate products', () {
    final state = BusinessState();

    state.addProduct('Phone Case');
    state.addProduct('Phone Case');

    expect(state.products.length, 1);
  });
}
