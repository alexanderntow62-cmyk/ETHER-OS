import 'package:flutter_test/flutter_test.dart';
import 'package:ether_os/business/business_decision_engine.dart';
import 'package:ether_os/business/business_state.dart';
import 'package:ether_os/business/ether_business_operator.dart';

void main() {
  test('faceless YouTube request routes to content business', () {
    final engine = EtherBusinessDecisionEngine();

    final decision = engine.decide(
      goal: 'Build a faceless YouTube channel about AI',
      state: BusinessState(),
    );

    expect(decision.type, BusinessDecisionType.content);
  });

  test('TikTok content request routes to content business', () {
    final engine = EtherBusinessDecisionEngine();

    final decision = engine.decide(
      goal: 'Create TikTok videos about technology',
      state: BusinessState(),
    );

    expect(decision.type, BusinessDecisionType.content);
  });

  test('content business does not bypass financial safety', () async {
    final operator = EtherBusinessOperator();

    final result = await operator.start(
      'Create a faceless YouTube business and spend money on advertising',
    );

    expect(result, contains('FINANCIAL SAFETY BOUNDARY'));
    expect(result, contains('APPROVAL'));
  });

  test(
    'faceless content workflow prepares content without spending money',
    () async {
      final operator = EtherBusinessOperator();

      final result = await operator.start(
        'Create a faceless YouTube and TikTok content business about AI',
      );

      expect(result, contains('CONTENT BUSINESS WORKFLOW'));
      expect(result, contains('SCRIPTS PREPARED'));
      expect(result, contains('SHORT-FORM VERSIONS'));
      expect(result, contains('FINANCIAL SAFETY'));
    },
  );
}
