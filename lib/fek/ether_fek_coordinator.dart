import '../agent/ether_plan.dart';
import '../agent/ether_planner.dart';
import '../ai/brain/ether_brain.dart';
import 'core/ether_core_fek.dart';
import 'action/ether_action_fek.dart';
import 'business/ether_business_fek.dart';
import '../business/ether_autonomous_business_loop.dart';

enum EtherFEKType { core, action, business }

/// Central coordinator for ETHER's three FEKs.
///
/// The coordinator creates one shared Brain and gives that Brain
/// to the FEKs that need cognitive resources.
///
/// FEK-1: Core Intelligence
/// FEK-2: Action & Execution
/// FEK-3: Business & Autonomous Operations
class EtherFEKCoordinator {
  final EtherBrain brain;
  final EtherCoreFEK core;
  final EtherActionFEK action;
  final EtherBusinessFEK business;
  final EtherPlanner planner;
  final EtherAutonomousBusinessLoop autonomousBusiness;

  factory EtherFEKCoordinator({
    EtherBrain? brain,
    EtherCoreFEK? core,
    EtherActionFEK? action,
    EtherBusinessFEK? business,
    EtherPlanner? planner,
    EtherAutonomousBusinessLoop? autonomousBusiness,
  }) {
    final sharedBrain = brain ?? EtherBrain();

    return EtherFEKCoordinator._(
      brain: sharedBrain,
      core: core ?? EtherCoreFEK(brain: sharedBrain),
      action: action ?? EtherActionFEK(brain: sharedBrain),
      business: business ?? EtherBusinessFEK(),
      planner: planner ?? EtherPlanner(),
      autonomousBusiness:
          autonomousBusiness ?? EtherAutonomousBusinessLoop(brain: sharedBrain),
    );
  }

  EtherFEKCoordinator._({
    required this.brain,
    required this.core,
    required this.action,
    required this.business,
    required this.planner,
    required this.autonomousBusiness,
  });

  Future<void> initialize() async {
    await brain.initialize();
  }

  /// Runs a business request through the FEK cooperation layer.
  ///
  /// Core/Business handles understanding and preparation.
  /// Action handles permitted execution.
  /// Financial actions remain blocked by the Business FEK.
  Future<String> processAutonomousBusiness(String input) async {
    final request = input.trim();

    if (request.isEmpty) {
      return 'I could not process that request.';
    }

    if (route(request) != EtherFEKType.business) {
      return process(request);
    }

    // FEK-3 prepares the business workflow first.
    final businessResult = await business.start(request);

    // Financial/approval boundaries stop the workflow here.
    final lower = businessResult.toLowerCase();
    if (lower.contains('approval required') ||
        lower.contains('financial safety boundary') ||
        lower.contains('stopped at financial boundary')) {
      return businessResult;
    }

    // FEK-2 executes only the actions that can be performed autonomously.
    final plan = planner.createPlan(request);

    if (plan.tasks.isEmpty) {
      return businessResult;
    }

    final completedPlan = await action.execute(plan);

    final executionResults = <String>[];

    for (final task in completedPlan.tasks) {
      if (task.result.trim().isNotEmpty) {
        executionResults.add(task.result.trim());
      }
    }

    if (executionResults.isEmpty) {
      return businessResult;
    }

    return [
      businessResult,
      '',
      'FEK COOPERATIVE EXECUTION',
      '',
      executionResults.join('\\n\\n'),
    ].join('\\n');
  }

  /// Runs the full autonomous business execution loop.
  ///
  /// FEK-3 plans the business.
  /// FEK-2 executes permitted steps.
  /// Financial steps pause for user approval.
  Future<String> runAutonomousBusinessLoop(String input) async {
    final request = input.trim();

    if (request.isEmpty) {
      return 'I could not process that request.';
    }

    if (route(request) != EtherFEKType.business) {
      return process(request);
    }

    return autonomousBusiness.run(request);
  }

  Future<String> process(String input) async {
    final type = route(input);

    switch (type) {
      case EtherFEKType.business:
        return business.start(input);

      case EtherFEKType.action:
        final EtherPlan plan = planner.createPlan(input);

        if (plan.tasks.isEmpty) {
          return 'I could not process that request.';
        }

        final completedPlan = await action.execute(plan);

        if (completedPlan.hasFailed) {
          for (final task in completedPlan.tasks.reversed) {
            if (task.result.trim().isNotEmpty) {
              return task.result.trim();
            }
          }

          return 'I could not complete that request.';
        }

        for (final task in completedPlan.tasks.reversed) {
          if (task.result.trim().isNotEmpty) {
            return task.result.trim();
          }
        }

        return 'I completed the request.';

      case EtherFEKType.core:
        return core.process(input);
    }
  }

  EtherFEKType route(String input) {
    final lower = input.toLowerCase();

    const businessTerms = [
      'business',
      'dropshipping',
      'drop shipping',
      'product research',
      'sell products',
      'selling products',
      'store',
      'supplier',
      'revenue',
      'business plan',
      'online store',
      'ecommerce',
      'e-commerce',
      'shopify',
      'shop',
      'website',
    ];

    if (businessTerms.any(lower.contains)) {
      return EtherFEKType.business;
    }

    const actionTerms = [
      'calculate',
      'compute',
      'execute',
      'run',
      'open',
      'close',
      'create',
      'delete',
      'send',
    ];

    if (actionTerms.any(lower.contains)) {
      return EtherFEKType.action;
    }

    return EtherFEKType.core;
  }
}
