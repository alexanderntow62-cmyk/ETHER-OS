import 'ether_business_creator.dart';
import 'ether_business_scaler.dart';
import 'ether_business_scorer.dart';
import 'ether_opportunity_engine.dart';
import 'ether_zero_capital_engine.dart';
import 'execution/ether_autonomous_task_queue.dart';
import 'learning/ether_business_learning.dart';
import 'learning/ether_business_measurement.dart';
import 'ether_business_mission_engine.dart';

class EtherGlobalBusinessEngine {
  final EtherOpportunityEngine opportunityEngine;
  final EtherBusinessScorer scorer;
  final EtherZeroCapitalEngine zeroCapitalEngine;
  final EtherBusinessCreator creator;
  final EtherBusinessMissionEngine missionEngine;
  final EtherBusinessScaler scaler;

  final EtherAutonomousTaskQueue taskQueue;
  final EtherBusinessLearning learning;

  EtherGlobalBusinessEngine({
    EtherOpportunityEngine? opportunityEngine,
    EtherBusinessScorer? scorer,
    EtherZeroCapitalEngine? zeroCapitalEngine,
    EtherBusinessCreator? creator,
    EtherBusinessMissionEngine? missionEngine,
    EtherBusinessScaler? scaler,
    EtherAutonomousTaskQueue? taskQueue,
    EtherBusinessLearning? learning,
  }) : opportunityEngine = opportunityEngine ?? const EtherOpportunityEngine(),
       scorer = scorer ?? const EtherBusinessScorer(),
       zeroCapitalEngine = zeroCapitalEngine ?? const EtherZeroCapitalEngine(),
       creator = creator ?? const EtherBusinessCreator(),
       missionEngine = missionEngine ?? const EtherBusinessMissionEngine(),
       scaler = scaler ?? const EtherBusinessScaler(),
       taskQueue = taskQueue ?? EtherAutonomousTaskQueue(),
       learning = learning ?? EtherBusinessLearning();

  String reviewBusiness() {
    final business = creator.createBestBusiness();

    if (business == null) {
      return 'No suitable zero-capital business opportunity found.';
    }

    final mission = missionEngine.createMission(business);

    return [
      'ETHER GLOBAL BUSINESS REVIEW',
      'Business: ${business.opportunity.name}',
      'Mission: ${mission.title}',
      'Scope: ${business.opportunity.scope.name}',
      'Zero capital: ${business.opportunity.zeroCapital}',
      'Globally scalable: ${business.opportunity.globallyScalable}',
      '',
      'MISSION PHASES:',
      ...mission.phases.map((phase) => '- $phase'),
      '',
      'OBJECTIVES:',
      ...business.objectives.map((objective) => '- $objective'),
      '',
      'FINANCIAL SAFETY:',
      'Financial commitments require user approval.',
    ].join('\n');
  }

  List<EtherAutonomousTask> generateInitialTasks() {
    final business = creator.createBestBusiness();

    if (business == null) {
      return const [];
    }

    final mission = missionEngine.createMission(business);

    final tasks = <EtherAutonomousTask>[];

    var index = 1;

    for (final phase in mission.phases) {
      tasks.add(
        EtherAutonomousTask(
          id: 'global_task_$index',
          businessId: business.opportunity.id,
          title: '$phase phase',
          description:
              'Execute the $phase phase for ${business.opportunity.name}.',
          phase: phase,
          requiresFinancialApproval: false,
        ),
      );

      index++;
    }

    taskQueue.addAll(tasks);

    return tasks;
  }

  EtherBusinessScalingDecision evaluateScaling() {
    return scaler.evaluate(learning);
  }

  void recordMeasurement({
    required String businessId,
    double revenue = 0,
    double costs = 0,
    int customers = 0,
    int completedTasks = 0,
  }) {
    learning.record(
      EtherBusinessMeasurement(
        businessId: businessId,
        timestamp: DateTime.now(),
        revenue: revenue,
        costs: costs,
        customers: customers,
        completedTasks: completedTasks,
      ),
    );
  }

  List<EtherAutonomousTask> get pendingTasks => taskQueue.pendingTasks;

  EtherAutonomousTask? get nextTask => taskQueue.nextTask();
}
