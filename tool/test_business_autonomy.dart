// ignore_for_file: avoid_print
import 'package:ether_os/business/ether_business_autonomy_loop.dart';
import 'package:ether_os/business/business_state.dart';

Future<void> main() async {
  final loop = EtherBusinessAutonomyLoop();
  final state = BusinessState();

  final result = await loop.run(
    goal: '''
Build and operate a legitimate zero-capital organic affiliate-marketing business.
Primary distribution: YouTube.
Capital: \$0.
Never spend money.
Never purchase anything.
Never subscribe to paid services.
Never run paid advertising.
Never transfer money.
Financial commitments require approval.
Continue all non-financial autonomous work.
''',
    state: state,
  );

  print('============================================================');
  print('ETHER FULL AUTONOMY LOOP TEST');
  print('============================================================');

  print(result);

  print('');
  print('============================================================');
  print('FEK-3 → FEK-2 PLAN HANDOFF');
  print('============================================================');

  final plan = result.plan;

  if (plan == null) {
    print('NO PLAN RETURNED');
  } else {
    print('Goal: ${plan.goal}');
    print('Task count: ${plan.tasks.length}');
    print('');

    for (var i = 0; i < plan.tasks.length; i++) {
      final task = plan.tasks[i];

      print('TASK ${i + 1}');
      print('ID: ${task.id}');
      print('Goal: ${task.goal}');
      print('Type: ${task.type.name}');
      print('Status: ${task.status.name}');
      print('Requires approval: ${task.isFinancial}');
      print('');
    }

    print('Plan complete: ${plan.isComplete}');
    print('Plan has failed: ${plan.hasFailed}');
  }

  print('');
  print('============================================================');
  print('BUSINESS STATE');
  print('============================================================');

  print('Pending actions: ${state.pendingActions.length}');
  print('Products: ${state.products.length}');
  print('Customers: ${state.customers.length}');
  print('Suppliers: ${state.suppliers.length}');
  print('Revenue: ${state.revenue}');
  print('Expenses: ${state.expenses}');
  print('Profit: ${state.profit}');

  print('============================================================');
}
