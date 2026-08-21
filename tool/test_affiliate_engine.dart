import '../lib/business/ether_business_engine.dart';

Future<void> main() async {
  final engine = EtherBusinessEngine();

  final task = engine.createTask(
    id: 'affiliate_test_1',
    goal: 'Start an affiliate marketing business with no money',
  );

  final result = await engine.execute(task);

  print(result);
  print('');
  print('FINAL STATUS: ${task.status.name}');
  print('REQUIRES APPROVAL: ${task.requiresApproval}');
}
