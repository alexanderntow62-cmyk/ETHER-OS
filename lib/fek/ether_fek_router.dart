import '../ai/brain/ether_brain.dart';
import '../business/ether_business_operator.dart';
import '../agent/ether_planner.dart';
import 'ether_fek.dart';
import 'cognitive/ether_cognitive_fek.dart';
import 'action/ether_action_fek.dart';
import 'operations/ether_operations_fek.dart';

class EtherFekRouter {
  final EtherCognitiveFEK cognitive;
  final EtherActionFEK action;
  final EtherOperationsFEK operations;

  EtherFekRouter({EtherBrain? brain, EtherBusinessOperator? businessOperator})
    : cognitive = EtherCognitiveFEK(brain: brain, planner: EtherPlanner()),
      action = EtherActionFEK(brain: brain),
      operations = EtherOperationsFEK(operator: businessOperator);

  EtherFek route(String input, {bool? businessIntent}) {
    final goal = input.trim();

    if (goal.isEmpty) {
      return cognitive;
    }

    if (businessIntent == true || _looksLikeBusiness(goal)) {
      return operations;
    }

    if (_looksLikeAction(goal)) {
      return action;
    }

    return cognitive;
  }

  Future<String> handle(String input, {bool? businessIntent}) {
    return route(input, businessIntent: businessIntent).handle(input);
  }

  bool _looksLikeBusiness(String input) {
    final lower = input.toLowerCase();

    const terms = [
      'business',
      'dropshipping',
      'drop shipping',
      'affiliate',
      'profit',
      'customer',
      'product',
      'marketing',
      'sales',
      'store',
      'shopify',
      'woocommerce',
      'printful',
      'make money',
    ];

    return terms.any(lower.contains);
  }

  bool _looksLikeAction(String input) {
    final lower = input.toLowerCase();

    const terms = [
      'open ',
      'launch ',
      'start ',
      'stop ',
      'calculate ',
      'run ',
      'execute ',
      'perform ',
      'create ',
      'delete ',
    ];

    return terms.any(lower.startsWith);
  }
}
