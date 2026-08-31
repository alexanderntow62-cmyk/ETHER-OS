import 'package:flutter_test/flutter_test.dart';
import 'package:ether_os/business/low_capital_business_strategy.dart';

void main() {
  test('ETHER identifies a zero-capital opportunity', () {
    final strategy = EtherLowCapitalBusinessStrategy();

    const opportunity = BusinessOpportunity(
      name: 'Organic Affiliate Marketing',
      capital: CapitalRequirement.zero,
      requiresInventory: false,
      directToCustomer: false,
      requiresPaidAdvertising: false,
      requiresSubscription: false,
      estimatedUpfrontCost: 0,
    );

    final result = strategy.evaluate(opportunity);

    expect(result.status, BusinessOpportunityStatus.suitable);
    expect(result.score, greaterThanOrEqualTo(90));
    expect(result.summary, contains('ZERO'));
  });

  test('ETHER flags low-cost dropshipping for review', () {
    final strategy = EtherLowCapitalBusinessStrategy();

    const opportunity = BusinessOpportunity(
      name: 'Direct-to-Customer Dropshipping',
      capital: CapitalRequirement.low,
      requiresInventory: false,
      directToCustomer: true,
      requiresPaidAdvertising: false,
      requiresSubscription: true,
      estimatedUpfrontCost: 15,
    );

    final result = strategy.evaluate(opportunity);

    expect(result.status, BusinessOpportunityStatus.reviewRequired);
    expect(result.summary, contains('Direct-to-Customer'));
  });

  test('ETHER rejects expensive inventory businesses', () {
    final strategy = EtherLowCapitalBusinessStrategy();

    const opportunity = BusinessOpportunity(
      name: 'Inventory Retail Store',
      capital: CapitalRequirement.high,
      requiresInventory: true,
      directToCustomer: true,
      requiresPaidAdvertising: true,
      requiresSubscription: true,
      estimatedUpfrontCost: 500,
    );

    final result = strategy.evaluate(opportunity);

    expect(result.status, BusinessOpportunityStatus.reject);
  });

  test('ETHER never authorizes financial spending', () {
    final strategy = EtherLowCapitalBusinessStrategy();

    const opportunity = BusinessOpportunity(
      name: 'Paid Store',
      capital: CapitalRequirement.low,
      requiresInventory: false,
      directToCustomer: true,
      requiresPaidAdvertising: false,
      requiresSubscription: true,
      estimatedUpfrontCost: 20,
    );

    final report = strategy.createReport([opportunity]);

    expect(report, contains('FINANCIAL SAFETY'));
    expect(report, contains('require approval'));
  });
}
