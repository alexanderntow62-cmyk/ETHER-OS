import 'package:flutter_test/flutter_test.dart';
import '../lib/business/business_state.dart';
import '../lib/business/ether_business_autonomy_loop.dart';

void main() {
  test(
    'business autonomy loop prepares a non-financial business plan',
    () async {
      final state = BusinessState();
      final loop = EtherBusinessAutonomyLoop();

      final result = await loop.run(
        goal: 'research profitable products',
        state: state,
      );

      expect(result.stage, BusinessLoopStage.plan);
      expect(result.output, contains('OBSERVE'));
      expect(result.output, contains('DECIDE'));
      expect(result.output, contains('PLAN'));
      expect(
        result.output,
        contains('FEK-3 created the authoritative business plan.'),
      );
      expect(result.output, contains('FEK-3 does not execute business tasks.'));
      expect(result.output, contains('FEK-3 → FEK-2'));
      expect(
        result.output,
        contains('FEK-2 receives the exact executable plan.'),
      );
      expect(result.plan, isNotNull);
      expect(result.plan!.tasks, isNotEmpty);
    },
  );

  test(
    'business autonomy loop stops financial actions before execution',
    () async {
      final state = BusinessState();
      final loop = EtherBusinessAutonomyLoop();

      final result = await loop.run(goal: 'buy advertising', state: state);

      expect(result.stage, BusinessLoopStage.waitingApproval);
      expect(result.output, contains('APPROVAL REQUIRED'));
      expect(
        result.output,
        contains('will not perform the financial action automatically'),
      );
      expect(
        result.output,
        contains(
          'No purchases, payments, subscriptions, or financial commitments were made.',
        ),
      );
    },
  );

  test('business autonomy loop uses the supplied business state', () async {
    final state = BusinessState();
    final loop = EtherBusinessAutonomyLoop();

    final result = await loop.run(
      goal: 'research profitable products',
      state: state,
    );

    expect(result.stage, BusinessLoopStage.plan);
    expect(
      state.pendingActions,
      contains(
        'Review results of business cycle: research profitable products',
      ),
    );
  });
}
