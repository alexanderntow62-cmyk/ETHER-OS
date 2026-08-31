import '../business/business_state.dart';
import '../business/ether_business_autonomy_loop.dart';
import '../agent/ether_task.dart';
import '../agent/ether_planner.dart';
import '../ai/brain/ether_brain.dart';

import 'ether_fek.dart';

export 'ether_fek.dart';
import 'core/ether_core_fek.dart';
import 'action/ether_action_fek.dart';
import 'business/ether_business_fek.dart';
import 'cognitive/ether_cognitive_fek.dart';
import 'operations/ether_operations_fek.dart';

/// Central coordinator for ETHER.
///
/// PRIMARY THREE-FEK ARCHITECTURE
///
/// FEK-1: CORE
///   Intelligence, conversation, reasoning foundation.
///
/// FEK-2: ACTION
///   Execution of permitted executable tasks.
///
/// FEK-3: BUSINESS
///   OBSERVE → DECIDE → PLAN → FEK-2 → MEASURE → LEARN.
///
/// SUPPORTING FEKs
///
/// Cognitive FEK:
///   Planning / cognitive preparation capability.
///
/// Operations FEK:
///   Business operation scheduling and worker execution.
///
/// Financial actions NEVER execute automatically.
/// They stop at the approval boundary.
class EtherFEKCoordinator {
  final EtherBrain brain;

  /// FEK-1
  final EtherCoreFEK core;

  /// FEK-2
  final EtherActionFEK action;

  /// FEK-3
  final EtherBusinessFEK business;

  /// Supporting cognitive FEK.
  final EtherCognitiveFEK cognitive;

  /// Supporting operations FEK.
  final EtherOperationsFEK operations;

  final EtherPlanner planner;

  late final BusinessState businessState;

  factory EtherFEKCoordinator({
    EtherBrain? brain,
    EtherCoreFEK? core,
    EtherActionFEK? action,
    EtherBusinessFEK? business,
    EtherCognitiveFEK? cognitive,
    EtherOperationsFEK? operations,
    EtherPlanner? planner,
    BusinessState? businessState,
  }) {
    final sharedBrain = brain ?? EtherBrain();

    final sharedAction = action ?? EtherActionFEK(brain: sharedBrain);

    final sharedCognitive =
        cognitive ??
        EtherCognitiveFEK(
          brain: sharedBrain,
          planner: planner ?? EtherPlanner(),
        );

    final sharedOperations = operations ?? EtherOperationsFEK();

    final sharedPlanner = planner ?? EtherPlanner();

    final coordinator = EtherFEKCoordinator._(
      brain: sharedBrain,
      core: core ?? EtherCoreFEK(brain: sharedBrain),
      action: sharedAction,
      business: business ?? EtherBusinessFEK(),
      cognitive: sharedCognitive,
      operations: sharedOperations,
      planner: sharedPlanner,
    );

    coordinator.businessState = businessState ?? BusinessState();

    return coordinator;
  }

  EtherFEKCoordinator._({
    required this.brain,
    required this.core,
    required this.action,
    required this.business,
    required this.cognitive,
    required this.operations,
    required this.planner,
  });

  Future<void> initialize() async {
    await brain.initialize();
  }

  // ============================================================
  // FEK-3 AUTONOMOUS BUSINESS LOOP
  // ============================================================

  Future<String> processAutonomousBusiness(String input) async {
    return runAutonomousBusinessLoop(input);
  }

  Future<String> runAutonomousBusinessLoop(String input) async {
    final request = input.trim();

    if (request.isEmpty) {
      return 'I could not process that request.';
    }

    if (route(request) != EtherFekType.business) {
      return process(request);
    }

    // ==========================================================
    // FEK-3: OBSERVE → DECIDE → PLAN
    // ==========================================================

    final businessResult = await business.runAutonomy(
      goal: request,
      state: businessState,
    );

    final lower = businessResult.output.toLowerCase();

    // ==========================================================
    // FINANCIAL SAFETY BOUNDARY
    // ==========================================================

    if (businessResult.stage == BusinessLoopStage.waitingApproval ||
        lower.contains('approval required') ||
        lower.contains('financial safety boundary') ||
        lower.contains('stopped at financial boundary')) {
      return businessResult.toString();
    }

    // ==========================================================
    // FEK-3 → FEK-2
    // EXACT PLAN HANDOFF
    // ==========================================================

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

    // FEK-3 never executes.
    // FEK-2 receives the exact plan.
    final completedPlan = await action.execute(plan);

    final executionResults = <String>[];

    for (final task in completedPlan.tasks) {
      if (task.result.trim().isNotEmpty) {
        executionResults.add('${task.id}: ${task.result.trim()}');
      }
    }

    // ==========================================================
    // FEK-3: MEASURE
    // ==========================================================

    final measurement = business.autonomy.measure(completedPlan);

    // ==========================================================
    // FEK-3: LEARN
    // ==========================================================

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

    // Informational calculator requests should return only the
    // calculator result to the user. Internal FEK telemetry,
    // including learning data, must not leak into this response.
    if (plan.tasks.length == 1 &&
        plan.tasks.first.type == EtherTaskType.calculator) {
      final result = completedPlan.tasks.first.result.trim();
      if (result.isNotEmpty) {
        return result;
      }
      return 'The calculation could not be completed.';
    }

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

  // ============================================================
  // GENERAL PROCESS ROUTER
  // ============================================================

  Future<String> process(String input) async {
    final request = input.trim();

    if (request.isEmpty) {
      return 'I could not process that request.';
    }

    final type = route(request);

    switch (type) {
      case EtherFekType.business:
        return runAutonomousBusinessLoop(request);

      case EtherFekType.action:
        final plan = planner.createPlan(request);

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

      case EtherFekType.cognitive:
        return cognitive.handle(request);

      case EtherFekType.operations:
        return operations.handle(request);

      case EtherFekType.core:
        return core.process(request);
    }
  }

  // ============================================================
  // ROUTING
  // ============================================================

  EtherFekType route(String input) {
    final lower = input.trim().toLowerCase();

    // ----------------------------------------------------------
    // OPERATIONS — checked FIRST.
    //
    // This is important because phrases such as
    // "schedule a business cycle" contain the word "business".
    // Scheduling/worker/automation requests belong to Operations.
    // ----------------------------------------------------------
    const operationsTerms = [
      'schedule',
      'scheduled',
      'scheduler',
      'worker check',
      'business operations',
      'operations',
      'run worker',
      'start worker',
      'stop worker',
      'automation cycle',
      'business cycle',
      'scheduled cycle',
    ];

    if (operationsTerms.any(lower.contains)) {
      return EtherFekType.operations;
    }

    // ----------------------------------------------------------
    // BUSINESS
    // ----------------------------------------------------------
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
      'affiliate',
      'marketing',
      'customer',
      'customers',
      'sales',
      'profit',
    ];

    if (businessTerms.any(lower.contains)) {
      return EtherFekType.business;
    }

    // ----------------------------------------------------------
    // COGNITIVE
    // ----------------------------------------------------------
    const cognitiveTerms = [
      'make a plan',
      'create a plan',
      'planning',
      'plan this',
      'analyze this',
      'analyse this',
      'reason about',
      'think through',
      'break this down',
      'strategy',
      'strategize',
    ];

    if (cognitiveTerms.any(lower.contains)) {
      return EtherFekType.cognitive;
    }

    // ----------------------------------------------------------
    // ACTION
    // ----------------------------------------------------------
    const actionTerms = [
      'calculate',
      'compute',
      'execute',
      'open',
      'close',
      'create',
      'delete',
      'send',
    ];

    if (actionTerms.any(lower.contains)) {
      return EtherFekType.action;
    }

    // ----------------------------------------------------------
    // DEFAULT
    // ----------------------------------------------------------
    return EtherFekType.core;
  }
}
