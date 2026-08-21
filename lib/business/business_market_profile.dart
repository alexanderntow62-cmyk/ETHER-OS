enum BusinessMarket {
  ghana,
  international,
  both,
}

enum BusinessType {
  product,
  service,
  digital,
  hybrid,
}

enum CustomerType {
  b2c,
  b2b,
  both,
}

enum CapitalRequirement {
  zero,
  low,
  medium,
  high,
}

class BusinessMarketProfile {
  final BusinessMarket market;
  final BusinessType businessType;
  final CustomerType customerType;
  final CapitalRequirement capitalRequirement;

  const BusinessMarketProfile({
    required this.market,
    required this.businessType,
    required this.customerType,
    required this.capitalRequirement,
  });

  bool get targetsGhana =>
      market == BusinessMarket.ghana ||
      market == BusinessMarket.both;

  bool get targetsInternational =>
      market == BusinessMarket.international ||
      market == BusinessMarket.both;

  String get summary {
    return [
      'MARKET: ${market.name.toUpperCase()}',
      'BUSINESS TYPE: ${businessType.name.toUpperCase()}',
      'CUSTOMER TYPE: ${customerType.name.toUpperCase()}',
      'CAPITAL: ${capitalRequirement.name.toUpperCase()}',
      'GHANA CUSTOMERS: ${targetsGhana ? "YES" : "NO"}',
      'INTERNATIONAL CUSTOMERS: ${targetsInternational ? "YES" : "NO"}',
    ].join('\n');
  }
}
