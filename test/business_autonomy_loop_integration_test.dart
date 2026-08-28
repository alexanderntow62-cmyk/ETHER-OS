import 'package:flutter_test/flutter_test.dart';

import '../lib/business/business_state.dart';
import '../lib/business/ether_business_autonomy_loop.dart';
import '../lib/business/ether_business_operator.dart';

void main() {
  test(
    'business autonomy loop completes a non-financial business cycle',
    () async {
      final state = BusinessState();

      final loop = EtherBusinessAutonomyLoop(
        operator: EtherBusinessOperator(state: state),
      );

      final result = await loop.run(
        goal: 'research profitable products',
        state: state,
      );

      expect(result.stage, BusinessLoopStage.completed);
      expect(result.output, contains('OBSERVE'));
      expect(result.output, contains('DECIDE'));
      expect(result.output, contains('PLAN + EXECUTE'));
      expect(result.output, contains('MEASURE'));
      expect(result.output, contains('LEARN'));
      expect(result.output, contains('Recorded business cycle:'));
    },
  );

  test(
    'business autonomy loop stops financial actions before execution',
    () async {
      final state = BusinessState();

      final loop = EtherBusinessAutonomyLoop(
        operator: EtherBusinessOperator(state: state),
      );

      final result = await loop.run(goal: 'buy advertising', state: state);

      expect(result.stage, BusinessLoopStage.waitingApproval);
      expect(result.output, contains('APPROVAL REQUIRED'));
      expect(
        result.output,
        contains('will not perform the financial action automatically'),
      );
    },
  );

  test('business state is shared with the business operator', () async {
    final state = BusinessState();

    final operator = EtherBusinessOperator(state: state);

    final loop = EtherBusinessAutonomyLoop(operator: operator);

    await loop.run(goal: 'research profitable products', state: state);

    expect(operator.state, same(state));
  });
}
