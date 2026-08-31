import '../../business/business_scheduler.dart';
import '../../business/ether_business_operator.dart';
import '../../business/ether_business_worker.dart';
import '../ether_fek.dart';

class EtherOperationsFEK implements EtherFek {
  final EtherBusinessOperator operator;
  final EtherBusinessWorker worker;
  final BusinessScheduler scheduler;

  EtherOperationsFEK({
    EtherBusinessOperator? operator,
    EtherBusinessWorker? worker,
    BusinessScheduler? scheduler,
  }) : operator = operator ?? EtherBusinessOperator(),
       worker =
           worker ??
           EtherBusinessWorker(operator: operator ?? EtherBusinessOperator()),
       scheduler =
           scheduler ??
           BusinessScheduler(
             worker:
                 worker ??
                 EtherBusinessWorker(
                   operator: operator ?? EtherBusinessOperator(),
                 ),
           );

  @override
  EtherFekType get type => EtherFekType.operations;

  @override
  String get name => 'OPERATIONS FEK';

  @override
  bool canHandle(String input) => input.trim().isNotEmpty;

  @override
  Future<String> handle(String input) async {
    final goal = input.trim();

    if (goal.isEmpty) {
      return 'OPERATIONS FEK\nNo business goal provided.';
    }

    return operator.start(goal);
  }

  Future<String> runWorkerCheck(String input) {
    return worker.performCheck(input);
  }

  Future<String> runScheduledOnce(String input) {
    return scheduler.runOnce(input);
  }

  void startScheduled(String input) {
    scheduler.start(input);
  }

  void stopScheduled() {
    scheduler.stop();
  }

  void dispose() {
    scheduler.dispose();
  }
}

/// Backwards-compatible class-name alias.
typedef EtherOperationsFek = EtherOperationsFEK;
