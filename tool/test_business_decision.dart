// ignore_for_file: avoid_print
import 'package:ether_os/business/business_decision_engine.dart';
import 'package:ether_os/business/business_state.dart';

void main() {
  final engine = EtherBusinessDecisionEngine();
  final state = BusinessState();

  final safeMission = engine.decide(
    goal: '''
Build and operate a legitimate zero-capital organic affiliate-marketing business.
Never spend money.
Never purchase anything.
Financial commitments require approval.
Primary distribution is YouTube.
''',
    state: state,
  );

  final financialAction = engine.decide(
    goal: 'Buy advertising for the business.',
    state: state,
  );

  print('=== SAFE AUTONOMOUS MISSION ===');
  print(safeMission);
  print('');

  print('=== ACTUAL FINANCIAL ACTION ===');
  print(financialAction);
}
