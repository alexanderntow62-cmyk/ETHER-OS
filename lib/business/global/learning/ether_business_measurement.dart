class EtherBusinessMeasurement {
  final String businessId;
  final DateTime timestamp;

  final double revenue;
  final double costs;
  final int customers;
  final int completedTasks;

  const EtherBusinessMeasurement({
    required this.businessId,
    required this.timestamp,
    this.revenue = 0,
    this.costs = 0,
    this.customers = 0,
    this.completedTasks = 0,
  });

  double get profit => revenue - costs;

  double get margin {
    if (revenue == 0) {
      return 0;
    }

    return (profit / revenue) * 100;
  }
}
