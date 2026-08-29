import '../business/business_state.dart';
import '../business/ether_business_autonomy_loop.dart';
import '../agent/ether_plan.dart';
import '../agent/ether_planner.dart';
import '../ai/brain/ether_brain.dart';
import 'core/ether_core_fek.dart';
import 'action/ether_action_fek.dart';
import 'business/ether_business_fek.dart';

enum EtherFEKType { core, action, business }

/// Central coordinator for ETHER's three FEKs.
///
/// FEK-1: Core Intelligence
/// FEK-2: Action & Execution
/// FEK-3: Business & Autonomous Operations
///
/// Architecture:
///
/// FEK-1 → FEK-3 OBSERVE → DECIDE → PLAN
///                         ↓
///                      FEK-2
///                         ↓
///                     EXECUTE
///                         ↓
///                      FEK-3
///                         ↓
///                  MEASURE → LEARN
///
/// Financial actions always stop at the approval boundary.
class EtherFEKCoordinator {
  final EtherBrain brain;
  final EtherCoreFEK core;
  final EtherActionFEK action;
  final EtherBusinessFEK business;
  final EtherPlanner planner;

  late final BusinessState businessState;

  factory EtherFEKCoordinator({
    EtherBrain? brain,
    EtherCoreFEK? core,
    EtherActionFEK? action,
    EtherBusinessFEK? business,
    EtherPlanner? planner,
    BusinessState? businessState,
  }) {
    final sharedBrain = brain ?? EtherBrain();

    final sharedAction = action ?? EtherActionFEK(brain: sharedBrain);

    final sharedBusiness = business ?? EtherBusinessFEK();

    final coordinator = EtherFEKCoordinator._(
      brain: sharedBrain,
      core: core ?? EtherCoreFEK(brain: sharedBrain),
      action: sharedAction,
      business: sharedBusiness,
      planner: planner ?? EtherPlanner(),
    );

    coordinator.businessState = businessState ?? BusinessState();

    return coordinator;
  }

  EtherFEKCoordinator._({
    required this.brain,
    required this.core,
    required this.action,
    required this.business,
    required this.planner,
  });

  Future<void> initialize() async {
    await brain.initialize();
  }

  /// Standard autonomous business request.
  ///
  /// FEK-3 owns the decision and creates the authoritative plan.
  /// FEK-2 executes that exact plan.
  Future<String> processAutonomousBusiness(String input) async {
    return runAutonomousBusinessLoop(input);
  }

  /// Complete cooperative FEK business cycle.
  ///
  /// FEK-3:
  /// OBSERVE → DECIDE → PLAN
  ///
  /// FEK-2:
  /// EXECUTE
  ///
  /// FEK-3:
  /// MEASURE → LEARN
  Future<String> runAutonomousBusinessLoop(String input) async {
    final request = input.trim();

    if (request.isEmpty) {
      return 'I could not process that request.';
    }

    if (route(request) != EtherFEKType.business) {
      return process(request);
    }

    // ============================================================
    // FEK-3
    // OBSERVE → DECIDE → PLAN
    // ============================================================

    final businessResult = await business.runAutonomy(
      goal: request,
      state: businessState,
    );

    final lower = businessResult.output.toLowerCase();

    // ============================================================
    // FINANCIAL SAFETY BOUNDARY
    // ============================================================

    if (businessResult.stage == BusinessLoopStage.waitingApproval ||
        lower.contains('approval required') ||
        lower.contains('financial safety boundary') ||
        lower.contains('stopped at financial boundary')) {
      return businessResult.toString();
    }

    // ============================================================
    // FEK-3 → FEK-2
    // EXACT PLAN HANDOFF
    // ============================================================

    final plan = businessResult.plan;

    if (plan == null || plan.tasks.isEmpty) {
      return [
        businessResult.toString(),
        '',
        'FEK-2 EXECUTION',
        '',
        'No executable tasks were produced.',
      ].join('\n');
    }

    // ============================================================
    // FEK-2
    // EXECUTE
    // ============================================================

    final completedPlan = await action.execute(plan);

    final executionResults = <String>[];

    for (final task in completedPlan.tasks) {
      if (task.result.trim().isNotEmpty) {
        executionResults.add('${task.id}: ${task.result.trim()}');
      }
    }

    // ============================================================
    // FEK-3
    // MEASURE
    // ============================================================

    final measurement = business.autonomy.measure(completedPlan);

    // ============================================================
    // FEK-3
    // LEARN
    // ============================================================

    final decision = business.autonomy.decisionEngine.decide(
      goal: request,
      state: businessState,
    );

    final learning = business.autonomy.learn(
      goal: request,
      decision: decision,
      measurement: measurement,
      state: businessState,
    );

    // ============================================================
    // FINAL RESULT
    // ============================================================

    return [
      businessResult.toString(),
      '',
      'FEK-2 EXECUTION',
      '',
      executionResults.isEmpty
          ? 'FEK-2 completed the permitted execution stage.'
          : executionResults.join('\n\n'),
      '',
      'FEK-3 MEASURE',
      measurement,
      '',
      'FEK-3 LEARN',
      learning,
      '',
      'FEK COOPERATIVE HANDOFF',
      'FEK-3 planned the workflow.',
      'FEK-2 executed the permitted tasks.',
      'FEK-3 measured the execution.',
      'FEK-3 recorded the learning.',
    ].join('\n');
  }

  Future<String> process(String input) async {
    final type = route(input);

    switch (type) {
      case EtherFEKType.business:
        return runAutonomousBusinessLoop(input);

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
