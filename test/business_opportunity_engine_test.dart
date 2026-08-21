import 'package:flutter_test/flutter_test.dart';
import '../lib/business/business_market_profile.dart';
import '../lib/business/business_opportunity_engine.dart';

void main() {
  test('ETHER supports Ghana and international markets', () {
    const profile = BusinessMarketProfile(
      market: BusinessMarket.both,
      businessType: BusinessType.service,
      customerType: CustomerType.both,
      capitalRequirement: CapitalRequirement.zero,
    );

    expect(profile.targetsGhana, isTrue);
    expect(profile.targetsInternational, isTrue);
  });

  test('ETHER generates zero-capital opportunities', () {
    final engine = EtherBusinessOpportunityEngine();

    final opportunities = engine.generate(
      market: BusinessMarket.both,
      capital: CapitalRequirement.zero,
    );

    expect(opportunities, isNotEmpty);
    expect(
      opportunities.any(
        (opportunity) =>
            opportunity.name == 'Digital Business Services',
      ),
      isTrue,
    );
  });

  test('ETHER opportunity engine can target both markets', () {
    final engine = EtherBusinessOpportunityEngine();

    final report = engine.createReport(
      market: BusinessMarket.both,
      capital: CapitalRequirement.zero,
    );

    expect(report, contains('GHANA'));
    expect(report, contains('INTERNATIONAL'));
    expect(report, contains('FINANCIAL BOUNDARY'));
    expect(report, contains('require explicit user approval.'));
  });
}
