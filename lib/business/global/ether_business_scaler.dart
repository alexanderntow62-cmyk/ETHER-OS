import 'learning/ether_business_learning.dart';

class EtherBusinessScalingDecision {
  final bool shouldScale;
  final String reason;
  final List<String> actions;

  const EtherBusinessScalingDecision({
    required this.shouldScale,
    required this.reason,
    required this.actions,
  });
}

class EtherBusinessScaler {
  const EtherBusinessScaler();

  EtherBusinessScalingDecision evaluate(EtherBusinessLearning learning) {
    final latest = learning.latest;

    if (latest == null) {
      return const EtherBusinessScalingDecision(
        shouldScale: false,
        reason: 'Insufficient business data.',
        actions: [
          'Collect initial measurements.',
          'Validate customer demand.',
          'Measure operating performance.',
        ],
      );
    }

    if (latest.customers == 0) {
      return const EtherBusinessScalingDecision(
        shouldScale: false,
        reason: 'No customers recorded yet.',
        actions: [
          'Improve customer acquisition.',
          'Validate the offer.',
          'Continue market testing.',
        ],
      );
    }

    if (latest.revenue <= 0) {
      return const EtherBusinessScalingDecision(
        shouldScale: false,
        reason: 'Revenue has not yet been established.',
        actions: [
          'Improve conversion.',
          'Test pricing.',
          'Continue customer acquisition.',
        ],
      );
    }

    if (latest.margin < 20) {
      return const EtherBusinessScalingDecision(
        shouldScale: false,
        reason: 'Profit margin is below the scaling threshold.',
        actions: [
          'Improve operating efficiency.',
          'Review pricing.',
          'Reduce unnecessary costs.',
        ],
      );
    }

    return const EtherBusinessScalingDecision(
      shouldScale: true,
      reason: 'Positive revenue, customer activity, and margin detected.',
      actions: [
        'Increase successful customer acquisition activities.',
        'Automate repeatable operations.',
        'Expand to additional markets.',
        'Measure scaling results.',
        'Keep financial commitments behind approval.',
      ],
    );
  }
}
