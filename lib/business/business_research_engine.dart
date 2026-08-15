class BusinessResearchResult {
  final String product;
  final double estimatedCost;
  final double estimatedSellingPrice;
  final double estimatedProfit;
  final double estimatedMargin;
  final int demandScore;
  final int competitionScore;
  final int opportunityScore;

  const BusinessResearchResult({
    required this.product,
    required this.estimatedCost,
    required this.estimatedSellingPrice,
    required this.estimatedProfit,
    required this.estimatedMargin,
    required this.demandScore,
    required this.competitionScore,
    required this.opportunityScore,
  });

  String get summary {
    return '$product — '
        'Cost: ${estimatedCost.toStringAsFixed(2)}, '
        'Selling: ${estimatedSellingPrice.toStringAsFixed(2)}, '
        'Profit: ${estimatedProfit.toStringAsFixed(2)}, '
        'Margin: ${estimatedMargin.toStringAsFixed(2)}%, '
        'Demand: $demandScore/100, '
        'Competition: $competitionScore/100, '
        'Opportunity: $opportunityScore/100';
  }
}

class EtherBusinessResearchEngine {
  List<BusinessResearchResult> researchProducts() {
    const products = [
      BusinessResearchResult(
        product: 'Portable LED Desk Lamp',
        estimatedCost: 12,
        estimatedSellingPrice: 29.99,
        estimatedProfit: 17.99,
        estimatedMargin: 60.00,
        demandScore: 82,
        competitionScore: 55,
        opportunityScore: 76,
      ),
      BusinessResearchResult(
        product: 'Magnetic Phone Holder',
        estimatedCost: 7,
        estimatedSellingPrice: 19.99,
        estimatedProfit: 12.99,
        estimatedMargin: 64.98,
        demandScore: 78,
        competitionScore: 68,
        opportunityScore: 71,
      ),
      BusinessResearchResult(
        product: 'Reusable Water Bottle',
        estimatedCost: 9,
        estimatedSellingPrice: 24.99,
        estimatedProfit: 15.99,
        estimatedMargin: 63.99,
        demandScore: 86,
        competitionScore: 72,
        opportunityScore: 74,
      ),
    ];

    return products;
  }

  BusinessResearchResult? selectBestProduct() {
    final products = researchProducts();

    if (products.isEmpty) {
      return null;
    }

    return products.reduce(
      (best, current) =>
          current.opportunityScore > best.opportunityScore ? current : best,
    );
  }

  String createReport() {
    final products = researchProducts();
    final best = selectBestProduct();

    if (best == null) {
      return 'No products found.';
    }

    final lines = <String>['PRODUCT RESEARCH', '', 'Candidates:'];

    for (final product in products) {
      lines.add(product.summary);
    }

    lines.add('');
    lines.add('RECOMMENDED PRODUCT');
    lines.add(best.product);
    lines.add('Opportunity Score: ${best.opportunityScore}/100');
    lines.add('Estimated Profit: ${best.estimatedProfit.toStringAsFixed(2)}');
    lines.add('Estimated Margin: ${best.estimatedMargin.toStringAsFixed(2)}%');

    return lines.join('\n');
  }
}
