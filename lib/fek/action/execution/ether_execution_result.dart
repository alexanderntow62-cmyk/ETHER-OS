enum EtherExecutionStatus { completed, blocked, failed }

class EtherExecutionResult {
  final EtherExecutionStatus status;
  final String output;

  const EtherExecutionResult({required this.status, required this.output});

  bool get isCompleted => status == EtherExecutionStatus.completed;

  bool get isBlocked => status == EtherExecutionStatus.blocked;

  bool get isFailed => status == EtherExecutionStatus.failed;

  factory EtherExecutionResult.completed(String output) {
    return EtherExecutionResult(
      status: EtherExecutionStatus.completed,
      output: output,
    );
  }

  factory EtherExecutionResult.blocked(String output) {
    return EtherExecutionResult(
      status: EtherExecutionStatus.blocked,
      output: output,
    );
  }

  factory EtherExecutionResult.failed(String output) {
    return EtherExecutionResult(
      status: EtherExecutionStatus.failed,
      output: output,
    );
  }
}
