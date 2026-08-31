import 'package:flutter_test/flutter_test.dart';
import 'package:ether_os/business/business_research_engine.dart';

void main() {
  test('ETHER researches products and selects the strongest opportunity', () {
    final engine = EtherBusinessResearchEngine();

    final products = engine.researchProducts();
    final best = engine.selectBestProduct();
    final report = engine.createReport();

    expect(products.length, 3);
    expect(best, isNotNull);
    expect(best!.product, 'Portable LED Desk Lamp');
    expect(best.opportunityScore, 76);
    expect(report, contains('PRODUCT RESEARCH'));
    expect(report, contains('RECOMMENDED PRODUCT'));
    expect(report, contains('Portable LED Desk Lamp'));
    expect(report, contains('60.00%'));
  });
}
