import 'ether_business_measurement.dart';

class EtherBusinessLearning {
  final List<EtherBusinessMeasurement> _history = [];

  void record(EtherBusinessMeasurement measurement) {
    _history.add(measurement);
  }

  List<EtherBusinessMeasurement> get history => List.unmodifiable(_history);

  EtherBusinessMeasurement? get latest =>
      _history.isEmpty ? null : _history.last;

  double get totalRevenue =>
      _history.fold(0, (sum, item) => sum + item.revenue);

  double get totalCosts => _history.fold(0, (sum, item) => sum + item.costs);

  double get totalProfit => totalRevenue - totalCosts;

  String recommendation() {
    final current = latest;

    if (current == null) {
      return 'No business measurements available yet.';
    }

    if (current.revenue == 0 && current.customers == 0) {
      return 'Continue validation and customer acquisition.';
    }

    if (current.margin < 10) {
      return 'Improve pricing, delivery efficiency, or operating costs.';
    }

    if (current.customers > 0 && current.margin >= 20) {
      return 'Business shows positive signals. Test controlled scaling.';
    }

    return 'Continue operating and collect more measurements.';
  }
}
